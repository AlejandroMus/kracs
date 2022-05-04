FROM alejandromus/kracs:stable_software_latest
#FROM localhost:5000/kracs:stable_software_latest



MAINTAINER Alejandro Mus="Alejandro Mus Mejias <alejandro.mus@uv.es/alex.mus.mejias@gmail.com>"

# extra metadata
LABEL version="1.0"
LABEL description="Docker image with CASA, AIPS, DIFMAP, EHTIM, SMILI and DMC versions used for the M87 VII paper"

ARG NAME=eht

USER root

ARG CASAVER=casa-release-5.7.0-134.el7

COPY ./LICENSE /home/$NAME/


# CASA tasks
# Download
#Polsolve
RUN cd /home/$NAME/SOFTWARES/CASA/$CASAVER \
  && apt update \
  && apt install -y bzr \
  && bzr branch lp:casa-poltools; exit 0 
  
  
# Install
# Polsolve
RUN cd /home/$NAME/SOFTWARES/CASA/$CASAVER/casa-pol* \
  && ../bin/python setup.py build_ext --inplace \
  && ../bin/buildmytasks


  
# Install ehtplot
RUN cd /home/$NAME/SOFTWARES/EHTPLOT \
  && git clone https://github.com/liamedeiros/ehtplot.git \
  && python3 ./ehtplot/setup.py install
 


# Install DMC
RUN cd /home/$NAME/SOFTWARES/DMC \
  && git clone https://github.com/dpesce/eht-dmc.git \
  && cd ./eht-dmc; git checkout ehtvii; cd .. \
  && mv ./eht-dmc/* .; rm -r ./eht-dmc \
  && python3 setup.py build \
  && /home/$NAME/SOFTWARES/ANACONDA/envs/ehtim/bin/pip install arviz==0.10 # To be improved...
  
  
  

ENV SMILI_HOME /home/$NAME/SOFTWARES/SMILI

RUN mkdir -p $SMILI_HOME/local/{lib,bin}


# create a path to $SMILI_HOME/local
ENV LD_LIBRARY_PATH $SMILI_HOME/local/lib:$LD_LIBRARY_PATH
ENV PKG_CONFIG_PATH $SMILI_HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH
ENV PATH $SMILI_HOME/local/bin:$PATH
RUN echo 'export PATH=$SMILI_HOME/local/bin:$PATH' >> ~/.bashrc  && \
    echo 'export LD_LIBRARY_PATH=$SMILI_HOME/local/lib:$LD_LIBRARY_PATH' >> ~/.bashrc  && \
    echo 'export PKG_CONFIG_PATH=$HOME/local/lib/pkgconfig:$PKG_CONFIG_PATH' >> ~/.bashrc



# OpenBLAS
RUN cd $SMILI_HOME/local && \
    git clone https://github.com/xianyi/OpenBLAS && \
    cd OpenBLAS && \
    make USE_OPENMP=1 CC=gcc FC=gfortran && \
    make PREFIX=$SMILI_HOME/local install

# FFTW3
RUN cd $SMILI_HOME/local && \
    wget http://www.fftw.org/fftw-3.3.9.tar.gz && \
    tar xzvf fftw-3.3.9.tar.gz && \
    cd fftw-3.3.9 && \
    ./configure --prefix=$SMILI_HOME/local --enable-openmp --enable-threads --enable-shared --enable-float --enable-type-prefix && \
    make && \
    make install && \
    make clean && \
    ./configure --prefix=$SMILI_HOME/local --enable-openmp --enable-threads --enable-shared --enable-type-prefix && \
    make && \
    make install

# FINUFFT
RUN cd $SMILI_HOME/local && \
    git clone https://github.com/flatironinstitute/finufft && \
    cd finufft && \
    echo 'CXX = g++'                             >> make.inc && \
    echo 'CC = gcc'                              >> make.inc && \
    echo 'FC = gfortran'                         >> make.inc && \
    echo 'CFLAGS += -I$(SMILI_HOME)/local/include'     >> make.inc && \
    echo 'LIBS += -L$(SMILI_HOME)/local/lib'           >> make.inc && \
    echo 'FLAGS = $(CFLAGS)'                     >> make.inc && \
    echo 'CXXFLAGS = $(CFLAGS) -DNEED_EXTERN_C'  >> make.inc && \
    echo 'OMPFLAGS = -fopenmp'                   >> make.inc && \
    echo 'OMPLIBS = -lgomp'                      >> make.inc && \
    make lib && \
    echo 'finufftdir=$(SMILI_HOME)/local/finufft'                                            >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'libdir=${finufftdir}/lib-static'                                             >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'includedir=${finufftdir}/src'                                                >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo ''                                                                            >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'Name: FINUFFT'                                                               >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'Description: Flatiron Institute Nonuniform Fast Fourier Transform libraries' >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'Version: github'                                                             >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'Libs: -L${libdir} -lfinufft'                                                 >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc && \
    echo 'Cflags: -I${includedir}'                                                     >> $SMILI_HOME/local/lib/pkgconfig/finufft.pc

# python packages
RUN conda install ipython jupyter numpy scipy matplotlib pandas astropy seaborn h5py xarray # basic scientific python
RUN conda install ephem scikit-image scikit-learn # extras utils
RUN conda install tqdm # extras utils


# smili
RUN cd $SMILI_HOME/local && \
    git clone https://github.com/astrosmili/smili && \
    cd smili && \
    ./configure && \
    make install

RUN apt install -y libgsl-dev fftw3 fftw3-dev
# UVMULTIFIT
RUN cd /home/$NAME/SOFTWARES/CASA/$CASAVER \
  && wget https://launchpad.net/uvmultifit/trunk/3.0/+download/uvmultifit_v3.0-p5.tar.gz \
  #bzr branch lp:uvmultifit; exit 0 ----> DEV one
  && tar -zxvf uvmultifit_v3.0-p5.tar.gz \
  && mv uvmultifit_3.0-p5 uvmultifit \
  && cd uvmultifit; ../bin/python setup.py build_ext --inplace
  



USER $NAME
WORKDIR /home/$NAME




##### PATHS FOR KRACS!!!!!
# Set global variables
RUN echo "alias casa="/home/$NAME/SOFTWARES/CASA/$CASAVER/bin/casa"" >> /home/$NAME/.bashrc
RUN echo "alias casa6="/home/$NAME/SOFTWARES/CASA/CASA_PICARD/bin/casa"" >> /home/$NAME/.bashrc
RUN echo "PATH=$PATH:/home/$NAME/SOFTWARES/DIFMAP/uvf_difmap:/home/$NAME/SOFTWARES/CASA/picard/picard:/usr/local/src/jiveplot:$PATH" >> /home/$NAME/.bashrc
RUN echo "export PATH" >> /home/$NAME/.bashrc
RUN echo "import sys; sys.path.append('/home/$NAME/SOFTWARES/CASA/$CASAVER/casa-poltools'); execfile('/home/$NAME/SOFTWARES/CASA/$CASAVER/casa-poltools/mytasks.py'); sys.path.append('/home/$NAME/SOFTWARES/CASA/$CASAVER/uvmultifit'); import imp; uvm = imp.load_source('uvmultifit', '/home/$NAME/SOFTWARES/CASA/$CASAVER/uvmultifit/uvmultifit.py')" >> /home/$NAME/.casa/init.py
RUN echo "export PYCAPATH=/home/$NAME/SOFTWARES/CASA/$CASAVER/VLBI_REDUCTION" >> /home/$NAME/.bashrc
RUN echo "export PYTHONPATH=/home/$NAME/SOFTWARES/SMILI/smili:/home/$NAME/SOFTWARES/DMC:/home/$NAME/SOFTWARES/EHTPLOT/ehtplot:/home/$NAME/SOFTWARES/CASA/picard/picard:$PYTHONPATH" >> /home/$NAME/.bashrc
RUN echo "export MEQS_DIR=/home/$NAME/SOFTWARES/CASA/MeqSilhouette" >> /home/$NAME/.bashrc
RUN echo "export MEQTREES_CATTERY_PATH=/home/$NAME/SOFTWARES/CASA/meqtrees-cattery/Cattery" >> /home/$NAME/.bashrc


