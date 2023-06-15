# Check out Docker at: https://www.docker.com/

# NOTE: THIS IMAGE IS INTENDED FOR DEVELOPMENT PURPOSES ONLY

FROM alpine:3.18.2

RUN apk add --no-cache \
	bash curl git jq make python3 py3-pip

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.1 \
	&& echo '. "$HOME/.asdf/asdf.sh"' > ~/.bashrc \
	&& . "$HOME/.asdf/asdf.sh" \
	&& asdf plugin add actionlint \
	&& asdf plugin add hadolint \
	&& asdf plugin add shellcheck \
	&& asdf plugin add shfmt \
	&& asdf plugin add yamllint

ENTRYPOINT ["/bin/bash"]
