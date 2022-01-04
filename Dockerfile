FROM archlinux
LABEL maintainer="Kun.HK.Huang"

ARG BASE_PKGS="git sudo base base-devel zsh paru python3 python-pip nodejs npm"
RUN sed -i "s/#Para/Para/" /etc/pacman.conf \
&&  echo "[archlinuxcn]" >> /etc/pacman.conf \
&&  echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf \
&&  pacman-key --init \
&&  pacman-key --populate \
&&  pacman -Syy --noconfirm archlinuxcn-keyring reflector \
&&  iso=$(curl -4 ifconfig.co/country-iso) \
&&  reflector --age 6 --latest 20 --fastest 20 --threads 20 --sort rate --protocol https -c ${iso} --save ${PWD}/mirrorlist \
&&  pacman -Syyu --needed --noconfirm ${BASE_PKGS} \
&&  useradd -m dev \
&&  echo "dev ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER dev

ARG NEOVIM_PKGS="neovim ripgrep fzf clang prettier jq shfmt gitui lazygit"
RUN paru -Syu --skipreview --noconfirm ${NEOVIM_PKGS}
RUN pip install wheel --user \
&&  pip install neovim autopep8 yapf --user \
&&  sudo npm install -g neovim

ADD nvim/.config/nvim /home/dev/.config/nvim
