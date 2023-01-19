FROM ubuntu:22.04

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    git \
    python3 \
    python3-pip \
    autoconf \
    bc \
    bison \
    gcc \
    make \
    flex \
    build-essential \
    ca-certificates \
    curl \
    device-tree-compiler

# Install RISC-V Toolchain
WORKDIR /tmp
RUN curl --output riscv-gnu-toolchain.tar.gz -L "https://github.com/EIE2-IAC-Labs/Lab0-devtools/releases/download/v1.0.0/riscv-gnu-toolchain-2022-09-21-ubuntu-22.04.tar.gz"
RUN rm -rf /opt/riscv
RUN tar -xzf riscv-gnu-toolchain.tar.gz --directory /opt
ENV PATH="/opt/riscv/bin:${PATH}"
ENV RISCV="/opt/riscv"
RUN rm -rf riscv-gnu-toolchain.tar.gz
RUN riscv64-unknown-elf-gcc --help

# Install Spike RISC-V ISA Simulator
WORKDIR /tmp
RUN git clone https://github.com/riscv-software-src/riscv-isa-sim.git
RUN git checkout v1.1.0
WORKDIR /tmp/riscv-isa-sim
RUN mkdir build
WORKDIR /tmp/riscv-isa-sim/build
RUN ../configure --prefix=$RISCV --with-isa=RV32IMF --with-target=riscv32-unknown-elf
RUN make
RUN make install
RUN rm -rf /tmp/riscv-isa-sim
RUN spike --help

WORKDIR /tmp
RUN git clone https://github.com/riscv-software-src/riscv-pk.git
WORKDIR /tmp/riscv-pk
RUN git checkout 573c858d9071a2216537f71de651a814f76ee76d
RUN mkdir build
WORKDIR /tmp/riscv-pk/build
RUN ../configure --prefix=$RISCV --host=riscv64-unknown-elf --with-arch=rv32imf
RUN make
RUN make install

ENTRYPOINT [ "/bin/bash" ]
