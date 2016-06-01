## Ruby Base Image

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/g5search/ruby-base/)

The `g5search/ruby-base` Docker image descends from the official Ruby image. The parent image uses debian, and we install a number of universal (or nearly so) libraries that child images probably need.

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
