#!/bin/sh

echo "Setting parallel build to $(nproc)"
echo "MAKEFLAGS=\"-j$(nproc)\"" >> /etc/make.conf
