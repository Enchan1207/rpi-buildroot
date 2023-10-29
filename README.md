# rpi-buildroot

Buildroot for Raspberry Pi 3

## Overview

This repository builds [external toolchain](https://buildroot.org/downloads/manual/manual.html#build-toolchain-with-buildroot) and base docker image of Buildroot for Raspberry Pi 3. By using this, you can build Raspberry Pi 3 image quickly.

**Update:** This repository is now available as an action in GitHub Actions.

## Contents

This repository provides shown below:

 - **External toolchain**: Compilers, binary utilities (like assembler or linker), and a standard C library.
 - **Legal information**: License or legal informations about programs included in external toolchains.
 - **Buildroot base image**: The minimum Docker image for Buildroot to work. 
 - **GitHub Actions action**: The custom action for inclusion and use in other repositories.

External toolchain and legal information is included in [release](https://github.com/Enchan1207/rpi-buildroot/releases). Buildroot base image is published on [Docker Hub](https://hub.docker.com/repository/docker/enchan1207/buildroot_base/general).

## Usage

under construction...

## License

**This repository** is published under [MIT License](LICENSE). PLEASE check the licenses for Buildroot and generated artifacts.
