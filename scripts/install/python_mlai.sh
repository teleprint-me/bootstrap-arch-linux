#!/usr/bin/env bash

# Developer Notes:

# It is generally recommended to use pipx to prevent disruption of the system Python environment. However, this approach has limitations.

# Not all libraries are available as system packages. It's unreasonable to expect distribution maintainers to package and maintain software outside their domain.

# Libraries often depend on underlying static and shared objects, which are compiled for specific hardware architectures. Therefore, a one-size-fits-all solution is not feasible.

# Python package distribution and support for libraries appear disorganized and fragmented. There is no clear consensus or universal solution to address these issues, despite numerous proposals.

# PEP-668, which aims to mitigate these issues, obstructs user installs outside of a virtual environment. This is a restrictive solution that doesn't address the root problem.

# When using virtual environments, packages do not have access to system packages and are masked as a result. This is particularly problematic for hardware-specific dependencies, such as those that require ROCm driver support. 

# Since the packages available are mainly focused on Nvidia hardware support, those with different hardware architectures, like ROCm, face challenges. Only CPU or Nvidia pass through in these cases, limiting the usability for other hardware.

# While a --user installation can potentially interfere with a system install, this behavior should be expected. Users need to be able to install libraries in their own environment, especially when specific hardware support is required.

# For cases where packages do not rely on existing system dependencies, installing them in a virtual environment should be encouraged.

# Function to install Python machine learning and AI libraries
install_python_mlai_dependencies() {
    # NOTE: Do NOT use the AUR here!!! Use official packages only!!!
    # Doing otherwise will create a dependency cycle, which will lead to broken
    # builds, which will lead to a mangled system setup.
    if ! sudo pacman -S bpython python-dotenv python-dateutil python-pytz python-iso8601 python-requests python-requests-mock pyopencl-headers python-pyopencl python-numpy python-matplotlib python-nltk python-scikit-learn python-pdfminer --noconfirm; then
        echo "pacman: Failed to install Python OpenCL, ML, and AI libraries"
        exit 1
    fi
}

install_python_mlai_extensions() {
    # NOTE: It's probable that I did something wrong, but I moved sentence-transformers
    # and transformers from a system install to a user install to prevent mangling
    # system packages.
    # Install python dependencies
    if ! pip install --user --break-system-packages sentencepiece sentence-transformers transformers huggingface-hub InstructorEmbedding tiktoken chromadb langchain; then
        echo "pip: Failed to install python library extensions"
        exit 1
    fi

    # Install dev dependencies
    if ! pip install --user --break-system-packages mkdocs; then
        echo "pip: Failed to install python development dependencies"
        exit 1
    fi
}

install_python_pytorch_cpu_extensions() {
    if ! pip install --user --break-system-packages accelerate xformers faiss-cpu; then
        echo "pip: Failed to install pytorch development extensions"
        exit 1
    fi
}

install_python_pytorch_cuda_extension() {
    # Install bitsandbytes
    if ! pip install --user --break-system-packages bitsandbytes; then
        echo "pip: Failed to install bitsandbytes package"
        exit 1
    fi
}

install_python_pytorch_rocm_extension() {
    # Install bitsandbytes with ROCm support
    if ! pip install --user --break-system-packages "git+https://github.com/broncotc/bitsandbytes-rocm@1b52f4243f94cd1b81dd1cad5a9465d9d7add858"; then
        echo "pip: Failed to install bitsandbytes-rocm package"
        exit 1
    fi
}

install_python_mlai() {
    install_python_mlai_dependencies
    install_python_mlai_extensions
    install_python_pytorch_cpu_extensions
}

install_python_mlai_cuda() {
    install_python_mlai
    install_python_pytorch_cuda_extension
}

install_python_mlai_rocm() {
    install_python_mlai
    install_python_pytorch_rocm_extension
}
