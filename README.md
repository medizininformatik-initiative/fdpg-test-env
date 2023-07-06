# FDPG+ Test Environment

This project defines the FDPG+ test environment in the Hetzner Cloud. We use Terraform for infrastructure deployment and Ansible for software installation and configuration of the individual VMs.

## Terraform

We use Terraform v1.4.5+.

### Terraform State

The Terraform state is shared using the WebDAV protocol. To be able to use the backend, which is necessary for all terraform commands interacting with the actual infrastructure, you need to set the following environment variables:

* `TF_HTTP_ADDRES` - the WebDAV service endpoint including the path to the terraform state file (e.q. `https://webdav.example.com/terraform/terraform.tfstate`)
* `TF_HTTP_USERNAME` - the name of the WebDAV account
* `TF_HTTP_PASSWORD` - the password of the WebDAV account

These credentials are stored on the StorageBox under the paths `secrets/webdav/address`, `secrets/webdav/username` and `secrets/webdav/password`.

### Init Terraform

```sh
terraform init
```


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

Host fdpg-monitoring
Hostname 49.12.187.254
User ubuntu

Host fdpg-perf-test
Hostname 49.13.17.192
User ubuntu

Host dms-dsf-fhir
Hostname 162.55.171.40
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

Host diz-2-dsf-fhir
Hostname 128.140.89.16
User ubuntu

Host diz-2-dsf-bpe
Hostname 49.12.215.228
User ubuntu

Host diz-2-triangle
Hostname 128.140.95.12
User ubuntu
```

### Run all Playbooks

```sh
cd ansible
ansible-playbook -i hosts site.yml
```

### Prerequisites

For accessing the test environment hosts and secrets you need your personal SSH public key being added to the Hetzner Cloud and deployed to the hosts and the Hetzner Storage Box by an already permitted user.

### Discover Facts

```sh
ansible -i hosts -m ansible.builtin.setup <hostname>
```

### Run Playbooks for Individual Hosts or Host Groups

```sh
cd <PROJECT_DIR>/ansible
ansible-playbook -i hosts site.yml --limit monitoring,diz-1-dsf-fhir
```
Possible hosts and host groups are listed in `ansible/site.yml`.

## Development

### Add new role

```sh
cd ansible
ansible-galaxy init roles/<role-name>
```
