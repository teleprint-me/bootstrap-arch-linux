#!/usr/bin/env bash

# Function to install Python machine learning and AI libraries
install_python_mlai_dependencies() {
    if ! yay -S pyopencl-headers python-pyopencl python-numpy python-matplotlib python-nltk python-scikit-learn python-sentencepiece python-sentence-transformers python-transformers python-huggingface-hub --noconfirm; then
        echo "Failed to install Python ML and AI libraries"
        exit 1
    fi
}

install_python_mlai_extensions() {
    # Install python dependencies
    if ! pip install dotenv dateutil pytz iso8601 requests pdfminer-six chromadb tiktoken langchain -y; then
        echo "Failed to install Python ML and AI library extensions"
        exit 1
    fi

    # Install dev dependencies
    if ! pip install bpython mkdocs requests-mock -y; then
        echo "Failed to install Python development extras"
        exit 1
    fi
}

install_python_pytorch_cuda_extension() {
    # Install bitsandbytes
    if ! pip install bitsandbytes -y; then
        echo "Failed to pip install bitsandbytes package"
        exit 1
    fi
}

install_python_pytorch_rocm_extension() {
    # Install bitsandbytes with ROCm support
    if ! pip install "git+https://github.com/broncotc/bitsandbytes-rocm@1b52f4243f94cd1b81dd1cad5a9465d9d7add858" -y; then
        echo "Failed to pip install bitsandbytes-rocm package"
        exit 1
    fi
}

install_python_mlai() {
    install_python_mlai_dependencies
    install_python_mlai_extensions
}
