# Package List for Ubuntu Server Workstation


## Table of Contents
* [Getting Explicitly Installed Packages](#getting-explicitly-installed-packages) 
* [Basic Tools](#basic-tools) 
* [Programming](#programming) 
    * [Packages needed for compiling Vim from source](#packages-needed-for-compiling-vim-from-source) 
* [Other Packages](#other-packages) 
* [Basic Package Installation](#basic-package-installation) 
* [Building GNU Screen from Source](#building-gnu-screen-from-source) 
* [Installing Other Packages](#installing-other-packages) 
* [Package Install Script](#package-install-script) 


## Getting Explicitly Installed Packages
```bash
sudo apt-mark showmanual
```
"Bootstrapping" script at the bottom.

## Basic Tools
* `stow` - dotfile management
* `gcc`
* `unzip`
* `tree`
* `entr`
* `w3m`
* `lolcat`
* `lynx`
* `tmux`
* `screen` (build from source for 256 color support)
* `tldr`
* `fzf`
* `shfmt`
* `netstat`
* `ncal` - calendar
* `nodejs`
* `npm`
* `xterm`
* `visidata`
* `youtube-dl`
* `cmatrix`
* `net-tools`
* `network-manager` (nmcli)
* `nmap`
* `sysstat` - system tools
* `whois` - also contains mkpasswd
* `nfs-common` - nfs tools. has `showmount`
* `weechat` 
* `mdadm` - managing software RAID
* `ansible`
* `iperf3` - network throughput testing tool

## Programming
* `jq` (jquery - install )
* `python3.10-venv`
* `python3-pip`
* `pyright` (use npm - `sudo npm install -g pyright`)
* `gopls`

### Packages needed for compiling Vim from source:  
The default installation of Vim doesn't have Python3 support, at least on Ubuntu Server.  
In addition, the latest available version from 'apt' is 8.2, so that's another reason to
[build Vim from Source](https://github.com/vim/vim/blob/master/src/INSTALL).  
(Also see `~/notes/vim_nvim/build_from_source.md`)  
* `clang`
* `libtool-bin` 
* `libpython3-dev` (python support)
* `libxt-dev` (clipboard support)
* `valgrind` (debugging support)

```bash
sudo apt-get update && sudo apt-get install -y \
    git \
    make \
    clang \
    libtool-bin \
    libxt-dev \
    libpython3-dev \
    libgtk-3-dev \
    libxt-dev
```


## Other Packages
*These are package either unavailable, not up-to-date on`apt`, or have extra requirements.*
* nvim (latest neovim - see below)
* nvm (node version manager - see below)
* mods (charmbracelet/mods - see below)
* golang1.21+ (use install script)
* libssl1.1 (use install script) >>> For Cody (sg.nvim)
    * NOTE: The install script is for amd64 compatible systems; 
      you'll need to install the ARM package if you're on an ARM system (ARM Mac or a RasbperyPi: 
      (`http://ports.ubuntu.com/pool/main/o/openssl/libssl1.1_1.1.1f-1ubuntu2_arm64.deb`)
* cargo (rust)
    * `curl -fsSL https://sh.rustup.rs | sh`

## Basic Package Installation
```bash
#!/bin/bash

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install -y \
    stow \
    gcc \
    unzip \
    tree \
    entr \
    w3m \
    lolcat \
    lynx \
    tmux \
    screen \
    tldr \
    fzf \
    shfmt \
    ncal \
    nodejs \
    npm \
    xterm \
    visidata \
    python3.10-venv \
    python3-pip \
    gopls \
    clang \
    libtool-bin \
    libpython3-dev \
    net-tools \
    network-manager \
    whois 

sudo npm install -g pyright
```


## Building GNU Screen from Source
```bash
curl -O https://ftp.gnu.org/gnu/screen/screen-4.9.1.tar.gz
tar -zxvf screen-4.9.1.tar.gz
cd screen-4.9.1
sh autogen.sh &&
    ./configure --prefix=/usr \
        --enable-colors256 \
        --infodir=/usr/share/info \
        --mandir=/usr/share/man \
        --with-socket-dir=/run/screen \
        --with-pty-group=5 \
        --with-sys-screenrc=/etc/screenrc &&
    sed -i -e "s%/usr/local/etc/screenrc%/etc/screenrc%" {etc,doc}/* &&
    make && 
    sudo make install 
```


## Installing Other Packages 
Installation of packages either out-of-date or unavailable via `apt`: 

* `charmbracelet/mods`
```bash
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt-get update && sudo apt-get install mods
```


* `nvm` (Node Version Manager)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash )
nvm install node
```


* `nvim`
```bash
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt update && sudo apt-get install neovim -y
# Download packer.nvim:
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

* `vault`
```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install vault
```

## Package Install Script
```bash
#!/bin/bash

sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo apt-get update && sudo apt-get upgrade -y

PACKAGES=(
    "stow"
    "gcc"
    "unzip"
    "tree"
    "entr"
    "w3m"
    "lolcat"
    "lynx"
    "tmux"
    "screen"
    "tldr"
    "fzf"
    "shfmt"
    "ncal"
    "nodejs"
    "npm"
    "xterm"
    "visidata"
    "python3.10-venv"
    "python3-pip"
    "gopls"
    "clang"
    "libtool-bin"
    "libpython3-dev"
    "net-tools"
    "network-manager"
    "whois"
    "neovim"
    "nmap"
    "sysstat"
    "weechat"
    "nfs-common"
    "mdadm"
    "ansible"
    "jq"
    "iperf3"
    "podman"
    "youtube-dl"
    "software-properties-common"
)

sudo apt-get install -y "${PACKAGES[@]}"

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash 
nvm install node
sudo npm install -g pyright
```

