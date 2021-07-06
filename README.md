# docker-ruby-node
Kyero ruby apps launcher :whale:


## Managing images 🖼

In order to deploy a image you should use a docker `buildx` command tool, which will allow you to deploy images
for multiple architectures. Because we're introducing new MacBooks with M1 processors we need to have images tailored
for those environments.

In order to do it, please use those commands from withing a root folder

- Build an image locally - `docker buildx build -t kyero/ruby-node:TAG_NAME --platform linux/amd64,linux/arm66 .`
- Build an image and push to DockerHub - `docker buildx build -t kyero/ruby-node:TAG_NAME --platform linux/amd64,linux/arm66 . --push`

If encounter an error saying `error: multiple platforms feature is currently not supported for docker driver. Please switch to a different driver (eg. "docker buildx create --use")`, please create a local builder
with a command `docker buildx create --use`. It will allow you to push to multiple platforms
