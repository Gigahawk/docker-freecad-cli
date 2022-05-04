FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

ENV FREECAD_VERSION 0.19.4
ENV FREECAD_REPO https://github.com/FreeCAD/FreeCAD.git

# python3.8-distutils https://github.com/deadsnakes/issues/issues/82
RUN \
    pack_build="git \
                # Standard tools
                build-essential \
                cmake \
                # cmake-curses-gui \
                libtool \
                lsb-release \
                # Python
                python3 \
                swig \
                # Boost
                libboost-dev \
                libboost-date-time-dev \
                libboost-filesystem-dev \
                libboost-graph-dev \
                libboost-iostreams-dev \
                libboost-program-options-dev \
                libboost-python-dev \
                libboost-regex-dev \
                libboost-serialization-dev \
                libboost-thread-dev \
                # Coin
                libcoin-dev \
                # Math
                libeigen3-dev \
                libgts-bin \
                libgts-dev \
                libkdtree++-dev \
                libmedc-dev \
                libopencv-dev \
                libproj-dev \
                libvtk7-dev \
                libx11-dev \
                libxerces-c-dev \
                libzipios++-dev \
                netgen \
                netgen-headers \
                libmetis-dev \
                # Qt
                qtbase5-dev \
                qttools5-dev \
                # qt5-default \
                libqt5opengl5-dev \
                libqt5svg5-dev \
                qtwebengine5-dev \
                libqt5xmlpatterns5-dev \
                libqt5x11extras5-dev \
                libpyside2-dev \
                libshiboken2-dev \
                pyside2-tools \
                pyqt5-dev-tools \
                python3-dev \
                #python3-distutils \
                python3-matplotlib \
                python3-pivy \
                python3-ply \
                python3-pyside2.qtcore \
                python3-pyside2.qtgui \
                python3-pyside2.qtsvg \
                python3-pyside2.qtwidgets \
                python3-pyside2.qtnetwork \
                python3-pyside2.qtwebengine \
                python3-pyside2.qtwebenginecore \
                python3-pyside2.qtwebenginewidgets \
                python3-pyside2.qtwebchannel \
                #python3-pyside2uic \
                # OpenCascade kernel
                libocct*-dev \
                occt-draw \
                # Optional packages
                libsimage-dev \
                python3-markdown \
                python3-git \
                xvfb \
                wget \
                " \
    && apt update \
    && apt install -y --no-install-recommends software-properties-common \
    && add-apt-repository -y ppa:deadsnakes/ppa \
    && add-apt-repository -y ppa:freecad-maintainers/freecad-stable \
    && apt update \
    && apt install -y --no-install-recommends $pack_build


RUN \
  # get FreeCAD Git
    cd \
    && git clone --depth=1 --branch "$FREECAD_VERSION" "$FREECAD_REPO" \
    && mkdir freecad-build \
    && cd freecad-build \
  # Build
    && cmake \
        -DBUILD_GUI=ON \
        -DBUILD_QT5=ON \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_FEM_NETGEN=ON ../FreeCAD \
    && make -j$(nproc) \
    && make install \
    && cd \
    # Clean
    && rm FreeCAD/ freecad-build/ -fR

# Clean
RUN apt-get clean \
    && rm /var/lib/apt/lists/* \
          /usr/share/doc/* \
          /usr/share/locale/* \
          /usr/share/man/* \
          /usr/share/info/* -fR
