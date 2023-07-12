### RISC-V 

[RISC-V GNU Toolchain][riscv-gnu-toolchain] by [RISC-V Software Collaboration][riscv-collab] for [RISC-V][riscv] architecture

**WARNING**: git clone within the GNU RISC-V Toolchain takes around 6.65 GB of disk and download size

Required packages for RISC-V GNU Toolchain _(Debian Bullseye)_

|-|-|-|-|
|:-:|:-:|:-:|:-:|
|autoconf|automake|autotools-dev|bc|
|bison|build-essential|curl|flex|
|gawk|git|gperf|libcxxopts-dev|
|libcxx-serial-dev|libcxxtools-dev|libexpat-dev|libfdt-dev|
|libglib2.0-dev|libgmp-dev|libmpc-dev|libmpfr-dev|
|libncurses5-dev|libncursesw5-dev|libpixman-1-dev|libtool|
|ninja-build|patchutils|python3|texinfo|
|zlib1g-dev|clang||

```bash
sudo apt-get update -y && \
sudo apt-get install -y autoconf \
                        automake \
                        autotools-dev \
                        bc \
                        bison \
                        build-essential \
                        clang \
                        curl \
                        flex \
                        gawk \
                        git \
                        gperf \
                        libcxxopts-dev \
                        libcxx-serial-dev \
                        libcxxtools-dev \
                        libexpat-dev \
                        libfdt-dev \
                        libglib2.0-dev \
                        libgmp-dev \
                        libmpc-dev \
                        libmpfr-dev \
                        libncurses5-dev \
                        libncursesw5-dev \
                        libpixman-1-dev \
                        libtool \
                        libssl-dev \
                        lld \
                        ninja-build \
                        patchutils \
                        python3 \
                        texinfo \
                        zlib1g-dev
```

### Musl-cross-make

Working configuration for Musl-cross-make _(At the moment anyway)_

```bash
BINUTILS_VER = 2.33.1
GCC_VER = 10.3.0
MUSL_VER = git-master
GMP_VER = 6.1.2
MPC_VER = 1.1.0
MPFR_VER = 4.0.2
ISL_VER = 0.15
LINUX_VER = 5.8.5
```

<!-- LINKS -->

[riscv-gnu-toolchain]: https://github.com/riscv-collab/riscv-gnu-toolchain

[riscv-collab]: https://github.com/riscv-collab

[riscv]: https://github.com/riscv

<!-- LINKS END -->
