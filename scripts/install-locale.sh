#!/bin/bash

set -e

SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LINK=/usr/share/i18n/locales/en_US@de-custom
[ -f "$LINK" ] || sudo ln -T "$SCRIPT_DIRECTORY"/../en_US@de-custom "$LINK"

rg -q '^\s*en_US@de-custom\s+UTF-8\s*$' /etc/locale.gen || echo 'en_US@de-custom UTF-8' | sudo tee --append /etc/locale.gen > /dev/null
sudo locale-gen

sudo localectl set-locale en_US@de-custom
