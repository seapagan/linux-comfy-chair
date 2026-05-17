FROM ubuntu:24.04

ARG USERNAME=comfy
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV HOME=/home/${USERNAME}

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    bash \
    ca-certificates \
    curl \
    dialog \
    git \
    gnupg \
    less \
    locales \
    lsb-release \
    nano \
    procps \
    sudo \
    wget \
    zsh \
  && rm -rf /var/lib/apt/lists/*

RUN existing_group="$(getent group "${USER_GID}" | cut -d: -f1 || true)" \
  && if [ -z "$existing_group" ]; then groupadd --gid "${USER_GID}" "${USERNAME}"; fi \
  && existing_user="$(getent passwd "${USER_UID}" | cut -d: -f1 || true)" \
  && if [ -n "$existing_user" ] && [ "$existing_user" != "$USERNAME" ]; then usermod --login "${USERNAME}" --home "/home/${USERNAME}" --move-home "$existing_user"; fi \
  && if getent passwd "${USERNAME}" >/dev/null; then usermod --gid "${USER_GID}" --shell /bin/bash "${USERNAME}"; else useradd --uid "${USER_UID}" --gid "${USER_GID}" --create-home --shell /bin/bash "${USERNAME}"; fi \
  && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" \
  && chmod 0440 "/etc/sudoers.d/${USERNAME}" \
  && mkdir -p "/home/${USERNAME}/comfy-chair" \
  && printf '%s\n' 'echo "Exiting container; Docker is removing the disposable test environment..."' > "/home/${USERNAME}/.bash_logout" \
  && printf '%s\n' 'echo "Exiting container; Docker is removing the disposable test environment..."' > "/home/${USERNAME}/.zlogout" \
  && chown -R "${USER_UID}:${USER_GID}" "/home/${USERNAME}"

COPY support/docker-entrypoint.sh /usr/local/bin/comfy-docker-entrypoint
RUN chmod 0755 /usr/local/bin/comfy-docker-entrypoint

USER "${USERNAME}"
WORKDIR "/home/${USERNAME}/comfy-chair"

ENTRYPOINT ["/usr/local/bin/comfy-docker-entrypoint"]
