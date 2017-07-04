FROM kyero/ruby

LABEL maintainer "Michael Baudino <michael.baudino@alpine-lab.com>"

# Install node from NodeSource (as advised in https://nodejs.org/en/download/package-manager/)
# and yarn from the official repository
RUN sed -i 's/^deb-src/# deb-src/' /etc/apt/sources.list \
 && apt-get update \
 && apt-get install -y curl apt-transport-https \
 && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
 && echo 'deb https://deb.nodesource.com/node_7.x jessie main' > /etc/apt/sources.list.d/nodesource.list \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      nodejs \
      yarn \
      libfontconfig \
 && rm -rf /var/lib/apt/lists/*

# Install PhantomJS from Codeship (S3-hosted) packages
ARG PHANTOMJS_VERSION="2.1.1"
ARG PHANTOMJS_HOST="https://s3.amazonaws.com/codeship-packages"
RUN curl -sSL "${PHANTOMJS_HOST}/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2" \
  | tar -xvj --strip-components=2 --directory=/usr/local/bin/ "phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs"

# Use a yarn wrapper as entrypoint.
# It runs `yarn install` if necessary.
COPY yarn-wrapper /usr/local/bin/
ENTRYPOINT ["bundler-wrapper", "yarn-wrapper"]
CMD ["foreman", "start"]
