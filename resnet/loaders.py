import os

import torch
torch.set_float32_matmul_precision('high')
import torch.utils.data as tud
import torch.nn as nn

import torchvision.transforms.v2 as tv2
import torchvision.transforms.functional as tvf
import torchvision.datasets as tds
import torchvision.utils as tu

DIM=160
cpu_num = os.cpu_count() // 2

def get_loaders(batchsize):
    dataset_root = './datasets'
    download = (not os.path.exists("datasets/imagenette2-160.tgz"))

    train_tfs = tv2.Compose([
        tv2.RandomCrop(DIM, 4),
        tv2.ColorJitter(
            brightness=0.2,
            contrast=0.2,
            saturation=0.2,
            hue=0.1
        ),
        tv2.RandomHorizontalFlip(0.5),
        tv2.RandomVerticalFlip(0.25),
        tv2.ToImage(),
        tv2.ToDtype(torch.float32, scale=True)
    ])
    
    val_tfs = tv2.Compose([
        tv2.CenterCrop(DIM),
        tv2.ToImage(),
        tv2.ToDtype(torch.float32, scale=True),
    ])
    
    train = tds.imagenette.Imagenette(
        dataset_root,
        "train",
        "160px",
        download=download,
        transform=train_tfs
    )
    
    val = tds.imagenette.Imagenette(
        dataset_root,
        "val",
        "160px",
        download=False,
        transform=val_tfs
    )
    
    batchsize = 64
    
    train_loader = tud.DataLoader(train, batch_size=batchsize, num_workers=cpu_num, shuffle=True)
    val_loader = tud.DataLoader(val, batch_size=batchsize, shuffle=True)

    return DIM, train_loader, val_loader