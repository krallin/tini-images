#!/bin/bash
# Autogenerates Dockerfiles based on configuration
set -o errexit
set -o nounset

# Config
TINI_REAL_VERSION="0.18.0"
TINI_VERSION="v${TINI_REAL_VERSION}"

# Script

REL_HERE="$(dirname "${BASH_SOURCE}")"
HERE=$(cd "${REL_HERE}"; pwd)

AUTOGEN_TARGET=$(cd "${HERE}/../autogen"; pwd)

pushd "${HERE}" >/dev/null

for dir in "platform/"*; do
  versions="$(cat "${dir}/VERSIONS")"

  platform="$(basename "${dir}")"
  for version in ${versions}; do
    dir="${AUTOGEN_TARGET}/${platform}-${version}"
    source_image="${platform}:${version}"
    dockerfile="${dir}/Dockerfile"

    echo "Preparing Dockerfile for ${source_image} in ${dockerfile}"
    mkdir -p "$dir"

    cp "${HERE}/Dockerfile.in" "${dockerfile}"

    perl -pe "s/__SOURCE_IMAGE__/'${source_image}'/ge" -i "${dockerfile}"
    perl -pe "s/__TINI_VERSION__/'${TINI_VERSION}'/ge" -i "${dockerfile}"
    perl -pe "s/__TINI_REAL_VERSION__/'${TINI_REAL_VERSION}'/ge" -i "${dockerfile}"

    perl -pe 's/__TINI_BUILD_APP__/`cat build-app`/ge' -i "${dockerfile}"

    pushd "${HERE}/platform/${platform}" >/dev/null
    perl -pe 's/__TINI_INSTALL_APP__/`cat install-app | perl -pe "chomp if eof"`/ge' -i "${dockerfile}"
    perl -pe 's/__TINI_INSTALL_DEPS__/`cat install-deps | perl -pe "chomp if eof"`/ge' -i "${dockerfile}"
    perl -pe 's/__TINI_MOVE_APP__/`cat move-app | perl -pe "chomp if eof"`/ge' -i "${dockerfile}"
    perl -pe 's/__TINI_COPY_APP__/`cat copy-app | perl -pe "chomp if eof"`/ge' -i "${dockerfile}"
    popd >/dev/null

    perl -n -e 'print if /\S/' -i "${dockerfile}"

    echo "${source_image}" > "${dir}/SOURCE-TAG"
    echo "krallin/${platform}-tini:${version}" > "${dir}/TAG"
  done
done

popd >/dev/null
