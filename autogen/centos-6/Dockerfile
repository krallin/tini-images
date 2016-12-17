FROM centos:6
RUN TINI_VERSION="v0.13.2" && \
    TINI_REAL_VERSION="0.13.2" && \
    TINI_BUILD="/tmp/tini" && \
    echo "Installing build dependencies" && \
    TINI_DEPS="gcc cmake make git rpm-build glibc-static curl tar libcap-devel python-devel" && \
yum history new || \
yum history new && \
mv /sbin/weak-modules /sbin/weak-modules.tmp && \
yum install --assumeyes ${TINI_DEPS} && \
    echo "Building Tini" && \
    git clone https://github.com/krallin/tini.git "${TINI_BUILD}" && \
cd "${TINI_BUILD}" && \
curl -O https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz && \
tar -xf virtualenv-13.1.2.tar.gz && \
mv virtualenv-13.1.2/virtualenv.py virtualenv-13.1.2/virtualenv && \
export PATH="${TINI_BUILD}/virtualenv-13.1.2:${PATH}" && \
HARDENING_CHECK_PLACEHOLDER="${TINI_BUILD}/hardening-check/hardening-check" && \
HARDENING_CHECK_PLACEHOLDER_DIR="$(dirname "${HARDENING_CHECK_PLACEHOLDER}")" && \
mkdir "${HARDENING_CHECK_PLACEHOLDER_DIR}" && \
echo  "#/bin/sh" > "${HARDENING_CHECK_PLACEHOLDER}" && \
chmod +x "${HARDENING_CHECK_PLACEHOLDER}" && \
export PATH="${PATH}:${HARDENING_CHECK_PLACEHOLDER_DIR}" && \
git checkout "${TINI_VERSION}" && \
export SOURCE_DIR="${TINI_BUILD}" && \
export BUILD_DIR="${TINI_BUILD}" && \
export ARCH_NATIVE=1 && \
"${TINI_BUILD}/ci/run_build.sh" && \
    echo "Installing Tini" && \
    yum install -y "${TINI_BUILD}/tini_${TINI_REAL_VERSION}.rpm" && \
    echo "Cleaning up" && \
    cd / && \
rm -rf "${TINI_BUILD}" && \
    yum --assumeyes history undo 1 && \
yum clean all && \
mv /sbin/weak-modules.tmp /sbin/weak-modules && \
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
