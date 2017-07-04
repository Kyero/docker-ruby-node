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
      xvfb xauth qt5-default libqt5webkit5-dev gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x \
 && rm -rf /var/lib/apt/lists/*

# Use a bundle wrapper as entrypoint.
# It runs `bundle install` if necessary.
COPY yarn-wrapper /usr/local/bin/
ENTRYPOINT ["bundler-wrapper", "yarn-wrapper"]
