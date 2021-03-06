# Pull base image.
FROM quay.io/eris/build
MAINTAINER Eris Industries <support@erisindustries.com>

#-----------------------------------------------------------------------------
# install epm

# set the repo and copy in files
ENV REPO $GOPATH/src/github.com/eris-ltd/eris-pm
COPY . $REPO

# install glide; use glide; remove its traces
WORKDIR $REPO
RUN go get github.com/Masterminds/glide && \
  glide install --strip-vcs --strip-vendor && \
  rm -rf $GOPATH/pkg/* && \
  rm -rf $GOPATH/bin/* && \
  rm -rf $GOPATH/src/github.com/Masterminds

# install eris-pm
RUN go install ./cmd/epm
RUN chown --recursive $USER:$USER $REPO

#-----------------------------------------------------------------------------
# root dir

# persist data, set user
RUN chown --recursive $USER:$USER /home/$USER
VOLUME /home/$USER/.eris
WORKDIR /home/$USER/.eris
USER $USER
CMD ["epm", "--chain", "chain:46657", "--sign", "keys:4767" ]
