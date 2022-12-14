### Introduction

This repository serves as the gathering place for algorithms and new ideas in emerging theories
in robust control, reinforcement learning, and optimization.

Most of the code is written by [Lekan Molu](https://scriptedonachip.com/) in `python` and occasionally in `matlab`.

### Code Organization

All matlab files are in the folder `matlab` while `python` files are in the root folder.

+  The code in the folder `tac_code` contains the matlab code and figures used in the paper:

  -     `Mixed $H_2/H_\infty$ LQ Games for Robust Policy Optimization Under Unknown Dynamics.
        Transactions in Automatic Control (2022/2023) by Leilei Cui and Lekan Molu`.

+ All the codes in the root folder contain the routines and subroutines for the paper,  

    - `Mixed $\mathcal{H}_2/\mathcal{H}_\infty$-Policy Learning Synthesis.
      The International Federation of Automatic Control (IFAC) World Congress (2022/2023)
      by Lekan Molu and Hosein Hasanbeig.`

+ Folders structure
  - `dynsys`: This folder defines the classes for the dynamical systems we have considered so far.
  - `hinfinity`: Contains cool implementations of $H_\infty$ control algorithms.
  - `identify`: Contains codes for interpretable neural network policies and NARMAX
                models used in our identification experiments.
  - `notebooks`: Contains Jupyter notebooks used for testing and papers experimentation.
  - `linearsys`: Contains common linear system utility routines and sub-routines.
  - `utils`: Contains general purpose matlab-like functions for controllers and policy designs.

### Usage

+ To run experiments for the TAC paper, open this [notebook](notebooks/LeileiHinf.ipynb)

+ To run the experiments for the IFAC World Congress paper, open this [notebook](notebooks/narmax_ident.ipynb)


### TODOs

+ Integrate this with the Reachability codebase.
