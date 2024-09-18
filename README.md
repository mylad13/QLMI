# QLMI
Matlab Implementation of the paper "Model-Free LQR Design by Q-function Learning."

## Table of Contents
- [Overview](#overview)
- [Paper and Citation](#paper-and-citation)
- [License](#license)

## Overview
This repository provides a Matlab implementation of model-free Linear Quadratic Regulator (LQR) controllers. It covers approaches such as:
- **Policy Iteration**
- **Value Iteration**
- **SDP-Based Convex Optimization** (introduced in the paper)

Different formulations of the SDP-based method are provided to design centralized and distributed controllers.


## Paper and Citation
If you use this code in your research, please cite the following paper:

**"Model-Free LQR Design by Q-function Learning"**

- Authors: Milad Farjadnasab, Maryam Babazadeh
- Journal: Automatica
- DOI: [(https://doi.org/10.1016/j.automatica.2021.110060)]

### Citation in BibTeX format:
```bibtex
@article{farjadnasab2022model,
  title={Model-free LQR design by Q-function learning},
  author={Farjadnasab, Milad and Babazadeh, Maryam},
  journal={Automatica},
  volume={137},
  pages={110060},
  year={2022},
  publisher={Elsevier}
}