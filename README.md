# Monocyte-Phagocytosis-Assay
Protocol and user interface for the analysis of in vitro phagocytosis data collected via confocal microscopy.

[A Rigorous Quantitative Approach to Analyzing Phagocytosis Assays](https://bio-protocol.org/UserHome.aspx?id=1238168)<br/> 
Caponegro et. al. BioProtoc. 2021.

[Online analysis tool for users]( https://mcap91.shinyapps.io/Monocyte-Phagocytosis-Assay/)

How to measure and compare in vitro phagocytosis data? 

**A:** Macrophage cells (Iba1+, green) are co-incubated with fluorescent latex beads (red) which they naturally engulf. Upon stimulation with conditioned media from glioma cancer cells (GCM), the number of macrophages engulfing beads increases as well as the number of beads engulfed per macrophage.<br/> 
**B:** Capturing the total fluorescent signal of the latex beads is correlated with manually counting each bead at the single-cell level.<br/>
**C:** simulated data demonstrates that parametric and non-parametric t tests are inadequate to  compare bimodal distributions. Here we propose using Kolmogorov–Smirnov test.<br/>
**D:** By treating the data from **A** as a binomial distribution we can capture the increase in phagocytosis that occurs upon stimulation measured by a right shift in fluorescent signal, indicating increased engulfment of beads in those cells.

![Figure 1](https://user-images.githubusercontent.com/36866996/124327769-4316fc80-db3d-11eb-8ae6-0b648955cb4e.png)



