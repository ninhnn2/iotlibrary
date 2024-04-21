#/bin/bash

PREFIX_CROSS=/var/tmp/midware
COMPILER_CROSS=/opt/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-

./configure --host=arm-linux --prefix=${PREFIX_CROSS} CC=${COMPILER_CROSS}gcc

make -j4

sudo make install
