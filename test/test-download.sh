#!/usr/bin/env bash

set -euo pipefail

current_script_path="$(dirname "${BASH_SOURCE[0]}")"

export ASDF_INSTALL_VERSION="${1?"Tool version required!"}"
export ASDF_DOWNLOAD_PATH="${current_script_path}/target/download"

rm -rf "${ASDF_DOWNLOAD_PATH}" || true

${current_script_path}/../bin/download