FROM fedora:latest

LABEL maintainer "hello@ifnot.cc"

ENV TERM xterm

RUN dnf -y update \
  && dnf -y install openssh-server passwd openssh-clients \
  vim neovim cloc nmap-ncat htop tree iproute net-tools iputils pciutils  util-linux util-linux-user wget zsh aria2 \
  git cmake ninja-build python python-pip ruby lua nasm yasm \
  nodejs npm go rust \
  libaio libzip lbzip2 \
  java-1.8.0-openjdk-devel.x86_64 \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
  && dnf clean all

RUN /usr/bin/ssh-keygen -A \
  && sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
  && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
  && sed -ri 's/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g' /etc/ssh/sshd_config \
  && echo 'root:root' | chpasswd

VOLUME ["/codes"]
VOLUME ["/data"]

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
