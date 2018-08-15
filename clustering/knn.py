#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
@date Created on Sat Jul 28 14:58:35 2018
@author: Jack Scantlebury
@brief Runs knn-enhance on the output of VOISE.

This script must be run with a minimum of one argument, which is the path to
the directory containing the output of VOISE (CVseeds.txt and
CVneighbours.txt). A second optional argument is the number of clusters (k)
to use - the value of k giving the highest silhouette score will be used in
lieu of this.

The output is a file named clusters.txt, which is a list of cluster IDs for
each VR indexed according to Sk in the VD Matlab struct.

-------------------------------------------------------------------------------
KNN-ENHANCE ALGORITHM MODIFIED FROM:
Caiyan Jia et al.
“Node Attribute-enhanced Community Detection in Complex Networks”.
Scientific Reports 7.1 (2017).
doi: 10.1038/s41598-017-02751-8
-------------------------------------------------------------------------------
"""

import argparse
import numpy as np
import networkx as nx
from sklearn.neighbors import NearestNeighbors
from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.metrics import silhouette_score, silhouette_samples
from matplotlib import pyplot as plt
import time

class Timer:
    """
    Class for timing parts of code. Interval is recorded upon destruction
    of object.
    """
    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, *args):
        self.end = time.time()
        self.interval = self.end - self.start

def normalise(data):
    """
    Puts all data in input in the interval [0, 1]
    """
    res1 = data - np.amin(data)
    rng = np.amax(data) - np.amin(data)
    return res1/rng

def calculate_edges(knn_indices, feature_mtx, distance_mtx):
    """
    Adds edges to graph from knn results. Closer results in vector space give
    edges with weights closer to 1.
    """
    result = np.zeros_like(knn_indices).astype('float64')
    normed_distances = normalise(distance_mtx)
    for i in range(knn_indices.shape[0]):
        for j in range(knn_indices.shape[1]):
            result[i, j] = 1 - normed_distances[i, j]
    return result

def extract_neighbours(filename):
    """
    Utility function for extracting neighbour relationships into dictionary
    from VOSIE output (CVDneighbours.txt)
    """
    d = {}
    n = 0
    with open(filename, 'r') as o:
        for line in o.readlines():
            if len(line) > 1:
                if line[0] == 'N':
                    neighbour_str = line.split('{')[1].split('}')[0]
                    neighbour_lst = []
                    for num_str in neighbour_str.split():
                        neighbour_lst.append(int(num_str) - 1)
                    d.update({ n : np.array(neighbour_lst) })
                    n += 1
    return d

def signal_similarity_mtx(A, tau):
    """
    Eq. 1 : S = (A + I)^tau, Sbar_ij = Sij / sqrt(sum_j Sij^2)
    Signal similarity matrix from doi: 10.1038/s41598-017-02751-8
    
    Parameters:
        A:   Adjacency matrix
        tau: Number of iterations for signal to travel
            
    Returns:
        Signal similarity matrix
    """
    I = np.identity(A.shape[0]).astype('f4')
    result = (A + I).astype('f4')
    for i in range(tau):
        result = (result @ (A + I)).astype('f4')
        
    for row in range(A.shape[0]):
        denominator = 0
        for col in range(A.shape[1]):
            denominator += result[row, col]**2
        denominator = np.sqrt(denominator)
        result[row, :] /= denominator
    return result

def sq_distance(v1, v2):
    return sum(v1*v2.transpose())

def calculate_pagerank(P, S, B, tol):
    """
    Calculates PageRank using iterative method.
    Parameters:
        P:    Transition matrix
        S:    Signal similarity matrix
        B:    Beta (probability of random hop)
        tol:  Iterations stop when norm of difference in pagerank between
              iterations is below tol
    """
    delta = 1
    ns = P.shape[0]
    pr_vec = np.ones((ns, 1)) / ns
    ones = np.ones_like(P)
    while delta > tol:
        pr_vec_new = ((1 - B)*P + ones*B/ns) @ (pr_vec)
        pr_vec_new /= np.sum(pr_vec_new)
        diff = pr_vec_new - pr_vec
        delta = 0
        for i in range(len(diff)):
            delta += diff[i]**2
        pr_vec = pr_vec_new
    """  
    for i in range(len(pr_vec)):
        other = 0
        pi = pr_vec[i]
        for j in range(len(pr_vec)):
            if i != j:
                other += np.exp(-np.linalg.norm(S[i, :] - S[j, :])/pi)
        pr_vec[i] = pi + other
    """    
    return pr_vec

def transition_matrix(A):
    """
    Transition matrix is essentially a normalised adjacency matrix, such that
    the columns can be treated as probabilities
    
    Parameters:
        A:    Adjacency matrix
    """
    P = A
    for i in range(A.shape[0]):
        P[:, i] /= np.sum(P[:, i])
    return P

def min_dist(v, S):
    """
    Finds the minimum distance (delta) in vector space between each vector and
    another vector with a higher PageRank
    
    Paramters:
        v:    PageRank vector
        S:    Signal similarity matrix
    Returns:
        Delta values for all vectors
    """
    dist_mtx = 1e300*np.ones_like(S)
    for i in range(S.shape[0]):
        for j in range(S.shape[0]):
            if v[i] < v[j]:
                dist_mtx[i, j] = np.linalg.norm(S[i, :] - S[j, :])
    result_mtx = np.zeros((S.shape[0], 2))
    result_mtx[:, 0] = range(S.shape[0])
    for i in range(S.shape[0]):
        result_mtx[i, 1] = np.amin(dist_mtx[i, :])
    result_mtx[np.argmax(v), 1] = np.amax(
            result_mtx[:,1][result_mtx[:, 0] != np.argmax(v)])
    return result_mtx[:, 1]

def calculate_CV(v, deltas):
    """
    Calculates community value for all vectors.
    
    Paramters:
        v:      PageRank
        deltas: Result of min_dist function.
    Returns:
        Community value rankings for all vectors
    """
    denominator = np.amax(v)*np.amax(deltas)
    numerator = np.multiply(v.squeeze(), deltas.squeeze())
    return (numerator/denominator).transpose()

def k_largest(arr, k):
    """
    Returns k largest values in an array
    """
    return np.argsort(arr, axis=0)[:k]

# For displaying timing information
timer_strs= ['Loading data',
             'Knn',
             'Graph generation',
             'Signal similarity matrix',
             'Transition matrix',
             'Pagerank',
             'Community Value',
             'Kmeans',
             'TOTAL CLUSTERING TIME']

# For displaying timing information
l = 0
x = 0
for i in timer_strs:
    if len(i) > l:
        l = len(i)   
space_str_len = (l + 2)

# For displaying timing information
def display_time(t):
    global x
    print(timer_strs[x] + ':' + ' '*(space_str_len - len(timer_strs[x])),
          str(t.interval)[:6], 's')
    x += 1
    
# Recursive edge addition, described in project report
def recursive_edge_add(G, d, depth):
    """
    Recursively walks through neighbour graph result from VOISE and adds
    edges (where none already exist) with weights depending on the distance
    which has had to be walked.
    
    Parameters:
        G:     Networkx Graph object with all nodes in place
        d:     Dictionary of neighbour relationships (from extract_neighbours)
        depth: Depth of walk at which to truncate (recommended 5 or lower)
        
    Returns:
        Graph with edges added from walking process
    """
    A = G
    for key, value in d.items():
        for i in range(1, depth + 1):
            weight = 1/(i**1)
            if i == 1:
                neighbours = value
            else:
                n = []
                for nei in neighbours:
                    v = d[nei]
                    for it in v:
                        n.append(it)
                neighbours = np.array(n)
            for v in neighbours:
                try:
                    A[key][v]['weight']
                except Exception:
                    A.add_edge(key, v, weight=weight)        
    return A

# Unused in the end
def logistic_fn(normalised_vector, phi, i0):
    """
    (UNUSED) Logistic function
    
    Parameters:
        normalised_vector: Normalised vector of input values
        phi:               Steepness of logistic curve
        i0:                Position of middle of logistic curve
        
    Returns:
        Logistic transform of data in normalised_vector
    """
    res = 1/(1+np.exp(-phi*(normalised_vector - i0)))
    return res

##############
# PARAMETERS #
##############
knn_fraction = 1/10     # Fraction of nearest neighbours
recursive_depth = 1     # Depth to 'crawl' neighbours for adding edges
tau = 10                # Signal similarity iteration count
beta = 0.0              # Prob of random hop for PageRank
    
##################
# INITIALISATION #
##################
with Timer() as total_time:
    with Timer() as t:
        
        # Set up command line argument for getting root directory
        parser = argparse.ArgumentParser(
                description='Performs knn-enhance clustering.')
        
        parser.add_argument('root', metavar='root', type=str,
                            nargs=1) # required
        
        parser.add_argument('n_clusters', metavar='N', type=int, nargs='?',
                            default=-1) #optional
        try:
            root = parser.parse_args().root[0]
            n_clusters = parser.parse_args().n_clusters    
        except SystemExit:
            raise RuntimeError("This script must be called with at least"
                               " 1 argument. This should be the output"
                               " directory of the VOISE algorithm including"
                               " CVDseeds.txt and CVDneighbours.txt. For"
                               " example:\n\n\t python knn.py"
                               " ../share/output/north_proj/")
        
        if root[-1] != "/" :
            root += "/"
            
        # Order: Index, sx, sy, length scale, median intensity
        seed_info = np.loadtxt(root + "CVDseeds.txt", skiprows=3)[:, 3:]
        d = extract_neighbours(root + "CVDneighbours.txt")
        
        # Length scale and median intensity
        feature_mtx = np.zeros((seed_info.shape[0], seed_info.shape[1] + 0))
        
        ns = feature_mtx.shape[0] # Number of seeds
        knn_neighbours = np.round(ns*knn_fraction).astype('int32')
        for i in range(seed_info.shape[1]):
            feature_mtx[:, i] = normalise(seed_info[:, i])
    
    display_time(t)
    
    ########
    # k-NN #
    ########
    with Timer() as t:
        nbrs = NearestNeighbors(n_neighbors=knn_neighbours + 1,
                                algorithm='auto').fit(feature_mtx)
        distances, indices = nbrs.kneighbors(feature_mtx)
        indices = indices[:, 1:]
        distances = distances[:, 1:]
    display_time(t)
    
    #######################################
    # Generate augmented adjacency matrix #
    #######################################
    with Timer() as t:
        cos_sim_mtx = calculate_edges(indices, feature_mtx, distances)
        
        # Create and initialise graph with node info from VD
        G = nx.Graph(directed=True)
        G.add_nodes_from(range(ns))
    
        # Walk neighbours adding edges with successively lower weights
        G = recursive_edge_add(G, d, recursive_depth)    
            
        # Add in node value (virtual?) edges from knn results
        for u in range(ns):
            for v_idx in range(knn_neighbours):
                v = indices[u, v_idx]
                if not G.has_edge(u, v):
                    G.add_edge(u, v, weight=cos_sim_mtx[u, v_idx])
                   
    display_time(t)
        
    #####################
    # Signal similarity #
    #####################
    with Timer() as t:
        A = nx.adjacency_matrix(G).todense()
        S = signal_similarity_mtx(A, tau)
    display_time(t)
    
    #####################
    # Transition matrix #
    #####################
    with Timer() as t:
        P = transition_matrix(A)
    display_time(t)
    
    ######################
    # Calculate PageRank #
    ######################
    with Timer() as t:
        v = calculate_pagerank(P, S, beta, 1e-9)
    display_time(t)
    
    ######################################
    # Calculate deltas, community values #
    ######################################
    with Timer() as t:
        deltas = min_dist(v, S)
        CV = calculate_CV(v, deltas)
    display_time(t)
    
    ######################
    # k-means clustering #
    ######################
    with Timer() as t:   
        argmax_sc = -1
        max_sc = -2
        for k in range(2, 15):
            largest_k_indexes = k_largest(CV, k)
            starting_vectors = np.zeros((k, S.shape[1]))
            for i in range(k):
                starting_vectors[i, :] = S[largest_k_indexes[i], :]
            res = KMeans(k, init=starting_vectors, n_init=1).fit(S)
            labels = res.labels_
            sc = silhouette_score(S, labels, metric="euclidean")
            if sc > max_sc:
                max_sc = sc
                argmax_sc = k
                
                
        ###############################
        # Save results of knn-enhance #
        ###############################
        
        # If k specified in command line, use that, else k with best mean sc
        if n_clusters == -1:
            k = argmax_sc
        else:
            k = n_clusters
            
        # Choose vectors with best CV values as initial mean vectors    
        largest_k_indexes = k_largest(CV, k)
        
        # Populate initial mean vectors
        starting_vectors = np.zeros((k, S.shape[1]))
        for i in range(k):
            starting_vectors[i, :] = S[largest_k_indexes[i], :]
            
        # Perform k-means in the usual way (except using S as input vecs)
        res = KMeans(k, init=starting_vectors, n_init=1).fit(S).labels_
        
        # Easier to reorder labels in size order here for better ML display
        saveres = np.zeros_like(res)
        avg_ls = np.zeros((k, 2))
        avg_ls[:, 0] = np.arange(k)
        
        ls = seed_info[:, 1].squeeze()
        for lb in range(k):
            avg_ls[lb, 1] = np.mean(ls[np.where(res == lb)])
        avg_ls = avg_ls[avg_ls[:,1].argsort()]
        for lb in range(k):
            saveres[np.where(res == avg_ls[lb, 0])] = lb
        sc = str(silhouette_score(S, res, metric="euclidean"))[:5]

        # Save results
        np.savetxt(root + "clusters.txt", saveres, fmt="%i")
        
    display_time(t)
    print("For k = {}, the mean silhouette coefficient is {}".format(k,
                  sc))
    
display_time(total_time)
