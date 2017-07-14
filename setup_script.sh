#!/bin/bash

# Dependencies. Java for BEAGLE. build-essential for compiling C++ code
# plink1.9 is a tool we are using
# If you want to see info about each package, use apt show
apt update
apt install -y default-jre plink1.9 build-essential

# Prepare to put executables in ~/bin
pushd ~/
if [ ! -d "$HOME/bin" ]; then
  mkdir bin
  echo 'export PATH=$HOME/bin:$PATH' >> .bash_profile
fi

# Move somewhere to download and extract source code
mkdir scratch

pushd scratch
if [ ! -f "$HOME/bin/germline" ]; then
  curl -OL https://github.com/pettyalex/GERMLINE/releases/download/v1.5.Alex/GERMLINE_1.5_Alex.tar.gz
  tar -xf GERMLINE_1.5_Alex.tar.gz
  # Build germline and put it into ~/bin
  pushd GERMLINE_1.5_Alex
  make
  cp germline ~/bin/
  popd
fi

if [ ! -d "$HOME/PRIMUS" ]; then
  curl -OL https://primus.gs.washington.edu/docroot/versions/PRIMUS_v1.9.0.tgz
  mkdir ~/PRIMUS/
  # Extract PRIMUS into a directory called PRIMUS
  tar -xf PRIMUS_v1.9.0.tgz -C ~/PRIMUS/
fi

# Download beagle and make an alias to run it
if [ ! -d "$HOME/BEAGLE" ]; then
  mkdir ~/BEAGLE/
  curl -o ~/BEAGLE/beagle.jar https://faculty.washington.edu/browning/beagle/beagle.08Jun17.d8b.jar
  echo 'alias runbeagle="java -Xmx4G -jar $HOME/BEAGLE/beagle.jar"' >> ~/.bash_profile
fi
popd

# Clean up after ourselves by deleting the scratch directory
rm -rf scratch
popd
