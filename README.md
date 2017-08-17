# Arch Linux Builder #
Using Arch Linux as a base image for another Docker image is useful, since Arch has a large variety of
packages, mostly in their most recent versions. However, sometimes you also have to install packages
from [AUR](https://wiki.archlinux.org/index.php/Arch_User_Repository). In order to do that inside Docker you have to:

1. Install `base-devel` and `sudo`
2. Configure sudo to allow `nobody` to execute anything without requiring a password
3. Download and install cower manually
4. Download and install [Pacuar](https://github.com/rmarquis/pacaur) manually
5. Set up a home directory for nobody
6. Execute Pacaur as Nobody

Doing so will add more code into your Dockerfile as well as make the size of the final image much
larger than needed.

You can avoid all of that by taking advantage of Docker's [multi-stage
builds](https://docs.docker.com/engine/userguide/eng-image/multistage-build/) together with this
image:

    FROM darwish/archlinux-builder AS build
    RUN pacaur -am rpm-org dpkg

    FROM archlinux/base
    COPY --from=build /home/nobody/build/*.pkg.tar.xz /tmp/
    RUN pacman -Sy && pacman -U --noconfirm /tmp/*.pkg.tar.xz
    RUN rpm --version
    RUN dpkg --version

The final is derived from the official Arch Linux image and does not contain any build dependencies. 
