#!/usr/bin/env bash

sudo nixos-rebuild switch -I nixos-config=$PWD/configuration.nix --fallback
