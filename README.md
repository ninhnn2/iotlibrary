# iotlibrary

#### Just for openssl to build
```shell
./Configure linux-armv4 -fPIC no-asm -shared --prefix=/var/tmp/midware --cross-compile-prefix=/home/fanning/workspace/tools/gcc-linaro-7.5.0-2019.12-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
make -j200
sudo make install
```
