# AWS Zabbix Terraform


## Objetivo

- Provisionar Zabbix via Terraform na AWS

## Descrição

- Será possivel provisionar o Zabbix com banco MySQL local ou AuroraSQL no serviço de RDS da AWS.

## Modo de Usar

Para o provisionamento do Zabbix é necessário seguir os passos abaixo:

- Faça um fork desse projeto para ter uma maior autonomia

### Passo 1 - Criar Workspace no Terraform Cloud

##### A criação de um novo Workspace é necessária porque o state do terraform do novo Zabbix ficara atrelado a esse novo Workspace criado no Terraform Cloud

- Acessar o Terraform Cloud através do link: [Terraform Cloud](https://app.terraform.io/app/)

#### Como criar um novo Workspace

- Clicar em **New workspace**
 <img src="http://i.imgur.com/Rpu8ne9.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

- Clicar em **Version control workflow**
 <img src="http://i.imgur.com/GerSRWu.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />
     
- Realize a conexão com o VCS que está armazenado o seu repositório 

- Escolha o repositório que é o fork desse reporitório

- Definir o nome do Workspace com o nome do ambiente do zabbix e clicar em **Create workspace**

### Passo 2 - Adicionar variáveis no workspace

Antes de executar o terraform é necessario definir algumas variáveis para se obter as informações necessárias para o provisionamento do Zabbix no ambiente da AWS

- Clicar em **Variables**
 <img src="http://i.imgur.com/bPhF86e.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

#### Variáveis

| Nome | Descrição | Padrão | Obrigatória | 
|------|-----------|--------|:-----------:|
|AWS_DEFAULT_REGION|Região onde os recursos serão provisionados|Vazio|Sim|
|AWS_SECRET_ACCESS_KEY|Secret key da conta que sera provisionado o ambiente|Vazio|Sim|
|AWS_ACCESS_KEY_ID|Access key da conta que sera provisionado o ambiente|Vazio|Sim|
|workspace|Workspace no Terraform Cloud criado no **Passo 1**|Vazio|Sim|
|vpc_id|VPC onde sera realizado o provisionamento da stack de monitoramento|Vazio|Sim|
|vpc_cidr_block|Cidr block da VPC onde o recurso será provisionado|Vazio|Sim|
|ec2_subnet_id|ID da Subnet onde a instancia sera provisionada|Vazio|Sim|
|elastic_ip|Instância ser provisionada com Elastic IP|true|Não|
|instalar_zabbix|Definir se deve instalar o zabbix server na maquina|true|Não|
|zabbix_version|Definir a versão do zabbix server disponível [**4.4** ou **5.0**]|4.4|Não|
|ec2_zabbix_name|Nome da maquina do Zabbix Server|Zabbix Server|Não|
|zabbix_ebs_size|Tamanho do disco EBS para a maquina do Zabbix em **GB**|50|Não|
|pass_admin|Senha do usuario Admin|Vazio|Sim|
|zbx_db_pass|Senha do Banco do zabbix seja local ou por RDS (**NÃO USAR CARACTERES ESPECIAIS**)|Vazio|Sim|
|hosted_name|Nome para o Hosted Zone provisionado|monitoramento.vpc|Não|
|instance_type|Tipo da instancia que sera provisionada|t3.medium|Não|
|instance_ami|Definir a ami da instancia|ami-02eac2c0129f6376b|Não|
|ssh_user|User para conectar na instância via SSH|centos|Não|
|rds|Variavel que define se o banco do zabbix vai ser no RDS|false|Não|
|rds_engine|Definir se o engine do RDS vai ser **aurora** ou **mysql** |Vazio|Apenas se rds for igual a **true**|
|rds_subnets|ID das Subnets onde o rds sera provisionado, mínimo 3 subnets|Vazio|Apenas se rds for igual a **true**|
|rds_instance_type|Tipo da instancia para o rds que sera provisionada|db.t2.medium|Não|
|rds_multi_az|Definir se o RDS com engine **mysql** vai ser MultiAZ|false|Não|
|rds_allocated_storage|Definir o tamanho do storage do RDS com engine **mysql**|50|Não|
|ansible_manual_zabbix|Forçar a execução do ansible zabbix|Vazio|Não|

- Exemplo de definição de variáveis para um Zabbix sem RDS
 <img src="http://i.imgur.com/gTqV5CC.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

- Exemplo de definição de variáveis para um Zabbix com RDS 
 <img src="http://i.imgur.com/8C3KjSG.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

#### Observações 

- Na variável **AWS_SECRET_ACCESS_KEY** assinalar **Sensitive**
 <img src="http://i.imgur.com/ZnFEU9F.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

- Usar credenciais de um usuário no IAM que tenha permissão de Administrador 

- A variável **workspace** deve ser definida com o nome do novo workspace craido no **Passo 1**

- Os valores das variáveis nas imagens acima são meramente **ilustrativos** e **não** devem ser copiados 

##### Variáveis ansible_manual
- As variáveis que iniciam com **ansible_manual** são usadas para rodar o ansible depois que o recurso do ansible for executado, cada variável é um recurso do terraform que executa uma playbook do ansible

- Para que o ansible sejá executado depois de sua primeira execução, basta alterar a variável para um valor diferente do que está definido

- **ansible_manual_zabbix:** instala o Zabbix Server na maquina

### Passo 3 - Executar o Projeto

- Após a configuração das variáveis, clicar em **Queue plan**
 <img src="http://i.imgur.com/n5cgf5f.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />

- Ir em **Runs** e verificar a execução
 <img src="http://i.imgur.com/RQSQ5E6.png"
     alt="Markdown Monster icon"
     style="float: left; margin-right: 10px;" />



