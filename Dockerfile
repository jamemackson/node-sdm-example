FROM node:14.19.3-bullseye

# Create app directory
WORKDIR /usr/src

# install SDM client
ENV SDM_HOME=/home/sdm/.sdm
ENV SDM_DOCKERIZED=true
# ENV SDM_ADMIN_TOKEN=
RUN adduser --uid 9001 --ingroup root --disabled-password --gecos "" sdm \
  && apt-get update \
  # Install build and runtime dependencies
  && apt-get install --no-install-recommends -y \
  curl \
  unzip \
  psmisc \
  ca-certificates \
  # Download SDM binary
  && curl -J -O -L https://app.strongdm.com/releases/cli/linux-static/latest \
  # Unzip it
  && unzip sdmcli* \
  # Install it
  && ./sdm install --user sdm --nologin \
  # Remove no longer needed build dependencies
  && apt-get remove -y \
  curl \
  unzip \
  ca-certificates \
  # Delete the zip file
  && rm sdmcli* \
  # Clean up APT
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists/*

# Bundle app source
COPY ./package.json .
COPY ./yarn.lock .
COPY ./index.js .
COPY ./start-sdm.sh .

# Install app dependencies
RUN yarn install --frozen-lockfile

ENV PORT=8080
EXPOSE ${PORT}
CMD [ "node", "index.js" ]

