#!/bin/bash
# Autogenerates Dockerfiles based on configuration
set -o errexit
set -o nounset

# Script

REL_HERE="$(dirname "${BASH_SOURCE}")"
HERE=$(cd "${REL_HERE}"; pwd)

AUTOGEN_TARGET=$(cd "${HERE}/../autogen"; pwd)

pushd "${HERE}" >/dev/null

for dir in "platform/"*; do
  versions="$(cat "${dir}/VERSIONS")"

  platform="$(basename "${dir}")"
  for version in ${versions}; do
    source_image="${platform}:${version}"
    tini_versions="$(cat "${HERE}/VERSIONS")"
    for tini_version in ${tini_versions}; do
      # Config
      TINI_REAL_VERSION="${tini_version}"
      TINI_VERSION="v${TINI_REAL_VERSION}"

      dockerfile="${AUTOGEN_TARGET}/${platform}-${version}-${tini_version}/Dockerfile"

      echo "Preparing Dockerfile for ${source_image} in ${dockerfile}"
      mkdir -p "$(dirname "${dockerfile}")"

      cp "${HERE}/Dockerfile.in" "${dockerfile}"

      perl -pe "s/__SOURCE_IMAGE__/'${source_image}'/ge" -i "${dockerfile}"
      perl -pe "s/__TINI_VERSION__/'${TINI_VERSION}'/ge" -i "${dockerfile}"
      perl -pe "s/__TINI_REAL_VERSION__/'${TINI_REAL_VERSION}'/ge" -i "${dockerfile}"

      perl -pe 's/__TINI_BUILD_APP__/`cat build-app`/ge' -i "${dockerfile}"
      perl -pe 's/__TINI_CLEANUP_APP__/`cat cleanup-app`/ge' -i "${dockerfile}"

      pushd "${HERE}/platform/${platform}" >/dev/null
      perl -pe 's/__TINI_INSTALL_APP__/`cat install-app`/ge' -i "${dockerfile}"
      perl -pe 's/__TINI_INSTALL_DEPS__/`cat install-deps`/ge' -i "${dockerfile}"
      perl -pe 's/__TINI_CLEANUP_DEPS__/`cat cleanup-deps`/ge' -i "${dockerfile}"
      popd >/dev/null

      perl -n -e 'print if /\S/' -i "${dockerfile}"
    done
  done
done

popd >/dev/null
