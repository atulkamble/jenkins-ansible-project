.PHONY: help install lint syntax-check test deploy-dev deploy-prod

help:
	@echo "Jenkins-Ansible Project Commands:"
	@echo "  make install        - Install Ansible dependencies"
	@echo "  make lint          - Run Ansible lint"
	@echo "  make syntax-check  - Check playbook syntax"
	@echo "  make test          - Test Ansible connectivity (local)"
	@echo "  make test-dev      - Test development servers connectivity"
	@echo "  make deploy-dev    - Deploy to development"
	@echo "  make deploy-prod   - Deploy to production"
	@echo "  make setup-local   - Setup local environment"

install:
	ansible-galaxy collection install -r requirements.yml

lint:
	ansible-lint playbooks/*.yml

syntax-check:
	ansible-playbook --syntax-check playbooks/deploy.yml
	ansible-playbook --syntax-check playbooks/setup.yml
	ansible-playbook --syntax-check playbooks/test.yml

test:
	@echo "Testing local connectivity..."
	ansible all -i inventory/local/hosts -m ping

test-dev:
	@echo "Testing development servers connectivity..."
	ansible all -i inventory/dev/hosts -m ping

deploy-dev:
	ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml --extra-vars "env=development"

deploy-prod:
	ansible-playbook -i inventory/prod/hosts playbooks/deploy.yml --extra-vars "env=production"

setup-dev:
	ansible-playbook -i inventory/dev/hosts playbooks/setup.yml

setup-prod:
	ansible-playbook -i inventory/prod/hosts playbooks/setup.yml

setup-local:
	@echo "Setting up local environment..."
	ansible-playbook -i inventory/local/hosts playbooks/test.yml
