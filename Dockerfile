FROM archlinux/base
MAINTAINER roey.ghost@gmail.com

# Install build dependenceis and allow nobody to build
RUN rm /usr/share/libalpm/hooks/package-cleanup.hook
RUN pacman -Sy sudo --noconfirm --needed base-devel asp
RUN echo "nobody ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nobody

ADD set_makeopts.sh /usr/local/bin/set_makeopts.sh
RUN chmod +x /usr/local/bin/set_makeopts.sh && /usr/local/bin/set_makeopts.sh

ONBUILD RUN sudo /usr/local/bin/set_makeopts.sh

# Install Pacaur
RUN mkdir /build && chown nobody: build

USER nobody
ENV HOME=/build
ENV EDITOR=/bin/true
WORKDIR /build

RUN gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
RUN curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz | tar xz && \
    cd /build/cower && \
    makepkg -si --noconfirm --asdeps && \
    cd /build && rm -rf cower

RUN curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz | tar xz && \
    cd /build/pacaur && \
    makepkg -si --noconfirm --asdeps && \
    cd /build && rm -rf pacaur

ENV PKGDEST=/build
