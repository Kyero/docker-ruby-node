FROM ruby:2.6.3

LABEL maintainer "Kyero <dev@kyero.com>"

# Explicitely define locale
# as advised in https://github.com/docker-library/docs/blob/master/ruby/content.md#encoding
ENV LANG="C.UTF-8"

# Define some default variables
ENV PORT="5000" \
    BUNDLE_PATH="/bundle" \
    BUNDLE_BIN="/bundle/bin" \
    BUNDLE_APP_CONFIG="/bundle" \
    PATH="/app/bin:/bundle/bin:${PATH}" \
    HISTFILE="/config/.bash_history" \
    GIT_COMMITTER_NAME="Just some fake name to be able to git-clone" \
    GIT_COMMITTER_EMAIL="whatever@this-user-is-not-supposed-to-git-push.anyway"

# Install APT dependencies
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests \
      g++ build-essential \
      postgresql-client-9.6 \
      nano \
      vim \
      less \
 && rm -rf /var/lib/apt/lists/*

 # Install node
 
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 10.15.3
RUN curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

RUN npm install -g yarn@1.15.2

# Install GEM dependencies
RUN gem update --system 3.0.2 \
 && gem install \
      bundler:2.0.2 \
      foreman:0.84.0

# Persist IRB/Pry/Rails console history
ADD .irbrc .pryrc /root/

# Configure the main working directory.
WORKDIR /app

# Expose listening port to the Docker host, so we can access it from the outside.
EXPOSE ${PORT}

# Use a bundle wrapper as entrypoint which runs `bundle install` if necessary.
COPY bundler-wrapper /usr/local/bin/
COPY yarn-wrapper /usr/local/bin/
ENTRYPOINT ["bundler-wrapper", "yarn-wrapper"]

# The main command to run when the container starts.
CMD ["foreman", "start"]
