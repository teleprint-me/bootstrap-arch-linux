#!/usr/bin/env bash

# NOTE: Use pipx to prevent mangling the system python environment.
# Packages within virtual environments will not have access to system 
# packages and are masked by the environment as a result.
# Only CPU or Nvidia will pass through as a result.

# Function to install Python machine learning and AI libraries
install_python_mlai_dependencies() {
    # NOTE: Do NOT use the AUR here!!! Use official packages only!!!
    # Doing otherwise will create a dependency cycle, which will lead to broken
    # builds, which will lead to a mangled system setup.
    if ! pacman -S pyopencl-headers python-pyopencl python-numpy python-matplotlib 	python-nltk python-scikit-learn --noconfirm; then
        echo "pacman: Failed to install Python OpenCL, ML, and AI libraries"
        exit 1
    fi
}

install_python_mlai_extensions() {
    # NOTE: It's probable that I did something wrong, but I moved sentence-transformers
    # and transformers from a system install to a user install to prevent mangling
    # system packages.
    # Install python dependencies
    if ! pipx install dotenv dateutil pytz iso8601 requests pdfminer-six chromadb tiktoken sentencepiece sentence-transformers transformers huggingface-hub langchain -y; then
        echo "pipx: Failed to install python library extensions"
        exit 1
    fi

    # Install dev dependencies
    if ! pipx install bpython mkdocs requests-mock -y; then
        echo "pipx: Failed to install python development dependencies"
        exit 1
    fi
}

install_python_pytorch_cuda_extension() {
    # Install bitsandbytes
    if ! pipx install bitsandbytes -y; then
        echo "pipx: Failed to install bitsandbytes package"
        exit 1
    fi
}

install_python_pytorch_rocm_extension() {
    # Install bitsandbytes with ROCm support
    if ! pipx install "git+https://github.com/broncotc/bitsandbytes-rocm@1b52f4243f94cd1b81dd1cad5a9465d9d7add858" -y; then
        echo "pipx: Failed to install bitsandbytes-rocm package"
        exit 1
    fi
}

install_python_mlai() {
    install_python_mlai_dependencies
    install_python_mlai_extensions
}

install_python_mlai_cuda() {
    install_python_mlai
    install_python_pytorch_cuda_extension
}

install_python_mlai_rocm() {
    install_python_mlai
    install_python_pytorch_rocm_extension
}
