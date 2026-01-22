#!/bin/bash

set -e

SCRIPT_DIRECTORY=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

LINK=/usr/share/i18n/locales/de-locale
[ -f "$LINK" ] || sudo ln -T "$SCRIPT_DIRECTORY"/../de-locale "$LINK"

rg -q '^\s*de-locale\s+UTF-8\s*$' /etc/locale.gen || echo 'de-locale UTF-8' | sudo tee --append /etc/locale.gen > /dev/null
sudo locale-gen

echo LANG=de-locale.UTF-8 | sudo tee /etc/locale.conf > /dev/null
