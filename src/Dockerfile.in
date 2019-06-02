FROM __SOURCE_IMAGE__ AS builder

ENV TINI_VERSION="__TINI_VERSION__" TINI_REAL_VERSION="__TINI_REAL_VERSION__" TINI_BUILD="/tmp/tini"

RUN echo "Installing build dependencies" \
 && __TINI_INSTALL_DEPS__

RUN echo "Building Tini" \
 && __TINI_BUILD_APP__

RUN echo "Moving Tini" \
 && __TINI_MOVE_APP__

FROM __SOURCE_IMAGE__

COPY __TINI_COPY_APP__

RUN echo "Installing Tini" \
 && __TINI_INSTALL_APP__ \
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
