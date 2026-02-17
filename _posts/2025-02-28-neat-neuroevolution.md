---
layout: post
title: Evolving neural networks with NEAT
date: 2025-02-28
description: An implementation of the NEAT algorithm — Neuroevolution of Augmenting Topologies — and how it solves control tasks without gradient-based training.
---

Most neural network training relies on backpropagation through a fixed architecture. NEAT (Neuroevolution of Augmenting Topologies) takes a different route: it evolves both the weights and the structure of the network using a genetic algorithm, starting from minimal topologies and adding complexity only when it improves fitness.

## Key ideas

**Structural mutations** add new nodes (by splitting an existing connection) or new connections between existing nodes. This means the network can grow more expressive over time rather than being stuck with a fixed architecture chosen before training.

**Historical markings** solve the competing conventions problem — when two networks with different structures produce offspring, it's unclear which genes correspond to which. NEAT assigns a global innovation number to each new connection, making alignment between genomes unambiguous during crossover.

**Speciation** protects new structural innovations. A newly added node or connection initially hurts fitness because the surrounding weights haven't adapted yet. By grouping genomes into species based on structural similarity and competing only within species, NEAT gives each innovation time to be optimized before it competes globally.

## Experiments

On classic control tasks (CartPole, single-pole balancing) NEAT finds solutions within a few hundred generations using very small networks — often just 2–4 hidden nodes. The evolved topologies are interpretable: you can trace which inputs drive which outputs.

On harder tasks the algorithm is slower than modern policy gradient methods, but it has an appealing property: it makes no assumptions about differentiability and can optimize any black-box fitness function, including ones with sparse or binary rewards.

## Implementation notes

The most fiddly parts to get right are:

- **Distance metric for speciation** — the balance between the coefficients for excess genes, disjoint genes, and weight differences significantly affects how many species form.
- **Fitness sharing** — dividing each genome's fitness by its species size prevents large species from dominating.
- **Stale species removal** — species that don't improve for a set number of generations are culled to keep diversity from collapsing.

The code is on GitHub with configurations for several OpenAI Gym environments.
