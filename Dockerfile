FROM docker.io/library/ubuntu:24.04
RUN apt-get update -y && \
  apt-get install --no-install-recommends -y \
  bc=1.07.1-3ubuntu4 \
  curl=8.5.0-2ubuntu10.5 \
  poppler-utils=24.02.0-1ubuntu9.1 && \
  apt-get autoremove -y && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
