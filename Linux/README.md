<p align="center">
  <h1 align="center">Enhanced-GPU-PV Linux support</h1>
</p>
<br>

# :information_source: About

For the short story, partitionning the GPU for Windows is quite well documented and the original creator of this project, [James Stringer Easy-GPU-PV](https://github.com/jamesstringerparsec/Easy-GPU-PV) did a very good job making it easy.

But, doing the same thing for Linux is not documented anywhere and getting it done required many hours of research and mixing a lot of instructions to get a working recipe. It was a PITA!

So I decided to script the process for myself and documenting it as well to share it with all other person trying to achieve the same thing. Instead of cloning James project, I used [timminator/Enhanced-GPU-PV](https://github.com/timminator/Enhanced-GPU-PV) because it has already been improved and was maintained recently. It seems more pratical to start from there instead.

# :warning: Before you begin

I *strongly* suggest to test the GPU partitionning with a windows machine before doing it on Linux. But, if you are like me, go ahead with Linux and if you encouter any issues, then go back to Windows Guest and check that you can see a GPU in your VM.

# :warning: Implementation choices

## Linux distribution

When it comes to Linux, many distributions are available and everyone as it's own preferences. I personnaly navigate between a few distributions depending of needs. This repo is based on Ubuntu, and more precisely, on the Ubuntu 24.04 LTS version. The main reason behind this is, It worked!

I push the automation to the maximum that I could, everything that every script does will be documented here.

## My setup (where I tested it)

Ok, since this seems to be uncharted territory, there are my specs :
- Host
    - OS: Windows 11 Pro 
    - RAM: 48 Gb 
    - GPU : NVIDIA GeForce RTX 3060 with 12 Gb VRAM

- Guest :
    - OS : Ubuntu 24.04 LTS Server edition

## Requirements

- Hyper-V server
- WSL
- Git command line available

# Buzz words

For our friends, the search engines!

Hyper-V, GPU partitionning, Linux, Ubuntu, WSL2, NVidia

# Recipe step by step...

## 1. Prepare the environment

  - Download ISO file if required (use -Force to overwrite any existing iso)
  - Set WSL environment
  - Create WSL Driver disk with install script and NVIDIA driver version



