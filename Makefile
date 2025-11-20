.PHONY: help install lint syntax-check test deploy-dev deploy-prod

help:
	@echo "Jenkins-Ansible Project Commands:"
	@echo "  make install        - Install Ansible dependencies"
	@echo "  make lint          - Run Ansible lint"
	@echo "  make syntax-check  - Check playbook syntax"
	@echo "  make test          - Test Ansible connectivity"
	@echo "  make deploy-dev    - Deploy to development"
	@echo "  make deploy-prod   - Deploy to production"

install:
	ansible-galaxy collection install -r requirements.yml

lint:
	ansible-lint playbooks/*.yml

syntax-check:
	ansible-playbook --syntax-check playbooks/deploy.yml
	ansible-playbook --syntax-check playbooks/setup.yml
	ansible-playbook --syntax-check playbooks/test.yml

test:
	ansible all -i inventory/dev/hosts -m ping

deploy-dev:
	ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml --extra-vars "env=development"

deploy-prod:
	ansible-playbook -i inventory/prod/hosts playbooks/deploy.yml --extra-vars "env=production"

setup-dev:
	ansible-playbook -i inventory/dev/hosts playbooks/setup.yml

setup-prod:
	ansible-playbook -i inventory/prod/hosts playbooks/setup.yml
