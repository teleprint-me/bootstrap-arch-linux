#!/usr/bin/env bash

# Function to install OpenCL
setup_opencl() {
    if ! sudo pacman -S openblas openblas64 opencl-headers libclc opencl-clhpp ocl-icd lib32-ocl-icd miopengemm clinfo clpeak nvtop --noconfirm; then
        echo "Failed to install OpenCL"
        exit 1
    fi
}

# Function to install Intel OpenCL
setup_intel_opencl() {
    if ! sudo pacman -S intel-graphics-compiler intel-compute-runtime intel-opencl-clang --noconfirm; then
        echo "Failed to install Intel OpenCL"
        exit 1
    fi
}

# Function to install Nvidia CUDA
setup_nvidia_cuda() {
    if ! sudo pacman -S nvidia nvidia-settings nvidia-utils nccl opencl-nvidia lib32-opencl-nvidia cuda cudnn cuda-tools opencv-cuda tensorflow-cuda tensorflow-opt-cuda python-cuda python-cuda-docs python-pytorch-cuda python-pytorch-opt-cuda python-tensorflow-cuda python-tensorflow-opt-cuda python-torchvision-cuda --noconfirm; then
        echo "Failed to install Nvidia CUDA"
        exit 1
    fi
}

# Function to install AMD Vulkan driver support
install_amd_vulkan() {
    if ! sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vkd3d lib32-vkd3d -noconfirm; then
        echo "Failed to install AMD Vulkan driver support"
        exit 1
    fi
    echo "AMD Vulkan driver support installed successfully"
}

# Function to install AMD ROCm
setup_amd_rocm() {
    if ! sudo pacman -S mesa opencl-mesa lib32-opencl-mesa rocm-core rocm-llvm rocm-clang-ocl rocm-cmake rocm-smi-lib rocm-hip-libraries rocm-hip-runtime rocm-hip-sdk rocm-language-runtime rocm-opencl-runtime rocm-opencl-sdk rocm-device-libs rocm-ml-libraries rocm-ml-sdk rocminfo hipblas rocblas rocsparse python-pytorch-rocm python-pytorch-opt-rocm --noconfirm; then
        echo "Failed to install AMD ROCm"
        exit 1
    fi
}

# Function to install Python machine learning and AI libraries
setup_python_mlai() {
    if ! yay -S pyopencl-headers python-pyopencl python-numpy python-scikit-learn python-sentencepiece python-sentence-transformers python-transformers --noconfirm; then
        echo "Failed to install Python machine learning and AI libraries"
        exit 1
    fi
}
