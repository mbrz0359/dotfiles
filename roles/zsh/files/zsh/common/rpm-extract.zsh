#!/usr/bin/env zsh

function rpm-extract {
  rpm2cpio "$1" | cpio -idmv
}