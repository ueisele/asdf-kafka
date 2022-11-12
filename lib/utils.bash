#!/usr/bin/env bash

set -euo pipefail

CONFLUENT_PACKAGES_URL="https://packages.confluent.io/archive"
APACHE_PACKAGES_URL="https://archive.apache.org/dist/kafka"
TOOL_NAME="kafka"
TOOL_TEST="kafka-topics --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

list_confluent_versions() {
	# extract available major versions from html page
	local versions="$(
		curl $curl_opts "${CONFLUENT_PACKAGES_URL}/" |
			sed -rn 's/^[ ]*<a href="\/archive\/.*\/">(.*)\/<\/a>/\1/p' | tr '\n' ' '
	)"
	# enterprise
	for version in $versions; do
		# extract available versions from html page (without scala version)
		# output pattern: confluent-enterprise-<version>
		curl $curl_opts ${CONFLUENT_PACKAGES_URL}/${version}/ |
			sed -rn 's/^.*<a.*>confluent-([0-9\.]*)(-[0-9\.]*)?\.tar\.gz<\/a>/confluent-enterprise-\1/p' |
			sort -V |
			uniq
	done
	# community
	for version in $versions; do
		# extract available versions from html page (without scala version)
		# output pattern: confluent-community-<version>
		curl $curl_opts ${CONFLUENT_PACKAGES_URL}/${version}/ |
			sed -rn 's/^.*<a.*>confluent-(community|oss)-([0-9\.]*)(-[0-9\.]*)?\.tar\.gz<\/a>/confluent-community-\2/p' |
			sort -V |
			uniq
	done
}

list_apache_versions() {
	# extract available versions from html page (without scala version)
	# output pattern: apache-<version>
	curl $curl_opts "${APACHE_PACKAGES_URL}/" |
		sed -rn 's/^.*<a href=.*>([0-9\.]*)\/<\/a>.*$/apache-\1/p' |
		sort -V
}

list_all_versions() {
	list_confluent_versions
	list_apache_versions
}

confluent_download_url() {
	local version majorversion downloadversion scalapostfix
	version="$1"
	# extract first two version numbers
	majorversion="$(echo ${version} | sed -rn 's/^.*-([0-9]*\.[0-9]*)(\.[0-9]*)*$/\1/p')"
	# resolve actual version name for download, depending on release type
	if [[ ${version} =~ ^confluent-enterprise ]]; then
		# confluent-enterprise-<version> -> confluent-<version>
		downloadversion="$(echo ${version} | sed -rn 's/^.*-([0-9\.]*)$/confluent-\1/p')"
	elif [[ ${version} =~ ^confluent-community-[34] ]] || [[ ${version} =~ ^confluent-community-5\.0 ]]; then
		# confluent-community-<version =~ [34]|5.0> -> confluent-oss-<version>
		downloadversion="$(echo ${version} | sed -rn 's/^.*-([0-9\.]*)$/confluent-oss-\1/p')"
	else
		downloadversion="${version}"
	fi
	# determine most current scala version if present (only until 5.0)
	scalapostfix="$(
		curl $curl_opts ${CONFLUENT_PACKAGES_URL}/${majorversion}/ |
			sed -rn "s/^.*${downloadversion}(-[0-9\.]*)?\.tar\.gz<\/a>/\1/p" |
			sort |
			tail -1
	)"
	# output download url
	echo "${CONFLUENT_PACKAGES_URL}/${majorversion}/${downloadversion}${scalapostfix}.tar.gz"
}

apache_download_url() {
	local version downloadversion scalaversion extension
	version="$1"
	# remove 'apache-' from version
	downloadversion="$(echo ${version} | sed -rn 's/^apache-(.*)$/\1/p')"
	# extract most current scala version
	scalaversion="$(
		curl $curl_opts "${APACHE_PACKAGES_URL}/${downloadversion}/" |
			sed -rn 's/^.*<a href=.*>kafka_([0-9\.]*)-.*$/\1/p' |
			uniq |
			sort -V |
			tail -1
	)"
	# determine extension (0.8.0 has .tar.gz all others have .tgz)
	if [[ "${downloadversion}" == "0.8.0" ]]; then
		extension="tar.gz"
	else
		extension="tgz"
	fi
	# output download url
	echo "${APACHE_PACKAGES_URL}/${downloadversion}/kafka_${scalaversion}-${downloadversion}.${extension}"
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	# determine url depending on release type
	if [[ ${version} =~ ^confluent- ]]; then
		url="$(confluent_download_url "${version}")"
	elif [[ ${version} =~ ^apache- ]]; then
		url="$(apache_download_url "${version}")"
	else
		fail "asdf-$TOOL_NAME does not support downloading release ${version}."
	fi
	# download the release
	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

normalize_files() {
	local file_path="$1"
	# apache: remove .sh extension (.bak suffix is require by macos)
	find ${file_path} -maxdepth 1 -name "*.sh" -exec \
		sh -c 'old="{}" new="${old%.sh}"; mv "${old}" "${new}"; sed -i".bak" "s/\(kafka-run-class\)\.sh/\1/g" "${new}"; rm -f "${new}.bak"' \;
	# apache-0.8.0: rename kafka-list-topic to kafka-topics
	find ${file_path} -maxdepth 1 -name "kafka-list-topic" -exec \
		mv {} "${file_path}/kafka-topics" \;
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

		normalize_files "$install_path/bin"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/bin/$tool_cmd" || fail "Expected $install_path/bin/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
