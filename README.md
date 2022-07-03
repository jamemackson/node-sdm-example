## example node + sdm running in a docker image

build: ` docker build -f ./Dockerfile -t node-sdm:local .`
run: `docker run -it --env SDM_ADMIN_TOKEN=$SDM_ADMIN_TOKEN --env DATABASE_URL=postgres://foo@bar@127.0.0.1:15432/upsie_dev node-sdm:local /bin/bash`

see package.json scripts.
