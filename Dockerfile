FROM debian:stretch-slim

COPY neurodebian.gpg /root/.neurodebian.gpg

ARG DEBIAN_FRONTEND="noninteractive"

ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8"

RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        software-properties-common \
        git \
        jq \
        graphviz \
        build-essential \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        libnss3-dev \
        libssl-dev \
        libsqlite3-dev \
        libreadline-dev \
        libffi-dev \
        curl \
        libbz2-dev \
        cmake \
        wget \
        vim \
        bzip2 \
        ca-certificates \
        libxtst6 \
        libgtk2.0-bin \
        libxft2 \
        libxmu-dev \
        libgl1-mesa-glx \
        libpng-dev \
        libffi-dev \
        libxml2-dev \
        libxslt1-dev \
        gnupg \
        libgomp1 \
        libmpich-dev \
        mpich \
        g++ \
        zip \
        unzip \
        libglu1 \
        libfreetype6-dev \
        pkg-config \
        libgsl0-dev \
        openssl \
        gsl-bin \
        libglu1-mesa-dev \
        libglib2.0-0 \
        libglw1-mesa \
        libxkbcommon-x11-0 \
        libquadmath0 \
        gcc-multilib \
        apt-transport-https \
        debian-archive-keyring \
        dirmngr \
    && apt-get clean \
    && cd /tmp \
    && curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz \
    && tar -xf Python-3.8.2.tar.xz \
    && cd Python-3.8.2 \
    && ./configure --enable-optimizations --enable-shared --with-ensurepip=install --enable-loadable-sqlite-extensions \
    && make -j 4 \
    && make altinstall \
    && python3.8 -m pip install --upgrade pip \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && groupadd -r neuro && useradd --no-log-init --create-home --shell /bin/bash -r -g neuro neuro \
    && apt-get clean -y && apt-get autoclean -y && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && curl -sSL http://neuro.debian.net/lists/stretch.us-tn.full >> /etc/apt/sources.list.d/neurodebian.sources.list && \
    apt-key add /root/.neurodebian.gpg && \
    (apt-key adv --refresh-keys --keyserver hkp://ha.pool.sks-keyservers.net 0xA5D32F012649A5A9 || true) && \
    apt-get update -qq && apt-get install --no-install-recommends -y fsl-5.0-core && \
    apt-get clean && cd /tmp \
    && wget https://fsl.fmrib.ox.ac.uk/fsldownloads/patches/fsl-5.0.10-python3.tar.gz \
    && tar -zxvf fsl-5.0.10-python3.tar.gz \
    && cp fsl/bin/* $FSLDIR/bin/ \
    && rm -r fsl* \
    && chmod 777 -R $FSLDIR/bin \
    && chmod 777 -R /usr/lib/fsl/5.0

ENV FSLDIR=/usr/share/fsl/5.0 \
    FSLOUTPUTTYPE=NIFTI_GZ \
    FSLMULTIFILEQUIT=TRUE \
    POSSUMDIR=/usr/share/fsl/5.0 \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/fsl/5.0 \
    FSLTCLSH=/usr/bin/tclsh \
    FSLWISH=/usr/bin/wish \
    PATH=$FSLDIR/bin:$PATH

WORKDIR /home/neuro

RUN echo "FSLDIR=/usr/share/fsl/5.0" >> /home/neuro/.bashrc && \
    echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/fsl/5.0" >> /home/neuro/.bashrc && \
    echo ". $FSLDIR/etc/fslconf/fsl.sh" >> /home/neuro/.bashrc && \
    echo "export FSLDIR PATH" >> /home/neuro/.bashrc \
    && pip3 install cython matplotlib h5py hdf5storage nibabel nipype scikit-learn pandas seaborn joblib \
    && mkdir -p ~/.nipype \
    && echo "[monitoring]" > ~/.nipype/nipype.cfg \
    && echo "enabled = true" >> ~/.nipype/nipype.cfg \
    && pip3 install dipy \
    && cd / \
    && rm -rf /home/neuro/.cache \
    && apt-get clean autoclean \
    && apt-get purge -y --auto-remove \
      git \
      jq \
      wget \
      cmake \
      vim \
      gcc \
      curl \
      openssl \
      build-essential \
      ca-certificates \
      libc6-dev \
      gnupg \
      g++ \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 22

ENV FSLDIR=/usr/share/fsl/5.0 \
    FSLOUTPUTTYPE=NIFTI_GZ \
    FSLMULTIFILEQUIT=TRUE \
    POSSUMDIR=/usr/share/fsl/5.0 \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/fsl/5.0 \
    FSLTCLSH=/usr/bin/tclsh \
    FSLWISH=/usr/bin/wish \
    PATH=$FSLDIR/bin:$PATH
ENV GOTO_NUM_THREADS=4 \
    OMP_NUM_THREADS=4
ENV QT_QPA_PLATFORM=offscreen

RUN . /home/neuro/.bashrc
