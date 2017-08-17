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
RUN mkdir -p /home/nobody/build && chown -R nobody: /home/nobody

USER nobody
ENV HOME=/home/nobody
ENV EDITOR=/bin/true
WORKDIR /home/nobody

RUN gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
RUN curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/cower.tar.gz | tar xz && \
    cd cower && \
    makepkg -si --noconfirm --asdeps && \
    cd ~ && rm -rf cower

RUN curl -L https://aur.archlinux.org/cgit/aur.git/snapshot/pacaur.tar.gz | tar xz && \
    cd pacaur && \
    makepkg -si --noconfirm --asdeps && \
    cd ~ && rm -rf pacaur

ENV PKGDEST=/home/nobody/build
