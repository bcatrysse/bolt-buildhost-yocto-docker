# scripts/run.sh
#!/bin/bash
# run a docker image name
# Usage: bash scripts/run.sh <image-name:tag> <hostname>
# Example: ./scripts/run.sh yocto-ubuntu-22.04:latest yocto-u22
#set -euo pipefail

IMAGE="${1:-yocto-ubuntu-22.04:latest}"
NAME="${2:-yocto-u22}"
MY_UID="$(id -u)"
MY_GID="$(id -g)"

exec docker run -it --rm \
        --init \
        --network=host \
        --hostname="$NAME" \
        --add-host "$NAME:127.0.0.1" \
        --volume ${HOME}:${HOME} \
    --user $MY_UID:$MY_GID \
    --group-add 10 \
    --workdir="/home/$USER" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
         "$IMAGE" 

# Customize to add/mount your own shared volumes into the container like 
#        --volume /data:/data \
# adding user to group_id 10 which is "wheel" group
# because "wheel" group members have sudo rights in container image via /etc/sudoers.d/99_wheel

