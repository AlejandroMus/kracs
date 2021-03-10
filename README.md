# Dockerfile

# kracs: Kit of Radio Astronomy Calibration Softwares

# Alejandro Mus, Universitat de Valencia, 2020. License with the project


This docker image contains the most used calibration and imaging softwares in radio astronomy. It is free to use. Comments, please contact me via alejandro.mus@uv.es

Requirements:
- docker(v19.03.8)
- 17 GB of free size

It is linked to https://hub.docker.com/repository/docker/alejandromus/kracs


Special greetings to Chi-kwan Chan; Marti-Vidal, Ivan; Janssen, Michael et al., Chael, Andrew et al., Madeiros, Lia et al.; Pesce, Dom et al.; and CASA & AIPS & DIFMAP developpers.


Dockerfile for generating image of softwares: 
-  CASA (v5.7 and v6 but can be easily updated changing the dockerfile) with casa-pooltols (Marti-Vidal, I.; see bzr branch lp:casa-poltools), Symba, MeqShiloutte, MeqTree and Picard (Janssen, M. et al.; see https://arxiv.org/abs/1902.01749 and https://www.aanda.org/articles/aa/pdf/2020/04/aa36622-19.pdf, https://www.researchgate.net/publication/306226828_MeqSilhouette_A_mm-VLBI_observation_and_signal_corruption_simulator)
- difamp
- AIPS (Dockerized by Chi-kwan Chan); see https://github.com/eventhorizontelescope/docker-recipes/tree/master/aips-stack)
- ehtim (Chael, A.); see https://achael.github.io/eht-imaging/.
- ehtplot; see https://github.com/liamedeiros/ehtplot
- DMC; see https://github.com/dpesce/eht-dmc
- SMILI; see https://smili.readthedocs.io/en/latest/index.html



To generate the container and the image, just run the script "run.sh".
This script is very simple to use (run it without any argument to see the "how-to-use" help").
Inputs needed: 
1) -v (or --volume) any name that the user wants to give to the volume. Observe that it can be any name! but always in small letters and using _ for separating words
2) -lf (or --localFolder) to choose the local folder on yur cumputer that will be shared with the Docker container. Recomended: A git folder. Observe that this folder will be inside the /host/ directory in the docker container!!!!
3) -p (or --port) for specifying a por (used for jupyter). Default 8888:8888
4) -ver (or --verbose) for a verbose log run.


The script will directly run and attach the docker image and volume created!

**WARNING:** internet needed because is pulling from my dockerhub (https://hub.docker.com/repository/docker/alejandromus/kracs)


If you want to re-run it, just do 
**docker start name_of_your_volume**
**docker attach name_of_your_volume**



For running jupyter:

jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --allow-root

more general:
jupyter notebook --port=<port choosed with run.sh> --no-browser --ip=0.0.0.0 --allow-root


# NOTES. IMPORTANT, PLEASE READ BEFORE RUNNING!!
- The working directory of the image contains the SOFTWARES' folder, where the main softwares can be found. Moreover, the .casa folder is also in the $HOME.
- T¡For using AIPS, change to aips group (su aips, pswd: aips).
- The alias _casa_ is for CASA5.7. On the other hand, _casa6_ will invoke CASAv6 (needed for SYMBA but not working poltools wih Python3). For DIFMAP is difmap
- The file "requirements.txt" is used for installing necessay packages for Python2.7 (e.g., numpy, scipy...).
- *One needs to do _conda activate ehtim_ for having the conda env. with ehtim, ehtplot and DMC.*
- run.sh needs x11-flag (thank to Chi-kwan Chan) to get the display env.


# TODO 
- End SMILI installation

