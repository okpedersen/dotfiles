FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y git xz-utils curl sudo git

RUN useradd -m docker && echo "docker:docker" | chpasswd && adduser docker sudo
# Give docker access to run sudo without using passwd
RUN echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER docker
WORKDIR /home/docker

COPY --chown=docker:docker . dotfiles/
RUN export USER=docker && cd dotfiles && ./bootstrap-nix.sh


# TODO move user to ENV
# Login shell needed to source .profile properly
CMD USER=docker /bin/bash -l
