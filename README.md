OSELAS.Toolchain-2011.11.1
==========================

OSELAS.Toolchain for Raspberry Pi

First, install ptxdist-2011.11.0 and its dependencies:
$ apt-get install ...
$ wget ptxdist-2011.11.0.tar.bz2
$ tar -xjvf ptxdist-2011.11.0.tar.bz2
$ ./configure
$ sudo make install

Then, configure OSELAS.Toolchain-2011.11.1:
$ ptxdist select ptxconfigs/arm-1176jzfs-linux-gnueabi_gcc-4.6.2_glibc-2.14.1_binutils-2.21.1a_kernel-2.6.39-sanitized.ptxconfig
$ ptxdist go
