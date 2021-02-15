FROM ubuntu:16.04

 # author
MAINTAINER Alejandro Mus="Alejandro Mus Mejias <alejandro.mus@uv.es/alex.mus.mejias@gmail.com>"

# extra metadata
LABEL version="1.0"
LABEL description="Docker image with CASA, AIPS, DIFMAP and EHTIM"

ARG NAME=alejandro


RUN useradd -ms /bin/bash alejandro \
  && apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates \
     software-properties-common apt-utils \
  && apt install -y tmux \
  && apt install -y tree \
  && apt install -y git \
  && apt install -y gfortran \
  && apt install -y lib32ncurses5-dev \  
  && apt install -y software-properties-common \
  && add-apt-repository -y ppa:deadsnakes/ppa \
  && apt update \
  && apt install -y python3.6 \
  && apt install -y python3.6-tk



# add credentials on build
RUN mkdir /root/.ssh/
RUN chmod 777 /root
RUN chmod 777 /root/.ssh/
RUN chmod 755 /root


# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts



COPY ./requirements.txt /usr/local/src
RUN add-apt-repository -s ppa:kernsuite/kern-3 \
  && apt-get -qq update \
  && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y ca-certificates \
     vim git curl wget less locales build-essential time pgplot5 pyxis wsclean meqtrees \
     libfreetype6 libsm6 libxi6 libxrender1 libxrandr2 libxfixes3 \
     libxcursor1 libxinerama1 libfontconfig1 libxslt1.1 xauth xvfb dbus-x11 \
     libfontconfig-dev libboost-all-dev libbz2-dev \
     python python-matplotlib python-tk python-casacore python-future python-setuptools \
     python-pyxis python python-termcolor python-pynfft python-ephem python-dev \
     python-tigger ipython python-pip \
  && pip install --upgrade pip==9.0.1 \
  && pip install -r /usr/local/src/requirements.txt \
  && mkdir /root/.irods && \
    echo '\
{\
    "irods_host": "data.cyverse.org",\
    "irods_port": 1247,\
    "irods_user_name": "anonymous",\
    "irods_zone_name": "iplant"\
}' > /root/.irods/irods_environment.json \
  && curl -o irods-icommands-4.1.10-ubuntu14-x86_64.deb https://files.renci.org/pub/irods/releases/4.1.10/ubuntu14/irods-icommands-4.1.10-ubuntu14-x86_64.deb \
  && apt-get install --no-install-recommends -y ./irods-icommands-4.1.10-ubuntu14-x86_64.deb \
  && rm -f irods-icommands-4.1.10-ubuntu14-x86_64.deb \
  && apt-get remove -y ca-certificates && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
  
  
  
# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;
    
    

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME


ARG CASAVER=casa-release-5.7.0-134.el7
    
# put symba and dependencies in /usr/local/src,
# get rid of outdated casacore data,
# set locale for CASA perl,
# and create directory for Pegasus
# add AIPS and DIFMAP
RUN  cd /usr/local/src \
  && wget --no-check-certificate casa.nrao.edu/download/distro/casa/release/el7/$CASAVER.tar.gz \
  && tar xfz casa-* \
  && rm casa-*tar.gz \
  && CASAVER=$(echo casa-*) \
  && mkdir -p /home/$NAME/SOFTWARES/CASA \
  && mv /usr/local/src/casa-* /home/$NAME/SOFTWARES/CASA \
  && mv /usr/local/src/* /home/$NAME/SOFTWARES/CASA \
  && git clone --single-branch --depth 1 https://bitbucket.org/M_Janssen/symba \
  && curl -L https://ftp.science.ru.nl/astro/mjanssen/aatm-0.5.tar.gz -o aatm-0.5.tar.gz ; tar xfz aatm-0.5.tar.gz ; rm aatm-0.5.tar.gz \
  && cd aatm-0.5 ; ./configure ; make ; make install ; make clean ; cd .. \
  && curl -L https://ftp.science.ru.nl/astro/mjanssen/v0.9.7.tar.gz -o v0.9.7.tar.gz ; tar xfz v0.9.7.tar.gz ; rm v0.9.7.tar.gz \
  && cd simms-0.9.7 ; python setup.py install ; cd .. \
  && git clone --single-branch --depth 1 https://github.com/ska-sa/meqtrees-cattery \
  && cd meqtrees-cattery ; python setup.py install ; cd .. \
  && git clone --branch v2.3 --depth 1 https://github.com/rdeane/MeqSilhouette \
  && git clone --single-branch --depth 1 https://github.com/haavee/jiveplot \
  && chmod +x jiveplot/jplotter \
  && chown -R $USER /usr/local/src \
  && chmod 755 /usr/local/src \
  && mv /usr/local/MeqSilhouette /usr/local/meqtrees* /home/$NAME/SOFTWARES/CASA \
  && rm -fr /var/lib/casacore/data ; ln -s /usr/local/src/${CASAVER}/data /var/lib/casacore/data \
  && rm -fr /usr/share/casacore/data ; ln -s /usr/local/src/${CASAVER}/data /usr/share/casacore/data \
  && cp /usr/local/src/symba/emulate_observations/run_modelobs.sh /home/$NAME/ ; cd \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
  && mkdir -p /cvmfs \
  && cd /usr/local/src/ \
  && wget ftp://ftp.aoc.nrao.edu/pub/software/aips/31DEC20/install.pl \
  && mkdir -p /home/$NAME/SOFTWARES/AIPS/v31DEC20 \
  && mv install.pl /home/$NAME/SOFTWARES/AIPS/v31DEC20 \
  && mkdir -p /home/$NAME/SOFTWARES/DIFMAP \
  && curl -L ftp://ftp.astro.caltech.edu/pub/difmap/difmap2.5e.tar.gz -u anonymous:anonymous --output /home/$NAME/SOFTWARES/DIFMAP/difmap.tar.gz \
  && curl -L ftp://ftp.astro.caltech.edu/pub/pgplot/pgplot5.2.tar.gz -u anonymous:anonymous --output /usr/local/src/pgplot.tar.gz \
  && tar -zxvf /home/$NAME/SOFTWARES/DIFMAP/difmap.tar.gz -C /home/$NAME/SOFTWARES/DIFMAP \
  && tar -zxvf /usr/local/src/pgplot.tar.gz -C /usr/local/src \
  && rm /home/$NAME/SOFTWARES/DIFMAP/difmap.tar.gz \
  && rm /usr/local/src/pgplot.tar.gz \
  && mkdir -p /home/$NAME/SOFTWARES/EHTPLOT \
  && mkdir -p /home/$NAME/SOFTWARES/DMC \
  && mkdir -p /home/$NAME/SOFTWARES/SMILI 


  
# Installing DIFMAP
# Installing PGPLOT and libx11
RUN cd /usr/local/src \
  && apt update -y \
  && apt install -y libx11-dev pgplot5 
# Installing DIFMAP itself
RUN cd /home/$NAME/SOFTWARES/DIFMAP/uvf_difmap \
  && sed -i --expression 's@PGPLOT_LIB="-lpgplot -lX11"@PGPLOT_LIB="-L/usr/lib/x86_64-linux-gnu -Xlinker -R/usr/lib/x86_64-linux-gnu -lpgplot -lX11"@' configure \
  && ./configure linux-i486-gcc \
  && ./makeall
 
  

# Installing ehtim
# First, installing conda needed for pynfft
RUN cd /usr/local/src \
  && wget --no-check-certificate https://repo.anaconda.com/archive/Anaconda3-2020.07-Linux-x86_64.sh \
  && bash ./Anaconda3*sh -b -p /home/$NAME/SOFTWARES/ANACONDA


ENV PATH="/home/$NAME/SOFTWARES/ANACONDA/bin:${PATH}"
COPY conda_ehtim.yml /home/$NAME/SOFTWARES/ANACONDA
RUN conda env create -f /home/$NAME/SOFTWARES/ANACONDA/conda_ehtim.yml

  
  
# Installing rPicard
RUN cd /home/$NAME/SOFTWARES/CASA/ \
  && git clone --single-branch --depth 1 --branch v3.14.0 https://bitbucket.org/M_Janssen/picard \
  && curl -L "$(cat picard/README.md | grep wget | cut -d' ' -f3)" -o CASA.picard.tar.xz \
  && mkdir CASA_PICARD && tar xzvf CASA.picard.tar.xz -C CASA_PICARD --strip-components 1 \
  && rm -rf CASA.picard.tar.xz \
  && python picard/setup.py -a -p /home/$NAME/SOFTWARES/CASA/CASA_PICARD


  


# The AIPS image
# AIPS doesn't like running as root
#RUN groupadd AIPS_GROUP \
#  && useradd -G AIPS_GROUP aips
  
RUN	useradd -md /usr/local/aips -s /bin/bash aips &&\
	echo "aips:aips" | chpasswd &&\
	adduser aips sudo
	
WORKDIR /usr/local/aips
USER aips


# Install AIPS 31DEC20
ADD	31DEC20 .AIPSRC
RUN wget ftp://ftp.aoc.nrao.edu/pub/software/aips/31DEC20/install.pl \
  && chmod 755 install.pl \
  && rsync rsync://ftp.aoc.nrao.edu/ \
  && ./install.pl -n



# Setup AIPS
USER root
RUN	printf '\n\
sssin           5000/tcp        SSSIN      # AIPS TV server\n\
ssslock         5002/tcp        SSSLOCK    # AIPS TV Lock\n\
msgserv         5008/tcp        MSGSERV    # AIPS Message Server\n\
tekserv         5009/tcp        TEKSERV    # AIPS TekServer\n\
aipsmt0         5010/tcp        AIPSMT0    # AIPS remote FITS disk access\n\
aipsmt1         5011/tcp        AIPSMT1    # AIPS remote tape 1\n\
aipsmt2         5012/tcp        AIPSMT2    # AIPS remote tape 2\n\
' >> /root/services &&\
	printf '\n# all users should source AIPS\n\
if [ -f /usr/local/aips/LOGIN.SH ]; then\n\
  source /usr/local/aips/LOGIN.SH\n\
fi\n\
' >> /etc/bash.bashrc

# Install ParselTongue
RUN	apt-get -qq update &&\
	apt-get install --no-install-recommends -y software-properties-common &&\
	add-apt-repository ppa:kettenis-w/parseltongue &&\
	apt-get -qq update &&\
	apt-get install --no-install-recommends -y parseltongue &&\
	apt-get remove -y software-properties-common && apt-get autoremove -y &&\
	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*




 
USER $NAME
WORKDIR /home/$NAME




##### PATHS FOR KRACS!!!!!
# Set global variables
RUN cd /home/$NAME \
  && mkdir .casa \
  && chown $NAME .casa

RUN echo "alias casa="/home/$NAME/SOFTWARES/CASA/$CASAVER/bin/casa"" >> /home/$NAME/.bashrc
RUN echo "alias casa6="/home/$NAME/SOFTWARES/CASA/CASA_PICARD/bin/casa"" >> /home/$NAME/.bashrc
RUN echo "PATH=$PATH:/home/$NAME/SOFTWARES/DIFMAP/uvf_difmap:/home/$NAME/SOFTWARES/CASA/picard/picard:/usr/local/src/jiveplot:$PATH" >> /home/$NAME/.bashrc
RUN echo "export PATH" >> /home/$NAME/.bashrc
RUN echo "import sys; sys.path.append('/home/$NAME/SOFTWARES/CASA/$CASAVER/casa-poltools'); execfile('/home/$NAME/SOFTWARES/CASA/$CASAVER/casa-poltools/mytasks.py')" >> /home/$NAME/.casa/init.py
RUN echo "export PYCAPATH=/home/$NAME/SOFTWARES/CASA/$CASAVER/VLBI_REDUCTION" >> /home/$NAME/.bashrc
RUN echo "export PYTHONPATH=/home/$NAME/SOFTWARES/SMILI/smili:/home/$NAME/SOFTWARES/DMC:/home/$NAME/SOFTWARES/EHTPLOT:/home/$NAME/SOFTWARES/CASA/picard/picard:$PYTHONPATH" >> /home/$NAME/.bashrc
RUN echo "export MEQS_DIR=/home/$NAME/SOFTWARES/CASA/MeqSilhouette" >> /home/$NAME/.bashrc
RUN echo "export MEQTREES_CATTERY_PATH=/home/$NAME/SOFTWARES/CASA/meqtrees-cattery/Cattery" >> /home/$NAME/.bashrc




RUN ~/SOFTWARES/ANACONDA/envs/ehtim/bin/pip install ehtim
RUN conda init


# export  QT_QPA_PLATFORM=offscreen para QT. Ademas para modificar PATH, la idea es ENV PATH = PATH

