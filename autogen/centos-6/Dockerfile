FROM centos:6 AS builder
ENV TINI_VERSION="v0.18.0" TINI_REAL_VERSION="0.18.0" TINI_BUILD="/tmp/tini"
RUN echo "Installing build dependencies" \
 && TINI_DEPS="gcc cmake make git rpm-build glibc-static curl tar libcap-devel python-devel" && \
yum history new || \
yum history new && \
mv /sbin/weak-modules /sbin/weak-modules.tmp && \
yum install --assumeyes ${TINI_DEPS}
RUN echo "Building Tini" \
 && 	git clone https://github.com/krallin/tini.git "${TINI_BUILD}" && \
	cd "${TINI_BUILD}" && \
	curl -fsSLO https://pypi.python.org/packages/source/v/virtualenv/virtualenv-13.1.2.tar.gz && \
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
	"${TINI_BUILD}/ci/run_build.sh"
RUN echo "Moving Tini" \
 && mv "${TINI_BUILD}/tini_${TINI_REAL_VERSION}.rpm" /tmp/tini_release.rpm
FROM centos:6
COPY --from=builder /tmp/tini_release.rpm /tmp
RUN echo "Installing Tini" \
 && yum install -y /tmp/tini_release.rpm \
 && echo "Symlinkng to /usr/local/bin" \
 && ln -s /usr/bin/tini        /usr/local/bin/tini \
 && ln -s /usr/bin/tini-static /usr/local/bin/tini-static \
 && echo "Running Smoke Test" \
 && /usr/bin/tini -- ls >/dev/null \
 && /usr/bin/tini-static -- ls >/dev/null \
 && /usr/local/bin/tini -- ls >/dev/null \
 && /usr/local/bin/tini-static -- ls >/dev/null \
 && echo "Done"
ENTRYPOINT ["/usr/bin/tini", "--"]
