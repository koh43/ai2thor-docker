ARG CUDA_VERSION=12.8

FROM nvidia/cuda:$CUDA_VERSION.1-devel-ubuntu22.04
ARG NVIDIA_VERSION

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get -y install python3-pip libglib2.0-0 libvulkan1 libvulkan-dev vulkan-tools python3-venv vim pciutils wget git kmod vim git

ENV APP_HOME=/app
WORKDIR $APP_HOME
COPY requirements.txt scripts/install_nvidia.sh /app/
RUN pip install --upgrade pip

RUN pip install -r requirements.txt && python3 -c "import os; import ai2thor.build; ai2thor.build.Build('CloudRendering', ai2thor.build.DEFAULT_CLOUDRENDERING_COMMIT_ID, False, releases_dir=os.path.join(os.path.expanduser('~'), '.ai2thor/releases')).download()"
RUN NVIDIA_VERSION=$NVIDIA_VERSION /app/install_nvidia.sh
RUN mkdir -p /app/IteraPlan

COPY example_agent.py ./

CMD ["/bin/bash"]
