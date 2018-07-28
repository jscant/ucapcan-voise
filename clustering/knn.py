#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 28 14:58:35 2018

@author: jack
"""

import numpy as np
import networkx as nx
from sklearn.neighbors import NearestNeighbors

def normalise(data):
    res1 = data - np.amin(data)
    rng = np.amax(data) - np.amin(data)
    return res1/rng

def cosine_similarity(v1, v2):
    numerator = np.dot(v1, v2)
    denominator = np.linalg.norm(v1)*np.linalg.norm(v2)
    return numerator/denominator

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

# Pagerank
def signal_similarity_mtx(A, tau):
    I = np.identity(A.shape[0])
    result = A + I
    for i in range(tau):
        result = result.dot(A + I)
        
    for row in range(A.shape[1]):
        denominator = np.sqrt(np.sum(result[row, :]*result[row, :].transpose()))
        result[row, :] /= denominator
        
    return result

intensities = np.loadtxt("Sop.txt")
seed_info = np.loadtxt("CVDseeds.txt", skiprows=3)[:, 1:] # sx sy ls mi

# Intensity, Sx, Sy, Ls, Mi
feature_mtx = np.zeros((seed_info.shape[0], 1 + seed_info.shape[1]))

ns = feature_mtx.shape[0]
knn_neighbours = 10

feature_mtx[:, 0] = normalise(intensities)
for i in range(seed_info.shape[1]):# - 2):
    feature_mtx[:, i + 1] = normalise(seed_info[:, i])

nbrs = NearestNeighbors(n_neighbors=knn_neighbours + 1, algorithm='auto').fit(feature_mtx)
distances, indices = nbrs.kneighbors(feature_mtx)
indices = indices[:, 1:]
distances = distances[:, 1:]

cos_sim_mtx = calculate_edges(indices, feature_mtx, distances)

# Create and initialise graph with node info from VD
G = nx.Graph(directed=True)
G.add_nodes_from(range(ns))
d = extract_neighbours("CVDneighbours.txt")
for key, nparr in d.items():
    for value in nparr:
        G.add_edge(key, value, weight=1)
        G.add_edge(value, key, weight=1)
        
# Add in node value (virtual?) edges from knn results
for u in range(ns):
    for v_idx in range(knn_neighbours):
        v = indices[u, v_idx]
        if not G.has_edge(u, v):
            G.add_edge(u, v, weight=cos_sim_mtx[u, v_idx])
    
print(G.edges)
A = nx.adjacency_matrix(G)
A_dense = A.todense()

S = signal_similarity_mtx(A, 3)
    
    