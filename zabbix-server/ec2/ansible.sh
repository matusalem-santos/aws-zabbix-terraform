#!/usr/bin/env bash

export PATH="$PATH:$HOME/.terraform/bin"

# Esperar a Maquina ser provisionada caso o Banco seja Local
if [ "$ZBX_DB_DNS" == "localhost" ]
then
    sleep 180
fi

# Instalar PIP e Ansible 2.10.1 através do PIP
curl 'https://bootstrap.pypa.io/pip/2.7/get-pip.py' --output 'get-pip.py'
python ./get-pip.py --user
export "PATH=$PATH:$HOME/.local/bin"
pip install jmespath
pip install --user ansible==2.10.0

# Iniciar ssh-agent para adicionar a chave privada
eval `ssh-agent -s`
echo "$PRIVATE_SSH_KEY" | ssh-add -

# Verificar se valor das variaveis estão corretos
echo "$ANSIBLE_DIR"
echo "$ZBX_DB_DNS"
echo "$ZBX_DB_PASS"

# Executar ansible via SSM
cd "$ANSIBLE_DIR"
pwd
ansible-playbook -i "$EC2_ZABBIX_ID," playbook.yml --extra-vars "pass_admin=$PASS_ADMIN zabbix_version=$ZABBIX_VERSION zbx_db_pass=$ZBX_DB_PASS zbx_db_url=$ZBX_DB_DNS ansible_user=$SSH_USER

# Matar SSH Agent para não travar o processo do Terraform Cloud
SSHAGENT=`which ssh-agent`
SSHAGENTARGS="-s"
if [ -z "$SSH_AUTH_SOCK" -a -x "$SSHAGENT" ]; then
    eval `$SSHAGENT $SSHAGENTARGS`
    trap "kill $SSH_AGENT_PID" 0
fi
if [ ${SSH_AGENT_PID+1} == 1 ]; then
    ssh-add -D
    ssh-agent -k > /dev/null 2>&1
    unset SSH_AGENT_PID
    unset SSH_AUTH_SOCK
fi