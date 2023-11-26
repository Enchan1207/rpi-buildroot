![banner](https://github.com/Enchan1207/rpi-buildroot/blob/b7bc2a5d01727995bf4a89d5477b4f53fe3b3058/banner.png)

Let's incorporate Raspberry Pi into your project's CI/CD loop!

## Overview

rpi-buildroot is GitHub Actions action for building Raspberry Pi image.

The backend uses [Buildroot](https://buildroot.org/), so you can use its caching system.
Combined with [Github Actions caching](https://docs.github.com/en/actions/using-workflows/caching-dependencies-to-speed-up-workflows), you can reduce build times to up to **about half an hour**!

## Contents

This repository provides:

 - **Buildroot base image**: The minimum Docker image for Buildroot to work. It's published on [Docker Hub](https://hub.docker.com/r/enchan1207/buildroot_base).
 - **GitHub Actions action**: The custom action for inclusion and use in other repositories.

## Usage

About basic usage and examples, see [wiki](https://github.com/Enchan1207/rpi-buildroot/wiki) pages.

### Most simple; just build image

```yml
- name: Create Raspberry Pi image
  uses: Enchan1207/rpi-buildroot@v1
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    config_file: 'path/to/buildroot.config'
    output_path: 'sdcard.img'
```

### Details; action inputs

#### `github_token` (required)

GitHub Token for gh CLI. This token is required for interacting with the GitHub API.

#### `config_file` (required)

Path to the Buildroot configuration file. This file defines the components and settings for the custom Raspberry Pi image.

#### `output_path` (optional, default: "sdcard.img")

Output destination of the built image. The default is set to "(workspace)/sdcard.img".

#### `pre_build_script` (optional)

Path to a script to run in the container before the build process starts. This script can be used for tasks such as invoking utilities or preparing the environment.

#### `post_build_script` (optional)

Path to a script to run in the container after the build process completes. This script can be used for tasks such as cleaning up the build directory.

#### `rootfs_overlay_dir` (optional)

Path to the RootFS-overlay directory. This directory contains additional files or modifications to be applied to the root filesystem.

#### `buildroot_log_path` (optional)

Buildroot log output path. If specified, the Buildroot build logs will be saved to the specified location.

#### `build_cache_key` (optional, default: "buildroot_build_cache-${{ runner.name }}-${{ github.ref_name }}")

Actions cache key for Buildroot. This key is used to cache the results of the Buildroot build process for faster subsequent builds.

#### `build_cache_restore_key` (optional, default: "buildroot_build_cache")

Actions cache restore key for Buildroot. This key is used to restore the cached build results.

## License

This repository is published under [MIT License](LICENSE).
