---
layout: post
title: Training an LSTM to generate handwriting
date: 2025-08-03
description: How I trained a recurrent model to synthesize realistic pen stroke sequences, and the tricks that made training stable.
---

Handwriting synthesis is a sequence generation problem where the model must predict a continuous stream of pen coordinates — rather than discrete tokens — making it a useful testbed for recurrent architectures.

## The data format

The IAM On-Line Handwriting Database provides handwriting as sequences of `(x, y, pen_up)` triples: the pen's position at each timestep and whether the pen is lifted. The challenge is that raw coordinates have large variance and strong temporal correlation, so the model has to learn both local stroke dynamics and longer-range character structure.

## Model architecture

The model is a mixture density network (MDN) on top of a stacked LSTM. At each step the LSTM outputs parameters for a mixture of bivariate Gaussians over the next `(Δx, Δy)` offset plus a Bernoulli for `pen_up`. Sampling from this distribution during inference produces a stroke sequence.

A soft attention mechanism over the input character sequence lets the model condition generation on text, allowing it to synthesize specific words rather than free-form scribbles.

## Training stability

A few things made a noticeable difference:

- **Gradient clipping** — MDN loss can spike when a sample falls far into the tail of every mixture component. Clipping at a moderate threshold kept these spikes from corrupting weights.
- **Teacher forcing schedule** — starting with full teacher forcing and gradually increasing the proportion of model-generated steps prevented the exposure bias that hurt quality at inference time.
- **Mixture count** — too few components produced blurry, averaged strokes; too many made the loss surface noisy. Twenty components worked well for this dataset.

## Samples

Generated strokes are smooth and legible for common words. Less frequent letter combinations sometimes produce artifacts, likely because the attention mechanism struggles to align correctly when it has seen little training signal for that context.

The full training code and sample outputs are on GitHub.
