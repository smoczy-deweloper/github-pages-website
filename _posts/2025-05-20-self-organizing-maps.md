---
layout: post
title: Visualizing high-dimensional data with Self-Organizing Maps
date: 2025-05-20
description: A look at how SOMs learn a topology-preserving projection of high-dimensional input onto a 2D grid, with experiments on color and MNIST data.
---

A Self-Organizing Map (SOM) is an unsupervised neural network that projects high-dimensional data onto a low-dimensional (usually 2D) grid while preserving the topological relationships in the input space. Nearby grid nodes end up representing similar inputs, making SOMs useful for visualization and clustering.

## The algorithm

Each node in the grid holds a weight vector of the same dimension as the input. Training proceeds online:

1. Present a random input sample.
2. Find the **Best Matching Unit (BMU)** — the node whose weights are closest to the input.
3. Update the BMU and its neighbors to move their weights toward the input. Nodes further from the BMU receive a smaller update, controlled by a neighborhood function (typically a Gaussian).
4. Decay both the learning rate and the neighborhood radius over time.

After training the grid organizes itself so that nearby nodes respond to similar inputs.

## Color quantization experiment

A simple way to visualize SOM behavior is to train it on RGB color values. With a 20×20 grid and 50k training steps the map converges to a smooth color gradient where hues transition continuously across the grid. Starting from random weights, distinct color regions form within a few thousand steps.

## MNIST digits

Applying a SOM to 784-dimensional MNIST vectors and coloring each node by the digit class of its BMU produces a clean class map: nodes for the same digit cluster together, and visually similar digits (e.g., 3 and 8, or 4 and 9) tend to neighbor each other on the grid. This emerges purely from pixel similarity with no label information used during training.

## Limitations

SOMs scale poorly with input dimension and grid size — the neighborhood search is O(grid size) per step, and convergence slows as the grid grows. They also require careful tuning of the learning rate and neighborhood decay schedules. For very high-dimensional data, reducing dimensionality with PCA before SOM training often helps.
