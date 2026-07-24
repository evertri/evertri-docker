ARG PYTHON_VERSION=3.12
ARG PYTHON_VARIANT=bullseye
FROM python:${PYTHON_VERSION}-${PYTHON_VARIANT}

LABEL org.opencontainers.image.source="https://github.com/evertri/evertri-docker"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libreoffice-writer \
        fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*
