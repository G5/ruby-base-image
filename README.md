## Ruby Base Image

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/g5search/ruby-base/)

The `g5search/ruby-base` Docker image descends from the official Ruby image. The parent image uses debian, and we install a number of universal (or nearly so) libraries that child images probably need.

### Versions

We maintain images for a couple of Ruby versions. Versions are delineated via tags:

  - `2.3-vX.X.X` Ruby 2.3 image series. Built from the `ruby23.dockerfile`, releases triggered when a git tag is created with the `2.3-vX.X.X` naming convention. Ruby 2.3 will be updated for security until March 2019. This was chosen as our "legacy" Ruby version to support because it is relatively easy to upgrade to from 2.0 - 2.2. Ruby 2.4 introduces number changes that often require significant gem updates, which is often a hassle for older applications.
  - `2.4-vX.X.X` Ruby 2.4 image series. Built from the `ruby24.dockerfile`, releases triggered when a git tag is created with the `2.4-vX.X.X` naming convention. Ruby 2.4 is only in security maintenance phase and will EOL March 2020. It is recommended to move to a higher version.
  - `2.5-vX.X.X` This image series is retired from support by DevOps 10/2019.
  - `2.6-vX.X.X` Ruby 2.6 image series. Built from the `ruby26.dockerfile`, releases triggered when a git tag is created with the `2.6-vX.X.X` naming convention. As of this writing, this is the current version of Ruby.
  - `2.7-vX.X.X` Ruby 2.7 is not ready yet, it is in preview as of 10/2019.

## Releases

The Docker Hub builds images via automated builds, and respects Semantic Version (with our Ruby version prefix). As an example, you can create a `2.6-v2.0.0-beta.1` image if you want to create a beta base image to test upcoming changes.

Create a GitHub release with information about any changes you've made. The semver of the different tags are independent of each other and unrelated. If we have `2.6-v1.20.0` when Ruby 2.7 comes out, the first version of that new image should be `2.7-v1.0.0`. There is significant duplication between the Dockerfiles, so ensure you've considered all maintained versions when you make updates to any of the Dockerfiles.

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
