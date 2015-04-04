FROM ubuntu:precise
RUN TINI_VERSION="c5a49cf" && \
    TINI_BUILD="/tmp/tini" && \
    echo "Installing build dependencies" && \
    TINI_DEPS="build-essential cmake git" && \
apt-get update && \
apt-get install --yes ${TINI_DEPS} && \
    echo "Building Tini" && \
    git clone https://github.com/krallin/tini.git "${TINI_BUILD}" && \
cd "${TINI_BUILD}" && \
git checkout "${TINI_VERSION}" && \
cmake . && \
make && \
    echo "Installing Tini" && \
    cd "${TINI_BUILD}" && \
make install && \
    echo "Cleaning up" && \
    cd / && \
rm -rf "${TINI_BUILD}" && \
    apt-get purge --yes ${TINI_DEPS} && \
apt-get autoremove --yes && \
rm -rf /var/lib/apt/lists/* && \
    echo "Running Smoke Test" && \
    /usr/local/bin/tini -- ls && \
    echo "Done"
ENTRYPOINT ["/usr/local/bin/tini", "--"]
