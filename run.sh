#!/usr/bin/env bash

qemu-kvm -cdrom dist/x86_64/kernel.iso -monitor stdio
