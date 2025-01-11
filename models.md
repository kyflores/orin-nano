# SAM2
Notes for setting up [SAM2](https://github.com/facebookresearch/sam2.git)

This assumes the use of NVIDIA's Pytorch container: `nvcr.io/nvidia/pytorch:24.12-py3-igpu`

When pip tries to install torch as a dependency, it tries to remove the one already in the container.
I commented the torch and torchvision deps in SAM's `setup.py` to workaround this.

Then, execute
```
pip install -e . --no-build-isolation
```

# OWL
https://github.com/NVIDIA-AI-IOT/nanoowl

# SAM
https://github.com/NVIDIA-AI-IOT/nanosam/
