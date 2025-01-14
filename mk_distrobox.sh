# !/bin/bash
# Uses distrobox to make a container, which is more convenient for development.

if [ -f "/etc/nv_tegra_release" ];
then
    printf "Detected orin platform.\n"
    IMAGE=nvcr.io/nvidia/pytorch:24.12-py3-igpu
else
    printf "Detected desktop platform.\n"
    IMAGE=nvcr.io/nvidia/pytorch:24.12-py3
fi

# TODO /var/tmp/.${USER}.passwd.initialize doesn't clear correctly
# on the orin nano using distrobox?
distrobox create \
    --name nvtorch \
    --hostname nvtorch \
    --image ${IMAGE} \
    -a "--runtime nvidia --ulimit memlock=-1 --ulimit stack=67108864"

