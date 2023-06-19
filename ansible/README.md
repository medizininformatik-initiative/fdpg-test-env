# Ansible

## Discover Facts

```sh
ansible -i hosts -m ansible.builtin.setup <hostname>
```

## Run Playbooks for an Individual Host

```sh
ansible-playbook -i hosts site.yml --limit monitoring
```
