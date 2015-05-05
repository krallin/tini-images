FROM centos:6
RUN TINI_VERSION="v0.4.3" && \
    TINI_REAL_VERSION="0.4.3" && \
    TINI_BUILD="/tmp/tini" && \
    echo "Installing build dependencies" && \
    TINI_DEPS="gcc cmake make git rpm-build" && \
yum history new && \
yum install --assumeyes ${TINI_DEPS} && \
    echo "Building Tini" && \
    git clone https://github.com/krallin/tini.git "${TINI_BUILD}" && \
cd "${TINI_BUILD}" && \
git checkout "${TINI_VERSION}" && \
export SOURCE_DIR="${TINI_BUILD}" && \
export BUILD_DIR="${TINI_BUILD}" && \
"${TINI_BUILD}/ci/run_build.sh" && \
    echo "Installing Tini" && \
    yum install -y "${TINI_BUILD}/tini_${TINI_REAL_VERSION}.rpm" && \
    echo "Cleaning up" && \
    cd / && \
rm -rf "${TINI_BUILD}" && \
    yum --assumeyes history undo 1 && \
yum clean all && \
    echo "Symlinkng to /usr/local/bin/tini" && \
    ln -s /usr/bin/tini /usr/local/bin/tini && \
    echo "Running Smoke Test" && \
    /usr/bin/tini -- ls && \
    /usr/local/bin/tini -- ls && \
    echo "Done"
ENTRYPOINT ["/usr/bin/tini", "--"]
