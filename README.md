# bolt-buildhost-yocto-docker
This repo provides Dockerfiles for creating container images that replicate a fully functional x86_64 linux Yocto host build environment. This is created in context of building bolt images (RDK Firebolt) with yocto  with purpose to share, discuss and ease onboarding of the actual host build environment. See actual container images linked to it

## Resulting docker Image Variants
- `yocto-ubuntu-22.04:*` — using Ubuntu 22.04 as base
- `yocto-ubuntu-20.04:*` — using Ubuntu 20.04 as base
## Build
  Usage: ./scripts/build.sh <variant-folder-name> <tag>
```
./scripts/build.sh ubuntu-22.04 Okt25
```
## Run
 Usage: ./scripts/run.sh <image-name:tag> <hostname> 
```
./scripts/run.sh yocto-ubuntu-22.04:Okt25 yocto-u2204
```
## Push (GHCR)
```
echo "$GITHUB_TOKEN" | docker login ghcr.io -u <github-user> --password-stdin
docker tag yocto-ubuntu-22.04:Okt25 ghcr.io/<github-user>/yocto-ubuntu-22.04:Okt25
docker push ghcr.io/<github-user>/yocto-ubuntu-22.04:Okt25
```
