# FDPG+ Test Environment

This project defines the FDPG+ test environment in the Hetzner Cloud. We use Terraform for infrastructure deployment and Ansible for software installation and configuration of the individual VMs.

## Terraform

We use Terraform v1.4.5+.

### Terraform State

The Terraform state is shared using a remote storage mounted to the local path `.remote-storage/terraform/`. To be able to use the backend, which is necessary for all terraform commands interacting with the actual infrastructure, you need to mount the storage before executing any terraform commands. The recommended mount option is to use SSHFS (with workaround to prevent invalid terraform state if state shrinks):

```sh
sshfs u359202-sub1@u359202.your-storagebox.de:/terraform .remote-storage/terraform -o uid=$(id -u),gid=$(id -g),workaround=truncate,reconnect
```
Possible hosts and host groups are listed in `ansible/site.yml`.

For this to work your ssh public key needs to be added to the storage box authorized keys file beforehand.

### Init Terraform

```sh
terraform init
```


### Choose Terraform Workspace

```sh
terraform workspace select dev
```

```sh
terraform workspace select test
```

### Apply Terraform

```sh
terraform apply
```

## Ansible

We use ansible-playbook v2.14.5.

### Local SSH Config

Everyone has to add this to his `~/.ssh/config` because Ansible works with this names:

```text
# FDPG Development Environment
Host dev-fdpg
Hostname 46.225.51.107
User ubuntu

Host dev-fdpg-keycloak
Hostname 46.225.52.32
User ubuntu

Host dev-diz-1-dsf-fhir
Hostname 167.235.59.131
User ubuntu

Host dev-diz-1-dsf-bpe
Hostname 46.225.60.237
User ubuntu

Host dev-diz-1-triangle
Hostname 46.225.60.68
User ubuntu

Host dev-diz-2-dsf-fhir
Hostname 46.225.52.139
User ubuntu

Host dev-diz-2-dsf-bpe
Hostname 46.225.49.212
User ubuntu

Host dev-diz-2-triangle
Hostname 46.225.51.140
User ubuntu

Host dev-dms-dsf-fhir
HostName 46.225.61.238
User ubuntu

# FDPG Test Environment
Host test-dms-dsf-fhir
Hostname 46.225.125.11
User ubuntu

Host test-diz-1-dsf-fhir
Hostname 46.225.128.190
User ubuntu

Host test-diz-1-dsf-bpe
Hostname 46.225.129.139
User ubuntu

Host test-diz-1-triangle
Hostname 46.225.132.85
User ubuntu

Host test-diz-2-dsf-fhir
Hostname 46.225.138.83
User ubuntu

Host test-diz-2-dsf-bpe
Hostname 46.225.137.88
User ubuntu

Host test-diz-2-triangle
Hostname 46.225.135.82
User ubuntu

Host fdpg-monitoring
Hostname 49.12.187.254
User ubuntu

Host mii-fhir
Hostname 128.140.115.131
User ubuntu
```

### Run all Playbooks

```sh
cd ansible
ansible-playbook -i hosts site.yml
```

### Prerequisites

For accessing the test environment hosts and secrets you need your personal SSH public key being added to the Hetzner Cloud and deployed to the hosts and the Hetzner Storage Box by an already permitted user. Then you need to mount the secrets in **read-only** mode to the mountpoint `.remote-storage/secrets/`. The recommended way of mounting is to use *SSHFS*:

```sh
sshfs u359202-sub1@u359202.your-storagebox.de:/secrets .remote-storage/secrets -o uid=$(id -u),gid=$(id -g),ro,reconnect
```

### Discover Facts

```sh
ansible -i hosts -m ansible.builtin.setup <hostname>
```

### Run Playbooks for Individual Hosts or Host Groups

```sh
cd <PROJECT_DIR>/ansible
ansible-playbook -i hosts site.yml --limit dev,diz-1-dsf-fhir
```

## Development

### Add new role

```sh
cd ansible
ansible-galaxy init roles/<role-name>
```
