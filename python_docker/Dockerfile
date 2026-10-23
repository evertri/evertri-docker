ARG PYTHON_VERSION=3.12
ARG PYTHON_VARIANT=bullseye
FROM python:${PYTHON_VERSION}-${PYTHON_VARIANT}

RUN python -m pip install --no-cache-dir \
    "https://files.pythonhosted.org/packages/3f/06/3e4420302363fbb71be3c7f35ce042f54bfca330e3e66b3a2e3c4cca579f/pip-26.2.2-py3-none-any.whl#sha256=fd7f4dfa8190e014013b9f08f3e973f4e4c26ffd179a204895533a7254813a70"

LABEL org.opencontainers.image.source="https://github.com/evertri/evertri-docker"

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        awscli \
        jq \
        libreoffice-writer \
        fonts-noto-cjk \
    && rm -rf /var/lib/apt/lists/*
