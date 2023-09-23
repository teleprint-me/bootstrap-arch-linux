#!/usr/bin/env bash

source ./scripts/tools/confirm.sh
source ./scripts/install/python_mlai.sh

# Function to install OpenCL
install_opencl() {
    # NOTE: omitted miopengemm for kernel generation because it requires AUR
    if ! sudo pacman -S openblas openblas64 opencl-headers libclc opencl-clhpp ocl-icd lib32-ocl-icd clinfo clpeak nvtop --noconfirm; then
        echo "Failed to install OpenCL"
        exit 1
    fi
}

install_intel_vulkan() {
    if ! sudo pacman -S vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader vkd3d lib32-vkd3d vulkan-headers vulkan-validation-layers vulkan-tools --noconfirm; then
        echo "Failed to install Intel Vulkan driver support"
        exit 1
    fi
}

# Function to install Intel OpenCL
install_intel_opencl() {
    if ! sudo pacman -S intel-graphics-compiler intel-compute-runtime intel-opencl-clang --noconfirm; then
        echo "Failed to install Intel OpenCL"
        exit 1
    fi
}

install_nvidia_vulkan() {
    if ! sudo pacman -S nvidia nvidia-settings nvidia-utils lib32-nvidia-utils vulkan-icd-loader lib32-vulkan-icd-loader vkd3d lib32-vkd3d vulkan-headers vulkan-validation-layers vulkan-tools --noconfirm; then
        echo "Failed to install Nvidia Vulkan driver support"
        exit 1
    fi
}

# Function to install Nvidia CUDA
install_nvidia_cuda() {
    if ! sudo pacman -S cuda cudnn cuda-tools opencv-cuda opencl-nvidia lib32-opencl-nvidia tensorflow-cuda tensorflow-opt-cuda nccl python-cuda python-cuda-docs python-pytorch-cuda python-pytorch-opt-cuda python-tensorflow-cuda python-tensorflow-opt-cuda python-torchvision-cuda --noconfirm; then
        echo "Failed to install Nvidia CUDA"
        exit 1
    fi
}

# Function to install AMD Vulkan driver support
install_amd_vulkan() {
    if ! sudo pacman -S mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader vkd3d lib32-vkd3d vulkan-headers vulkan-validation-layers vulkan-tools --noconfirm; then
        echo "Failed to install AMD Vulkan driver support"
        exit 1
    fi
    echo "AMD Vulkan driver support installed successfully"
}

# Function to install AMD ROCm
install_amd_rocm() {
    if ! sudo pacman -S rocm-core rocm-llvm rocm-clang-ocl rocm-cmake rocm-smi-lib rocm-hip-libraries rocm-hip-runtime rocm-hip-sdk rocm-language-runtime rocm-opencl-runtime rocm-opencl-sdk rocm-device-libs rocm-ml-libraries rocm-ml-sdk rocminfo hipblas rocblas rocsparse rccl python-pytorch-opt-rocm --noconfirm; then
        echo "Failed to install AMD ROCm"
        exit 1
    fi
}

install_intel() {
    confirm_proceed "Intel GPU drivers, OpenCL, and Vulkan" || return

    install_opencl
    install_intel_opencl
    install_intel_vulkan
    install_python_mlai
}

install_nvidia() {
    confirm_proceed "Nvidia GPU drivers, OpenCL, Vulkan, and CUDA" || return
    
    install_opencl
    install_nvidia_vulkan
    install_nvidia_cuda
    install_python_mlai_cuda
}

install_amd() {
    confirm_proceed "AMD GPU drivers, OpenCL, Vulkan, and ROCm" || return

    install_opencl
    install_amd_vulkan
    install_amd_rocm
    install_python_mlai_rocm
}
