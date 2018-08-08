#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 28 14:58:35 2018

@author: jack
"""

import numpy as np
import networkx as nx
from sklearn.neighbors import NearestNeighbors
from sklearn.cluster import KMeans
from sklearn.cluster import DBSCAN
from sklearn.metrics import silhouette_score, silhouette_samples
from matplotlib import pyplot as plt
import time

class Timer:
    def __enter__(self):
        self.start = time.time()
        return self

    def __exit__(self, *args):
        self.end = time.time()
        self.interval = self.end - self.start

def normalise(data):
    res1 = data - np.amin(data)
    rng = np.amax(data) - np.amin(data)
    return res1/rng

def continuous_similarity(v1, v2):
    return 1 - np.linalg.norm(v1 - v2)

def calculate_edges(knn_indices, feature_mtx, distance_mtx):
    result = np.zeros_like(knn_indices).astype('float64')
    normed_distances = normalise(distance_mtx)
    for i in range(knn_indices.shape[0]):
        for j in range(knn_indices.shape[1]):
            result[i, j] = 1 - normed_distances[i, j]
    return result

def extract_neighbours(filename):
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

# A parameter-free community detection method based on
# centrality and dispersion of nodes in complex networks
# Eq. 1 : S = (A + I)^tau, Sbar_ij = Sij / sqrt(sum_j Sij^2)
def signal_similarity_mtx(A, tau):
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
    P = A
    for i in range(A.shape[0]):
        P[:, i] /= np.sum(P[:, i])
    return P

def min_dist(v, S):
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
    denominator = np.amax(v)*np.amax(deltas)
    numerator = np.multiply(v.squeeze(), deltas.squeeze())
    return (numerator/denominator).transpose()

def k_largest(arr, k):
    return np.argsort(arr, axis=0)[:k]

timer_strs= ['Loading data',
             'Knn',
             'Graph generation',
             'Signal similarity matrix',
             'Transition matrix',
             'Pagerank',
             'CV',
             'Kmeans']

l = 0
x = 0
for i in timer_strs:
    if len(i) > l:
        l = len(i)
        
space_str_len = (l + 2)

def display_time(t):
    global x
    print(timer_strs[x] + ':' + ' '*(space_str_len - len(timer_strs[x])),
          str(t.interval)[:6])
    x += 1
    
def recursive_edge_add(G, d, depth):
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

def logistic_fn(normalised_vector):
    res = 1/(1+np.exp(-30*(normalised_vector - 0.25)))
    return res

def extract_root(path):
    folder_lst = path.split("/")
    root = ""
    for idx, folder in enumerate(folder_lst):
        if idx < len(folder_lst - 1):
            root += folder + "/"
            
    return root

##############
# PARAMETERS #
##############
knn_fraction = 1/10     # Fraction of nearest neighbours
recursive_depth = 1     # Depth to 'crawl' neighbours for adding edges
tau = 10                # Signal similarity iteration count
beta = 0.0              # Prob of random hop for PageRank
n_clusters = 5         # Clusters to plot
    
##################
# INITIALISATION #
##################
with Timer() as t:
    root = "../share/output/poster/"
    
    # Order: Index, sx, sy, length scale, median intensity
    seed_info = np.loadtxt(root + "CVDseeds.txt", skiprows=3)[:, 1:]
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
    for k in range(2, 15):
        largest_k_indexes = k_largest(CV, k)
        starting_vectors = np.zeros((k, S.shape[1]))
        for i in range(k):
            starting_vectors[i, :] = S[largest_k_indexes[i], :]
        res = KMeans(k, init=starting_vectors, n_init=1).fit(S)
        labels = res.labels_
        sc = silhouette_score(S, labels, metric="euclidean")
        print("For n_clusters={}, The Silhouette Coefficient is {}".format(k,
              sc))
        
        # Display graphs of silhouette scores
        """
        fig, ax1 = plt.subplots(1, 1)
        fig.set_size_inches(10, 7)
        ax1.set_xlim([-0.1, 1])
        ax1.set_ylim([0, len(feature_mtx) + (k + 1) * 12])
        sv = silhouette_samples(feature_mtx, labels)
        
        yl = 12
        for i in range(k):
            ith_sv = sv[labels == i]
            ith_sv.sort()
            cluster_len = ith_sv.shape[0]
            yu = yl + cluster_len
            
            ax1.fill_betweenx(np.arange(yl, yu), 0, ith_sv, alpha=0.8)
            
            ax1.text(-0.05, yl + 0.5*cluster_len, str(i))
            yl = yu + 12
        
        ax1.set_title('Silhouette plots')
        """
    
    # Save results of knn-enhance    
    k = n_clusters
    print("Saving with k =", k)
    largest_k_indexes = k_largest(CV, k)
    starting_vectors = np.zeros((k, S.shape[1]))
    for i in range(k):
        starting_vectors[i, :] = S[largest_k_indexes[i], :]
    res = KMeans(k, init=starting_vectors, n_init=1).fit(S).labels_
    
    saveres = np.zeros_like(res)
    avg_ls = np.zeros((k, 2))
    avg_ls[:, 0] = np.arange(k)
    
    ls = seed_info[:, 1].squeeze()
    for lb in range(k):
        avg_ls[lb, 1] = np.mean(ls[np.where(res == lb)])
    avg_ls = avg_ls[avg_ls[:,1].argsort()]
    for lb in range(k):
        saveres[np.where(res == avg_ls[lb, 0])] = lb
    
    np.savetxt(root + "clusters.txt", saveres, fmt="%i")
display_time(t)