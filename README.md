# FDPG+ Test Environment

This project defines the FDPG+ test environment in the Hetzner Cloud. We use Terraform for infrastructure deployment and Ansible for software installation and configuration of the individual VMs.

##<a id="terraform"></a> Terraform

We use Terraform v1.4.5+.

###<a id="terraform-state"></a> Terraform State

The Terraform state is shared using a remote storage mounted to the local path `.remote-storage/terraform/`. To be able to use the backend, which is necessary for all terraform commands interacting with the actual infrastructure, you need to mount the storage before executing any terraform commands. The recommended mount option is to use SSHFS (with workaround to prevent invalid terraform state if state shrinks):

```sh
sshfs u359202-sub1@u359202.your-storagebox.de:/terraform .remote-storage/terraform -o uid=$(id -u),gid=$(id -g),workaround=truncate,reconnect
```
Possible hosts and host groups are listed in `ansible/site.yml`.

For this to work your ssh public key needs to be added to the storage box authorized keys file beforehand.

###<a id="init-terraform"></a> Init Terraform

```sh
terraform init
```


###<a id="choose-terraform-workspace"></a> Choose Terraform Workspace

```sh
terraform workspace select dev
```

```sh
terraform workspace select test
```

###<a id="apply-terraform"></a> Apply Terraform

```sh
terraform apply
```

##<a id="ansible"></a> Ansible

We use ansible-playbook v2.14.5.

###<a id="local-ssh-config"></a> Local SSH Config

Everyone has to add this to his `~/.ssh/config` because Ansible works with this names:

```text
# FDPG Development Environment
Host dev-fdpg
Hostname 91.107.210.198
User ubuntu

Host dev-fdpg-keycloak
Hostname 188.34.191.244
User ubuntu

Host dev-diz-1-dsf-fhir
Hostname 88.198.173.77
User ubuntu

Host dev-diz-1-dsf-bpe
Hostname 188.34.181.226
User ubuntu

Host dev-diz-1-triangle
Hostname 128.140.62.38
User ubuntu

Host dev-diz-2-dsf-fhir
Hostname 128.140.80.17
User ubuntu

Host dev-diz-2-dsf-bpe
Hostname 138.201.116.210
User ubuntu

Host dev-diz-2-triangle
Hostname 5.75.240.43
User ubuntu

Host dev-dms-dsf-fhir
HostName 128.140.60.107
User ubuntu

# FDPG Test Environment
Host test-dms-dsf-fhir
Hostname 162.55.171.40
User ubuntu

Host test-diz-1-dsf-fhir
Hostname 49.12.77.194
User ubuntu

Host test-diz-1-dsf-bpe
Hostname 128.140.80.15
User ubuntu

Host test-diz-1-triangle
Hostname 167.235.246.101
User ubuntu

Host test-diz-2-dsf-fhir
Hostname 128.140.89.16
User ubuntu

Host test-diz-2-dsf-bpe
Hostname 49.12.215.228
User ubuntu

Host test-diz-2-triangle
Hostname 128.140.95.12
User ubuntu

Host fdpg-monitoring
Hostname 49.12.187.254
User ubuntu

Host mii-fhir
Hostname 128.140.115.131
User ubuntu
```

###<a id="run-all-playbooks"></a> Run all Playbooks

```sh
cd ansible
ansible-playbook -i hosts site.yml
```

###<a id="prerequisites"></a> Prerequisites

For accessing the test environment hosts and secrets you need your personal SSH public key being added to the Hetzner Cloud and deployed to the hosts and the Hetzner Storage Box by an already permitted user. Then you need to mount the secrets in **read-only** mode to the mountpoint `.remote-storage/secrets/`. The recommended way of mounting is to use *SSHFS*:

```sh
sshfs u359202-sub1@u359202.your-storagebox.de:/secrets .remote-storage/secrets -o uid=$(id -u),gid=$(id -g),ro,reconnect
```

###<a id="discover-facts"></a> Discover Facts

```sh
ansible -i hosts -m ansible.builtin.setup <hostname>
```

###<a id="run-individual-playbooks"></a> Run Playbooks for Individual Hosts or Host Groups

```sh
cd <PROJECT_DIR>/ansible
ansible-playbook -i hosts site.yml --limit dev,diz-1-dsf-fhir
```

##<a id="development"></a> Development

###<a id="add-new-role"></a> Add new role

```sh
cd ansible
ansible-galaxy init roles/<role-name>
```
