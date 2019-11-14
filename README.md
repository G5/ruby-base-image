## Ruby Base Image

[![Docker Hub](https://img.shields.io/badge/docker-ready-blue.svg)](https://hub.docker.com/r/g5search/ruby-base/)

The `g5search/ruby-base` Docker image descends from the official Ruby image. The parent image uses debian, and we install a number of universal (or nearly so) libraries that child images probably need.

## Versions

We maintain images for several versions of Ruby. Our versioning scheme is the Ruby major/minor version, followed by a semantic version starting at 1.0.0 for each Ruby version (e.g. `2.6-v1.0.0`, `2.6-v1.0.3`). 

> **Why not just tag your images with the Ruby version?** Most of our Docker image releases just bump Ruby versions as they come out, but occasionally we tag releases that only update other software (SSL certificates, Postgres drivers). If we had a Docker image tagged `2.6.3` when Ruby 2.6.3 came out, but then wanted to release a new image with an upgraded version of Node, what would we tag it? It can't be `2.6.4`, the Ruby version is still 2.6.3. Would we call it `2.6.4.1`? That's not valid semver. `2.6.4-v2` or something might work, but [the Semver spec says](https://semver.org/#backusnaur-form-grammar-for-valid-semver-versions) anything after `-` is for pre-release version, not a post-release version.

### Actively Maintained

  - `2.3-vX.X.X` Ruby 2.3 image series. Built from the `ruby23.dockerfile`, releases triggered when a git tag is created with the `2.3-vX.X.X` naming convention. Ruby 2.3 is no longer supported for security updates. This was originally chosen as our "legacy" Ruby version to support because it is relatively easy to upgrade to from 2.0 - 2.2. Ruby 2.4 introduces number changes that often require significant gem updates, which is often a hassle for older applications. 
  - `2.6-vX.X.X` Ruby 2.6 image series. Built from the `ruby26.dockerfile`, releases triggered when a git tag is created with the `2.6-vX.X.X` naming convention. As of this writing, this is the current version of Ruby.
  
### Retired

Retired images are still available for use, but we are no longer releasing new versions of the image when new Ruby versions are released. Upgrade to an actively maintained image variant.

  - `2.4-vX.X.X` This image series was retired from support by Devops in 2018 due to the preferred upgrade from 2.3 - 2.5.
  - `2.5-vX.X.X` This image series is retired from support by DevOps 10/2019.

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
