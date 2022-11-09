#!/usr/bin/env bash

set -euo pipefail

PACKAGES_URL="https://packages.confluent.io/archive"
TOOL_NAME="kafka"
TOOL_TEST="kafka-topics --version"

fail() {
  echo -e "asdf-$TOOL_NAME: $*"
  exit 1
}

curl_opts=(-fsSL)

list_all_versions() {
  local versions="$(curl $curl_opts "${PACKAGES_URL}/" | sed -rn 's/^[ ]*<a href="\/archive\/.*\/">(.*)\/<\/a>/\1/p' | tr '\n' ' ')"
  for version in $versions; do
    curl $curl_opts ${PACKAGES_URL}/${version}/ | sed -rn 's/^.*<a.*>(confluent-(community|oss)-[0-9\.-]*)\.tar.gz<\/a>/\1/p'
  done
  for version in $versions; do
    curl $curl_opts ${PACKAGES_URL}/${version}/ | sed -rn 's/^.*<a.*>confluent-([0-9\.-]*)\.tar.gz<\/a>/confluent-enterprise-\1/p'
  done
}

download_release() {
  local version filename majorversion downloadversion url
  version="$1"
  filename="$2"

  # extract first two version numbers
  majorversion="$(echo ${version} | sed -rn 's/^confluent-(oss|community|enterprise)-([0-9]*\.[0-9]*)\..*$/\2/p')"
  # remove 'enterprise-' from version
  downloadversion="$(echo ${version} | sed -rn 's/^(confluent-)(oss-|community-)?(enterprise-)?([0-9\.-]*)$/\1\2\4/p')"
  url="${PACKAGES_URL}/${majorversion}/${downloadversion}.tar.gz"

  echo "* Downloading $TOOL_NAME release $version..."
  curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
  local install_type="$1"
  local version="$2"
  local install_path="${3%/bin}"

  if [ "$install_type" != "version" ]; then
    fail "asdf-$TOOL_NAME supports release installs only"
  fi

  (
    mkdir -p "$install_path"
    cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

    local tool_cmd
    tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
    test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

    echo "$TOOL_NAME $version installation was successful!"
  ) || (
    rm -rf "$install_path"
    fail "An error occurred while installing $TOOL_NAME $version."
  )
}
