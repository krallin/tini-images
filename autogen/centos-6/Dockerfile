FROM centos:6
RUN TINI_VERSION="v0.8.2" && \
    TINI_REAL_VERSION="0.8.2" && \
    TINI_BUILD="/tmp/tini" && \
    echo "Installing build dependencies" && \
    TINI_DEPS="gcc cmake make git rpm-build glibc-static curl tar libcap-devel python-devel" && \
yum history new || \
yum history new && \
yum install --assumeyes ${TINI_DEPS} && \
    echo "Building Tini" && \
    git clone https://github.com/krallin/tini.git "${TINI_BUILD}" && \
cd "${TINI_BUILD}" && \
curl -O https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz && \
tar -xf virtualenv-13.1.2.tar.gz && \
mv virtualenv-13.1.2/virtualenv.py virtualenv-13.1.2/virtualenv && \
export PATH="${TINI_BUILD}/virtualenv-13.1.2:${PATH}" && \
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
    echo "Symlinkng to /usr/local/bin" && \
    ln -s /usr/bin/tini        /usr/local/bin/tini && \
    ln -s /usr/bin/tini-static /usr/local/bin/tini-static && \
    echo "Running Smoke Test" && \
    /usr/bin/tini -- ls && \
    /usr/bin/tini-static -- ls && \
    /usr/local/bin/tini -- ls && \
    /usr/local/bin/tini-static -- ls && \
    echo "Done"
ENTRYPOINT ["/usr/bin/tini", "--"]
