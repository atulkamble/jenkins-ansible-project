#!/bin/bash
# Test Ansible connectivity

set -e

echo "Testing Ansible connectivity..."

# Test syntax
echo "Checking playbook syntax..."
ansible-playbook --syntax-check playbooks/deploy.yml
ansible-playbook --syntax-check playbooks/setup.yml

# Test connectivity
echo "Testing host connectivity..."
ansible all -i inventory/dev/hosts -m ping

echo "Listing all hosts..."
ansible all -i inventory/dev/hosts --list-hosts

echo "Ansible tests completed successfully!"
