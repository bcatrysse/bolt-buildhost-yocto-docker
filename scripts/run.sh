# scripts/run.sh
#!/bin/bash
# run a docker image name
# Usage: bash scripts/run.sh <image-name:tag> <hostname>
# Example: ./scripts/run.sh yocto-ubuntu-22.04:latest yocto-u22
set -euo pipefail

IMAGE="${1:-ghcr.io/bcatrysse/yocto-ubuntu-22.04:feb26}"
NAME="${2:-yocto-u22}"
MY_UID="$(id -u)"
MY_GID="$(id -g)"


# Initialize to satisfy -u in set -euo 
ADMIN_GID=""
# Try wheel, but don't die if it doesn't exist, typically does not exist on debian and ubuntu
ADMIN_GID="$(getent group wheel | cut -d: -f3 || true)"
# Fallback to sudo if still empty
[ -z "$ADMIN_GID" ] && ADMIN_GID="$(getent group sudo | cut -d: -f3 || true)"

if [ -z "$ADMIN_GID" ]; then
  echo "no wheel or sudo group found, not starting container but exiting" >&2
  exit 1
fi

exec docker run -it --rm \
        --init \
        --network=host \
        --hostname="$NAME" \
        --add-host "$NAME:127.0.0.1" \
        --volume ${HOME}:${HOME} \
    --user $MY_UID:$MY_GID \
    --group-add $ADMIN_GID \
    --workdir="${HOME}" \
    --volume="/etc/group:/etc/group:ro" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
         "$IMAGE" 

# Customize to add/mount your own shared volumes into the container like 
#        --volume /data:/data \
# adding user to group_id 10 which is "wheel" group on some distro
# because "wheel" group members have sudo rights in container image via /etc/sudoers.d/99_wheel

