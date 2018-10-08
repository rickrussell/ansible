# ansible
A collection of Ansible playbooks that run through specific tasks as well as provision machines.

These plays use sudo for Linux machines and kerberos/winrm for Windows machines. make sure you have
the correct permissions on the machine(s) that your provisioning.  

These plays also use /etc/ansible/hosts for inventory, we've provided one in the playbook hierarchy
to override any current settings.

Run your plays using the site.yml for the site your running against: packer or external 

For now we've split the sites into Linux and Windows hosts, so you'll find inventory files in each
site folder
```
inventory/external/linux.yml
inventory/external/windows.yml
```

## Testing with docker
```
inventory/packer/packer-docker.json
```

Build Container:
```
cd inventory/packer
packer build packer-docker.json
```
Additional information; Debug steps, keep docker container after failed build, specify logs:
```
PACKER_LOG=1 PACKER_LOG_PATH=/tmp/packer-recent.log packer build -on-error=abort -debug packer-docker.json
```

## Examples

Check if Playbook syntax is correct:  (--syntax):
```
ansible-playbook inventory/external/linux.yml --ask-become-pass --syntax
```

Check if Playbook works with a Dry Run:  (--check):
```
ansible-playbook inventory/external/linux.yml --ask-become-pass --check
```

Run Play, prompt locally and ask for sudo password:
```
ansible-playbook inventory/external/linux.yml --ask-become-pass
```
