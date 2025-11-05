FROM pytorch/pytorch:2.9.0-cuda12.8-cudnn9-runtime

# Install system-wise dependencies/utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    openssh-client \
    curl \
    wget \
    unzip \
    ffmpeg \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1 \
    libglib2.0-0 \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    ca-certificates \
    python3-dev \
    sudo \
    locales \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install ffmpeg libsm6 libxext6  -y

# Create a non-root devuser user (UID 1001) — matches common devcontainer UX
ARG USERNAME=devuser
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && id -u $USERNAME || useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up a workspace dir and the default user
ENV WORKSPACE=/workspace
RUN mkdir -p $WORKSPACE && chown $USERNAME:$USERNAME $WORKSPACE
WORKDIR $WORKSPACE

# Copy requirements (if present) early to take advantage of layer caching when code changes
COPY src/requirements.txt /tmp/requirements.txt
COPY src/editable_requirements.txt /tmp/editable_requirements.txt
RUN if [ -s /tmp/requirements.txt ]; then \
      pip --no-cache-dir install -r /tmp/requirements.txt ; \
    fi

# Add workspace to pythonpath
ENV PYTHONPATH="${WORKSPACE}:${PYTHONPATH}"

# Keep shell sane
ENV SHELL=/bin/bash

# Copy the entrypoint
COPY src/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Default to non-root user
USER $USERNAME

ENTRYPOINT ["entrypoint.sh"]
CMD ["bash"]