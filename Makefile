.PHONY: help install lint syntax-check test deploy-dev deploy-prod

help:
	@echo "════════════════════════════════════════════════════════"
	@echo "  Jenkins-Ansible Project - Available Commands"
	@echo "════════════════════════════════════════════════════════"
	@echo ""
	@echo "📦 Setup & Installation:"
	@echo "  make install        - Install Ansible dependencies"
	@echo ""
	@echo "✅ Testing & Validation:"
	@echo "  make test          - Test local connectivity"
	@echo "  make test-dev      - Test development servers"
	@echo "  make syntax-check  - Validate playbook syntax"
	@echo "  make lint          - Run Ansible lint"
	@echo ""
	@echo "🚀 Deployment:"
	@echo "  make demo          - Run local demo deployment"
	@echo "  make deploy-dev    - Deploy to development"
	@echo "  make deploy-prod   - Deploy to production"
	@echo ""
	@echo "🔧 Infrastructure Setup:"
	@echo "  make setup-dev     - Setup development infrastructure"
	@echo "  make setup-prod    - Setup production infrastructure"
	@echo ""
	@echo "════════════════════════════════════════════════════════"

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

demo:
	@echo "🚀 Running local demo deployment..."
	@echo "This will deploy a sample application to ~/jenkins-ansible-demo"
	ansible-playbook playbooks/demo.yml
	@echo ""
	@echo "✅ Demo deployment complete!"
	@echo "📁 Application directory: ~/jenkins-ansible-demo"
	@echo ""
	@echo "🎯 Next steps:"
	@echo "   cd ~/jenkins-ansible-demo"
	@echo "   python3 app.py"
	@echo "   curl http://localhost:8080/"
