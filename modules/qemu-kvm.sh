#!/usr/bin/env bash
# qemu-kvm.sh
# Install support files needed to work with KVM virtual machines using libvirt

sudo apt install qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager ovmf cpu-checker

# after this we need to inform the user to create a bridge etc (or make it verty clear in the docs
# that we dont do this.
