# Dockerfile

# kracs: Kit of Radio Astronomy Calibration Softwares

# Alejandro Mus, Universitat de Valencia, 2020. License with the project


This docker image contains the most used calibration and imaging softwares in radio astronomy. It is free to use. Comments, please contact me via alejandro.mus@uv.es

Requirements:
- docker(v19.03.8)
- 12 GB of free size


Special greetings to Marti-Vidal, Ivan; Janssen, Michael et al., Chael, Andrew et al., Madeiros, Lia et al.; Pesce, Dom et al.; and CASA & AIPS & DIFMAP developpers.


Dockerfile for generating image of softwares: 
-  CASA (v5.7 and v6 but can be easily updated changing the dockerfile) with casa-pooltols (Marti-Vidal, I.; see bzr branch lp:casa-poltools), Symba, MeqShiloutte, MeqTree and Picard (Janssen, M. et al.; see https://arxiv.org/abs/1902.01749 and https://www.aanda.org/articles/aa/pdf/2020/04/aa36622-19.pdf, https://www.researchgate.net/publication/306226828_MeqSilhouette_A_mm-VLBI_observation_and_signal_corruption_simulator)
- difamp
- AIPS (need to be install interactively)
- ehtim (Chael, A.); see https://achael.github.io/eht-imaging/.
- ehtplot; see https://github.com/liamedeiros/ehtplot
- DMC; see https://github.com/dpesce/eht-dmc
- SMILI; see https://smili.readthedocs.io/en/latest/index.html


To generate the container and the image, follow the instructions:

SSH_PRIVATE_KEY='cat $HOME/.ssh/id_ed25519'
docker build -t kracs . --build-arg SSH_PRIVATE_KEY="${SSH_PRIVATE_KEY}"

or more direct

**docker build -t kracs .**


**docker run -dit -P --name kracs_volume -p 8888:8888 --env="QT_X11_NO_MITSHM=1" -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix:rw -v ~/PhD/GIT:/host kracs**

docker ps -a

**docker attach kracs_volume**

Observe that in this case, the local folder ~/PhD/GIT will be in the /host folder of the image. That means, all documents in the folder GIT will be share between the local machine and the docker image. Just change ~/PhD/GIT for your local working directory

For changing the user name, change the variable NAME by the string you want

For running jupyter:

jupyter notebook --port=8888 --no-browser --ip=0.0.0.0 --allow-root


# NOTES
- The working directory of the image contains the SOFTWARES' folder, where the main softwares can be found. Moreover, the .casa folder is also in the $HOME, 
- Nowadays, the AIPS installation is not automatize. It can be done by hand just executing the install.pl file located on ~/SOFTWARES/AIPS/<version>.
- The alias _casa_ is for CASA5.7. On the other hand, _casa6_ will invoke CASAv6 (needed for SYMBA but not working poltools).
- The file "requirements.txt" is used for installing necessay packages for Python2.7 (e.g., numpy, scipy...).
- One needs to do _conda activate ehtim_ for having the conda env. with ehtim, ehtplot and DMC.
- To have operative ehtplot, please copy and paste this command _cp -r ehtplot /home/$NAME/.local/lib/python3.6/site-packages_


# TODO 
- [ ] To do a script for installing aips with all default values
- [ ] To automatize AIPS installation
- [ ] To automatize the ehtplot placement

