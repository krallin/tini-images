FROM centos:6
RUN TINI_VERSION="v0.3.4" && \
    TINI_BUILD="/tmp/tini" && \
    echo "Installing build dependencies" && \
    TINI_DEPS="gcc cmake make git" && \
yum history new && \
yum install --assumeyes ${TINI_DEPS} && \
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
    yum --assumeyes history undo 1 && \
yum clean all && \
    echo "Running Smoke Test" && \
    /usr/local/bin/tini -- ls && \
    echo "Done"
ENTRYPOINT ["/usr/local/bin/tini", "--"]
