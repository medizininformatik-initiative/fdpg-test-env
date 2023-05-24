# FDPG+ Test Environment

This project defines the FDPG+ test environment in the Hetzner Cloud. We use Terraform for infrastructure deployment and Ansible for software installation and configuration of the individual VMs.

## Terraform

We use Terraform v1.4.5.

### Init Terraform

```sh
terraform init
```

### Terraform State

Currently, the Terraform state is not shared. So only Alex can use Terraform right now.

### Choose Terraform Workspace

```sh
terraform workspace select default
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
Host fdpg
Hostname 91.107.208.91
User ubuntu

Host fdpg-keycloak
Hostname 49.13.3.64
User ubuntu

Host fdpg-perf-test
Hostname 49.13.17.192
User ubuntu

Host diz-1-dsf-fhir
Hostname 49.12.77.194
User ubuntu

Host diz-1-dsf-bpe
Hostname 128.140.80.15
User ubuntu

Host diz-1-triangle
Hostname 167.235.246.101
User ubuntu
```

### Run all Playbooks

```sh
cd ansible
ansible-playbook -i hosts site.yml
```

### Add new role

```sh
cd ansible
ansible-galaxy init roles/<role-name>
```
