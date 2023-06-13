#!/usr/bin/env bash

# Function to install Python development tools
install_python() {
    if ! sudo pacman -S python-pip python-pytest python-pipx python-virtualenv python-isort python-black flake8 ruff mypy --noconfirm; then
        echo "Failed to install python development packages"
        exit 1
    fi
}

# Function to install Python machine learning and AI libraries
install_python_mlai_dependencies() {
    if ! yay -S pyopencl-headers python-pyopencl python-numpy python-matplotlib python-nltk python-scikit-learn python-sentencepiece python-sentence-transformers python-transformers python-huggingface-hub --noconfirm; then
        echo "Failed to install Python machine learning and AI libraries"
        exit 1
    fi
}

install_python_mlai_extensions() {
    # Install python dependencies
    pip install --upgrade dotenv dateutil pytz iso8601 requests pdfminer-six chromadb tiktoken langchain

    # Install dev dependencies
    pip install --upgrade bpython mkdocs requests-mock
}

install_python_pytorch_cuda_extension() {
    # Install bitsandbytes
    pip install --upgrade bitsandbytes
}

install_python_pytorch_rocm_extension() {
    # Install bitsandbytes with ROCm support
    pip install --upgrade "git+https://github.com/broncotc/bitsandbytes-rocm@1b52f4243f94cd1b81dd1cad5a9465d9d7add858"
}

install_python_mlai() {
    install_python_mlai_dependencies
    install_python_mlai_extensions
}
