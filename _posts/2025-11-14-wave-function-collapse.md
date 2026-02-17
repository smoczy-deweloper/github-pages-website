---
layout: post
title: Procedural generation with Wave Function Collapse
date: 2025-11-14
description: An overview of the Wave Function Collapse algorithm and how I used it to generate tile-based maps with local similarity constraints.
---

Wave Function Collapse (WFC) is a constraint-based procedural generation algorithm originally introduced for generating images that locally resemble a sample input. The core idea is surprisingly simple: treat the output grid as a superposition of all possible tile states and repeatedly collapse cells to a single state, propagating constraints to neighbors after each collapse.

## How it works

Each cell in the output grid starts as a superposition of every allowed tile. At each step:

1. **Observe** — pick the cell with the lowest entropy (fewest remaining possibilities) and collapse it to one tile, chosen at random weighted by frequency.
2. **Propagate** — remove from neighboring cells any tiles that are no longer compatible with the newly collapsed cell.
3. **Repeat** until all cells are collapsed, or a contradiction is reached.

If a contradiction occurs (a cell has zero remaining options), the algorithm backtracks or restarts.

## Extracting constraints from a sample

Rather than hand-specifying which tiles can be adjacent, the constraints are learned directly from an example image. For every tile in the sample, the algorithm records which tiles appear to its left, right, above, and below. These adjacency rules drive propagation.

## Results

The generated maps preserve local texture and structure from the sample surprisingly well. Thin-walled rooms, corridors, and open areas all emerge naturally from a small hand-drawn example without any explicit room-placement logic.

The main limitation is that global structure is hard to control — you get local coherence but no guarantee of, say, a connected level. Combining WFC with a higher-level layout pass (e.g., ensuring connectivity via flood fill and adding corridors where needed) addresses this.

## Code

The implementation is available on [GitHub](https://github.com/gekas145). It supports both overlapping and tile-based modes, configurable output size, and optional backtracking on contradiction.
