FROM archlinux

LABEL maintainer="hk451284087@gmail.com" \
      url.github="https://github.com/G0Lotus/dotfile"

ENV UID="1000" \
    GID="1000" \
    UNAME="user" \
    GNAME="user" \
    SHELL="/bin/zsh" \
    WORKSPACE="/mnt/workspace" \
    PATH="/home/user/.local/bin:${PATH}"

# Base Env
ARG BASE_PKGS="git sudo base base-devel tig tmux zsh paru"
RUN sed -i "33a ParallelDownloads = 5" /etc/pacman.conf \
&&  echo "[archlinuxcn]" >> /etc/pacman.conf \
&&  echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf \
&&  pacman-key --init \
&&  pacman-key --populate \
&&  iso=$(curl -4 ifconfig.co/country-iso) \
&&  curl "https://archlinux.org/mirrorlist/?country=${iso}&protocol=http&protocol=https&ip_version=4" -o /etc/pacman.d/mirrorlist\
&&  sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist\
&&  pacman -Sy --noconfirm archlinuxcn-keyring reflector \
&&  reflector --age 6 --latest 20 --fastest 20 --threads 20 --sort rate --protocol https -c ${iso} --save ${PWD}/mirrorlist \
&&  pacman -Syyu --needed --noconfirm ${BASE_PKGS} \
&&  groupadd "${GNAME}" \
&&  useradd -m -g "${GNAME}" -s "${SHELL}" "${UNAME}" \
&&  echo "${UNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER ${UNAME}

# Config packages
COPY --chown=user:user cli_packages /home/user/.dotfile/cli_packages
WORKDIR /home/user
RUN cd .dotfile \
&&  paru -S --skipreview --noconfirm stow su-exec starship \
&&  stow cli_packages \
&&  cd \
&&  exec zsh

# Neovim Env
ARG NEOVIM_PKGS="neovim ripgrep fzf clang prettier jq shfmt gitui lazygit"
RUN paru -Syu --skipreview --noconfirm ${NEOVIM_PKGS}

# Python Env
RUN paru -S --skipreview --noconfirm python3 python-pip \
&&  pip install wheel --user \
&&  pip install neovim autopep8 yapf fire --user

# nodejs Env
RUN paru -S --skipreview --noconfirm nodejs npm \
&&  sudo npm install -g neovim

# Remove cache
RUN yes | paru -Sccc \
&&  rm -rf "${HOME}/.cache/paru"

COPY --chown=user:user entrypoint.sh /usr/local/bin
ENTRYPOINT ["sh", "/usr/local/bin/entrypoint.sh"]
