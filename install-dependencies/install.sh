#!/usr/bin/env bash
echo "Current PATH: $PATH"
mkdir -p ~/.terraform/bin
cd ~/.terraform/bin

function export_path() {
  export PATH="$PATH:$PWD"
}

export_path
echo "PATH with PWD: $PATH"

# Install AWS CLI
EXISTS=`which aws`
if [[ $? -ne 0 ]]; then
  curl -LO https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
  unzip ./awscli-bundle.zip
  ./awscli-bundle/install -i $PWD

  ln -s "$PWD/bin/aws" "$PWD/aws"
  aws --version
else
  echo 'AWS CLI já está instalado'
fi

# Install AWS SSM
EXISTS=`which session-manager-plugin`
if [[ $? -ne 0 ]]; then
  SSM_DOWNLOAD_URL="https://s3.amazonaws.com/session-manager-downloads/plugin/latest"
  ARCH='32bit'
  MACHINE_TYPE=`uname -m`
  if [ "${MACHINE_TYPE}" == 'x86_64' ]; then
    ARCH='64bit'
  fi

  if command -v dpkg >/dev/null; then
    curl -LO "$SSM_DOWNLOAD_URL/ubuntu_$ARCH/session-manager-plugin.deb"
    # Instalação local pois não há permissão de sudo na máquina
    dpkg -x session-manager-plugin.deb ssm
  else
    # Processo de instalação do Session Manager Plugin no RHEL/CentOS
    curl -LO "$SSM_DOWNLOAD_URL/linux_$ARCH/session-manager-plugin.rpm"
    # Instalação local pois não há permissão de sudo na máquina
    mkdir -p ssm
    (cd ssm && rpm2cpio ../session-manager-plugin.rpm | cpio -idv)
  fi

  ln -s "$PWD/ssm/usr/local/sessionmanagerplugin/bin/session-manager-plugin" session-manager-plugin

  session-manager-plugin
else
  echo 'Session Manager Plugin já está instalado'
fi
