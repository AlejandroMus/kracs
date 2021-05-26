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

  
# OpenBLAS
RUN cd /home/$NAME/SOFTWARES/SMILI \
    && git clone https://github.com/xianyi/OpenBLAS \
    && cd OpenBLAS \
    && make USE_OPENMP=1 CC=gcc FC=gfortran \
    && make PREFIX=/home/$NAME/SOFTWARES/SMILI/ install 


  
# FFTW3
RUN cd /home/$NAME/SOFTWARES/SMILI \
    && wget http://www.fftw.org/fftw-3.3.9.tar.gz \
    && tar xzvf fftw-3.3.9.tar.gz \
    && cd fftw-3.3.9 \
    && ./configure --prefix=/home/$NAME/SOFTWARES/SMILI/ --enable-openmp --enable-threads --enable-shared \
    && make \
    && make install

# FINUFFT
RUN cd /home/$NAME/SOFTWARES/SMILI && \
    git clone https://github.com/flatironinstitute/finufft && \
    cd finufft && \
    #cp make.inc.powerpc make.inc && \
    
    apt-get install -y libfftw3-dev && \
    echo 'CXX = g++'                             >> make.inc && \
    echo 'CC = gcc'                              >> make.inc && \
    echo 'FC = gfortran'                         >> make.inc && \
    echo "CFLAGS += -I/home/$NAME/SOFTWARES/SMILI/include"     >> make.inc && \
    echo "LIBS += -L/home/$NAME/SOFTWARES/SMILI/lib"           >> make.inc && \
    echo 'FLAGS = $(CFLAGS)'                     >> make.inc && \
    echo 'CXXFLAGS = $(CFLAGS) -DNEED_EXTERN_C'  >> make.inc && \
    echo 'OMPFLAGS = -fopenmp'                   >> make.inc && \
    echo 'OMPLIBS = -lgomp'                      >> make.inc && \
    make lib && \
    echo "finufftdir=/home/$NAME/SOFTWARES/SMILI/finufft"                               >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'libdir=${finufftdir}/lib-static'                                             >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'includedir=${finufftdir}/src'                                                >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo ''                                                                            >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'Name: FINUFFT'                                                               >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'Description: Flatiron Institute Nonuniform Fast Fourier Transform libraries' >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'Version: github'                                                             >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'Libs: -L${libdir} -lfinufft'                                                 >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc && \
    echo 'Cflags: -I${includedir}'                                                     >> /home/$NAME/SOFTWARES/SMILI/lib/pkgconfig/finufft.pc



#smili
#RUN cd /home/$NAME/SOFTWARES/SMILI \
#   && git clone https://github.com/astrosmili/smili \
#   && cd smili
#   && ./configure \
#   && make install
  
  
# WARNING not proved yet
# 
# RUN cd /home/$NAME/SOFTWARES/SMILI \
#   && git clone https://github.com/flatironinstitute/finufft.git \
#   && cd finufft \
#   && cp make.inc.powerpc make.inc \
#   && cd ..\
#   && wget http://www.fftw.org/fftw-3.3.9.tar.gz \
#   && tar xzvf fftw-3.3.9.tar.gz \
#   && cd fftw-3.3.9 \
#   && ./configure --prefix="/home/$NAME/SOFTWARES/ANACONDA/" --enable-openmp --enable-threads --enable-shared \
#   && make \
#   && make install \
   #&& export FFTW3_LIBS="-/home/$NAME/SOFTWARES/ANACONDA/lib -lfftw3 -fopenmp" \
   #&& export FFTW3_CFLAGS="-/home/$NAME/SOFTWARES/ANACONDA/include" \
   
 RUN cd /home/$NAME/SOFTWARES/SMILI \
   && git clone https://github.com/astrosmili/smili \
   && cd smili \
   && export OPENBLAS_LIBS="-/home/$NAME/SOFTWARES/ANACONDA/lib -lopenblas" \
   && export OPENBLAS_CFLAGS="-/home/$NAME/SOFTWARES/ANACONDA/include" \
   && export FINUFFT_LIBS="-/home/$NAME/SOFTWARES/SMILI/lib -finufft" \
   && export FINUFFT_CFLAGS="-/home/$NAME/SOFTWARES/SMILI/include" 
#   && ./configure \
#   && conda activate base \
#   && ./configure
#   && make install


USER $NAME
WORKDIR /home/$NAME




##### PATHS FOR KRACS!!!!!
# Set global variables
RUN echo "alias casa="/home/$NAME/SOFTWARES/CASA/$CASAVER/bin/casa"" >> /home/$NAME/.bashrc
RUN echo "alias casa6="/home/$NAME/SOFTWARES/CASA/CASA_PICARD/bin/casa"" >> /home/$NAME/.bashrc
RUN echo "PATH=$PATH:/home/$NAME/SOFTWARES/DIFMAP/uvf_difmap:/home/$NAME/SOFTWARES/CASA/picard/picard:/usr/local/src/jiveplot:$PATH" >> /home/$NAME/.bashrc
RUN echo "export PATH" >> /home/$NAME/.bashrc
RUN echo "import sys; sys.path.append('/home/$NAME/SOFTWARES/CASA/$CASAVER/casa-poltools'); execfile('/home/$NAME/SOFTWARES/CASA/$CASAVER/casa-poltools/mytasks.py')" >> /home/$NAME/.casa/init.py
RUN echo "export PYCAPATH=/home/$NAME/SOFTWARES/CASA/$CASAVER/VLBI_REDUCTION" >> /home/$NAME/.bashrc
RUN echo "export PYTHONPATH=/home/$NAME/SOFTWARES/SMILI/smili:/home/$NAME/SOFTWARES/DMC:/home/$NAME/SOFTWARES/EHTPLOT/ehtplot:/home/$NAME/SOFTWARES/CASA/picard/picard:$PYTHONPATH" >> /home/$NAME/.bashrc
RUN echo "export MEQS_DIR=/home/$NAME/SOFTWARES/CASA/MeqSilhouette" >> /home/$NAME/.bashrc
RUN echo "export MEQTREES_CATTERY_PATH=/home/$NAME/SOFTWARES/CASA/meqtrees-cattery/Cattery" >> /home/$NAME/.bashrc


