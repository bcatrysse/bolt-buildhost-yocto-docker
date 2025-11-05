# bolt-buildhost-yocto-docker
This repo provides Dockerfiles for creating container images that replicate a fully functional x86_64 linux Yocto host build environment.   
This was created in context of building yocto based bolt images (RDK Firebolt) with purpose to share, discuss and ease onboarding of the actual yocto **host build environment** for developers. 

## Resulting docker Image Variants
See resulting container images available on ghcr.io (GitHub Container Registry from github packages service) and linked to this repository  
see https://github.com/bcatrysse?ecosystem=container&tab=packages&tab=packages&ecosystem=container&q=yocto
- `yocto-ubuntu-22.04:*` — using Ubuntu 22.04 as base
- `yocto-ubuntu-20.04:*` — using Ubuntu 20.04 as base  

When you have installed a docker environment on your system you can pull them as follows 
```
docker pull ghcr.io/bcatrysse/yocto-ubuntu-22.04:Nov25
docker pull ghcr.io/bcatrysse/yocto-ubuntu-20.04:Nov25
```

## Build docker container from Dockerfile
  Usage: ./scripts/build.sh "variant-folder-name" "tag"
```
./scripts/build.sh ubuntu-22.04 Okt25
```
## Run yocto-buildhost container
 Usage: ./scripts/run.sh "image-name:tag" "hostname" 
```
./scripts/run.sh yocto-ubuntu-22.04:Okt25 yocto-u2204
```
## Push created docker container to GHCR
```
echo "$GITHUB_TOKEN" | docker login ghcr.io -u <github-user> --password-stdin
docker tag yocto-ubuntu-22.04:Okt25 ghcr.io/<github-user>/yocto-ubuntu-22.04:Okt25
docker push ghcr.io/<github-user>/yocto-ubuntu-22.04:Okt25
```
