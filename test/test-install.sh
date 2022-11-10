#!/usr/bin/env bash

set -euo pipefail

current_script_path="$(dirname "${BASH_SOURCE[0]}")"

export ASDF_INSTALL_VERSION="${1?"Tool version required!"}"
export ASDF_INSTALL_TYPE=version
export ASDF_INSTALL_PATH="${current_script_path}/target/install"
export ASDF_DOWNLOAD_PATH="${current_script_path}/target/download"

rm -rf "${ASDF_INSTALL_PATH}" || true

${current_script_path}/../bin/install