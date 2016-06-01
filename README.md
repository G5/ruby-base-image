## Ruby Base Image

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/g5search/ruby-base/)

The `g5search/ruby-base` Docker image descends from the official Ruby image. The parent image uses debian, and we install a number of universal (or nearly so) libraries that child images probably need.

### Releases

This image uses Docker Hub automated builds and is integrated with GitHub. Create a release in GitHub using a semantic versioning tag like `v1.2.3` and Docker will build the image for you, tagging it identically in Docker as it was tagged in git. It will respect pre-release tags like `v1.2.3-beta.1` if you are wary of releasing your image into the wild.

### Gemfury Token

If your child image needs to install gems from Gemfury, you should provide it as a build argument. Unfortunately, these are not inherited from parent images and so cannot be specified there. Here's how to do it:

Do like so in the `Dockerfile`:

```
ARG gemfury_token
RUN FURY_AUTH=$gemfury_token bundle install
```

and pass it to the build command via:

```bash
docker build --build-arg gemfury_token="yourtoken" .
```
