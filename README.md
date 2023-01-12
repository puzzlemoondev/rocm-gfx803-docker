# rocm-gfx803-docker

[rocm-terminal](https://hub.docker.com/r/rocm/rocm-terminal) with gfx803 support made possible by [rocm-gfx803](https://github.com/xuhuisheng/rocm-gfx803).

## Flavors

- [rocm-gfx803](https://hub.docker.com/r/puzzlemoondev/rocm-gfx803)
- [rocm-gfx803-diff-svc](https://hub.docker.com/r/puzzlemoondev/rocm-gfx803-diff-svc)

See [Installed packages](#installed-packages) for more information.

## Usage

See [rocm-docker](https://github.com/RadeonOpenCompute/ROCm-docker) for how to run the docker image.

## Installed packages

### rocm-gfx803

Packages compiled with gfx803 support are pulled from https://github.com/xuhuisheng/rocm-gfx803/releases.

- torch-1.11.0a0+git503a092-cp38-cp38-linux_x86_64.whl
- torchvision-0.12.0a0+2662797-cp38-cp38-linux_x86_64.whl
- torchaudio-0.11.0+820b383-cp38-cp38-linux_x86_64.whl
- tensorflow_rocm-2.8.0-cp38-cp38-linux_x86_64.whl

### rocm-gfx803-diff-svc

- Packages in [rocm-gfx803](#rocm-gfx803)
- [diff-svc](https://github.com/prophesier/diff-svc) cloned and dependencies installed
