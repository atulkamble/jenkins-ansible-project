# Jenkins-Ansible CI/CD Project

[![GitHub](https://img.shields.io/badge/GitHub-jenkins--ansible--project-blue?logo=github)](https://github.com/atulkamble/jenkins-ansible-project)
[![Ansible](https://img.shields.io/badge/Ansible-2.14+-red?logo=ansible)](https://www.ansible.com/)
[![Jenkins](https://img.shields.io/badge/Jenkins-2.400+-blue?logo=jenkins)](https://www.jenkins.io/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A complete CI/CD pipeline using Jenkins and Ansible for automated application deployment across multiple environments.

## 🚀 Features

- **Automated CI/CD Pipeline** with Jenkins
- **Multi-Environment Deployment** (Local, Dev, Production)
- **Infrastructure as Code** using Ansible
- **Automated Testing** and validation
- **Role-based Configuration** for modularity
- **Load Balancing** with HAProxy
- **Web Server** deployment with Nginx
- **Database** setup with MySQL
- **Application Server** configuration (Java, Node.js)
- **Docker Support** for containerized deployments

## 📋 Prerequisites

- **Ansible** (2.14+) - Configuration management
- **Python** (3.8+) - Required for Ansible
- **Git** - Version control
- **Jenkins** (2.400+) - Optional, for CI/CD pipeline
- **SSH access** - For remote server deployments (optional)

## ⚡ Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/atulkamble/jenkins-ansible-project.git
cd jenkins-ansible-project
```

### 2. Install Dependencies

```bash
# Install Ansible collections
make install

# Verify installation
ansible --version
```

### 3. Run Local Demo

```bash
# Test connectivity
make test

# Deploy application locally (no sudo required)
ansible-playbook playbooks/demo.yml

# Application will be deployed to: ~/jenkins-ansible-demo
```

### 4. Test the Application

```bash
# Navigate to deployed app
cd ~/jenkins-ansible-demo

# Run the application
python3 app.py

# Access in browser: http://localhost:8080
# Or test with curl:
curl http://localhost:8080/
curl http://localhost:8080/health
```

**Expected Output:**
```json
{
  "status": "success",
  "message": "Hello from Jenkins + Ansible! 🚀",
  "hostname": "your-hostname",
  "environment": "local",
  "timestamp": "2025-11-21T05:23:19",
  "deployed_by": "Ansible",
  "version": "1.0.0"
}
```

## 🏗️ Project Structure

```
jenkins-ansible-project/
├── Jenkinsfile                 # Jenkins pipeline definition
├── ansible.cfg                 # Ansible configuration
├── Makefile                    # Quick commands
├── inventory/
│   ├── local/hosts            # Local testing (localhost)
│   ├── dev/hosts              # Development servers
│   └── prod/hosts             # Production servers
├── playbooks/
│   ├── demo.yml               # Local demo deployment
│   ├── deploy.yml             # Application deployment
│   ├── setup.yml              # Infrastructure setup
│   └── test.yml               # Deployment testing
├── roles/
│   ├── common/                # Common configuration
│   ├── nginx/                 # Nginx web server
│   ├── java/                  # Java runtime
│   ├── nodejs/                # Node.js runtime
│   ├── mysql/                 # MySQL database
│   └── haproxy/               # HAProxy load balancer
├── templates/
│   └── app.conf.j2            # Application config template
├── app/
│   ├── app.py                 # Sample Python application
│   └── requirements.txt       # Python dependencies
└── scripts/
    ├── setup-jenkins.sh       # Jenkins setup script
    └── test-ansible.sh        # Ansible test script
```

## 🎯 Usage Guide

### Make Commands (Recommended)

```bash
# View all available commands
make help

# Install Ansible dependencies
make install

# Test local connectivity
make test

# Check playbook syntax
make syntax-check

# Run Ansible lint
make lint

# Deploy to development servers
make deploy-dev

# Deploy to production servers
make deploy-prod

# Setup infrastructure
make setup-dev
make setup-prod
```

### Running Playbooks Directly

#### Local Demo Deployment
```bash
# Deploy application to ~/jenkins-ansible-demo
ansible-playbook playbooks/demo.yml

# Run the deployed app
cd ~/jenkins-ansible-demo && python3 app.py
```

#### Development Environment
```bash
# Deploy to development servers
ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml \
  --extra-vars "env=development"

# Setup infrastructure
ansible-playbook -i inventory/dev/hosts playbooks/setup.yml

# Run validation tests
ansible-playbook -i inventory/dev/hosts playbooks/test.yml
```

#### Production Environment
```bash
# Deploy to production (with confirmation)
ansible-playbook -i inventory/prod/hosts playbooks/deploy.yml \
  --extra-vars "env=production"

# Dry run (check mode)
ansible-playbook -i inventory/prod/hosts playbooks/deploy.yml --check
```

### Verbose Output (Debugging)
```bash
# Run with verbose output
ansible-playbook playbooks/demo.yml -vvv

# See what would change without applying
ansible-playbook -i inventory/dev/hosts playbooks/setup.yml --check --diff
```

## 🔧 Configuration

### For Local Testing (Default)

No configuration needed! The project works out of the box using localhost.

### For Remote Servers

#### 1. Update Inventory Files

**Development (`inventory/dev/hosts`):**
```ini
[webservers]
web1.dev.example.com ansible_host=YOUR_SERVER_IP
web2.dev.example.com ansible_host=YOUR_SERVER_IP

[appservers]
app1.dev.example.com ansible_host=YOUR_SERVER_IP

[databases]
db1.dev.example.com ansible_host=YOUR_SERVER_IP

[loadbalancers]
lb1.dev.example.com ansible_host=YOUR_SERVER_IP

[development:vars]
ansible_user=YOUR_SSH_USER
ansible_ssh_private_key_file=~/.ssh/YOUR_KEY.pem
ansible_become=yes
env=development
```

#### 2. Setup SSH Access

```bash
# Generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_key

# Copy to servers
ssh-copy-id -i ~/.ssh/ansible_key.pub user@server-ip

# Test connection
ssh -i ~/.ssh/ansible_key user@server-ip
```

#### 3. Test Connectivity

```bash
# Test development servers
make test-dev

# Or manually
ansible all -i inventory/dev/hosts -m ping
```

## 🐳 Docker Setup

Run Jenkins and Ansible in containers:

```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Access Jenkins
open http://localhost:8080

# Execute Ansible commands in container
docker exec -it ansible-control ansible --version

# Stop services
docker-compose down
```

## 🔄 Jenkins CI/CD Pipeline

### Setup Jenkins Pipeline

1. **Install Jenkins** (if not using Docker)
   ```bash
   # Run setup script
   chmod +x scripts/setup-jenkins.sh
   ./scripts/setup-jenkins.sh
   ```

2. **Configure Jenkins:**
   - Go to **Manage Jenkins** > **Global Tool Configuration**
   - Add Ansible installation
   - Configure Git credentials
   - Add SSH credentials for remote servers

3. **Create Pipeline Job:**
   - New Item → Pipeline
   - Pipeline → Definition → Pipeline script from SCM
   - SCM → Git
   - Repository URL: `https://github.com/atulkamble/jenkins-ansible-project.git`
   - Script Path: `Jenkinsfile`

4. **Run Pipeline:**
   - Click **Build Now**
   - Monitor stages in Blue Ocean or Classic view
   - Approve production deployment when prompted

## 📊 Jenkins Pipeline Stages

The Jenkins pipeline includes the following stages:

1. **Checkout** - Clone repository from GitHub
2. **Validate Ansible** - Syntax checking of playbooks
3. **Ansible Lint** - Code quality and best practices check
4. **Deploy to Development** - Automated deployment to dev environment
5. **Test Deployment** - Run validation tests
6. **Deploy to Production** - Manual approval required (main branch only)

```groovy
// Jenkinsfile excerpt
stage('Deploy to Production') {
    when {
        branch 'main'
    }
    steps {
        input message: 'Deploy to Production?', ok: 'Deploy'
        // Deployment steps...
    }
}
```

## 📝 Available Playbooks

| Playbook | Purpose | Usage |
|----------|---------|-------|
| `demo.yml` | Local demo deployment | `ansible-playbook playbooks/demo.yml` |
| `deploy.yml` | Application deployment | `ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml` |
| `setup.yml` | Infrastructure setup | `ansible-playbook -i inventory/dev/hosts playbooks/setup.yml` |
| `test.yml` | Validation testing | `ansible-playbook -i inventory/dev/hosts playbooks/test.yml` |

## 🎭 Ansible Roles

| Role | Description | Components |
|------|-------------|------------|
| `common` | Base configuration for all servers | System packages, NTP, firewall, timezone |
| `nginx` | Web server setup | Nginx installation, SSL, site configs |
| `java` | Java runtime environment | OpenJDK 11, JAVA_HOME configuration |
| `nodejs` | Node.js runtime | Node.js 18.x, npm |
| `mysql` | Database server | MySQL installation, database creation, users |
| `haproxy` | Load balancer | HAProxy with round-robin backend configuration |

## 🔒 Security

- Store secrets in Jenkins credentials
- Use Ansible Vault for sensitive data
- Configure SSH key-based authentication
- Implement least privilege access
- Regular security updates

### Using Ansible Vault

```bash
# Create encrypted file
ansible-vault create secrets.yml

# Edit encrypted file
ansible-vault edit secrets.yml

# Run playbook with vault
ansible-playbook playbooks/deploy.yml --ask-vault-pass
```

## 🧪 Testing & Validation

### Local Testing
```bash
# Test connectivity (local)
make test

# Run demo deployment
ansible-playbook playbooks/demo.yml

# Verify deployed application
cd ~/jenkins-ansible-demo
python3 app.py
curl http://localhost:8080/
```

### Remote Server Testing
```bash
# Test connectivity to remote servers
make test-dev

# Run in check mode (dry run)
ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml --check

# Run with diff to see changes
ansible-playbook -i inventory/dev/hosts playbooks/setup.yml --check --diff

# Test specific role
ansible-playbook playbooks/setup.yml --tags nginx --check

# Validate playbook syntax
make syntax-check

# Run Ansible lint
make lint
```

### Health Checks
```bash
# Check service status
ansible webservers -i inventory/dev/hosts -m service \
  -a "name=nginx state=started" -b

# Test HTTP endpoints
ansible webservers -i inventory/dev/hosts -m uri \
  -a "url=http://localhost return_content=yes"

# Gather system facts
ansible all -i inventory/dev/hosts -m setup \
  -a "filter=ansible_distribution*"
```

## 🎨 Customization

### Adding a New Environment

1. **Create inventory file:**
   ```bash
   mkdir -p inventory/staging
   cp inventory/dev/hosts inventory/staging/hosts
   # Edit with staging server details
   vim inventory/staging/hosts
   ```

2. **Update Makefile:**
   ```makefile
   deploy-staging:
       ansible-playbook -i inventory/staging/hosts playbooks/deploy.yml \
         --extra-vars "env=staging"
   ```

3. **Add Jenkins stage** (optional):
   ```groovy
   stage('Deploy to Staging') {
       steps {
           sh 'make deploy-staging'
       }
   }
   ```

### Creating a New Ansible Role

```bash
# Generate role structure
ansible-galaxy init roles/newrole

# Edit tasks
vim roles/newrole/tasks/main.yml

# Add to playbook
echo "    - newrole" >> playbooks/setup.yml

# Test the role
ansible-playbook playbooks/setup.yml --tags newrole --check
```

### Customizing the Application

1. **Modify Python app:**
   ```bash
   vim app/app.py
   ```

2. **Update deployment:**
   ```bash
   ansible-playbook playbooks/demo.yml
   ```

3. **Add new dependencies:**
   ```bash
   echo "new-package==1.0.0" >> app/requirements.txt
   ```

### Environment-Specific Variables

Create group_vars for each environment:

```bash
# Create directory
mkdir -p group_vars/development group_vars/production

# Add variables
cat > group_vars/development/vars.yml <<EOF
---
app_version: "1.0.0-dev"
debug_mode: true
log_level: DEBUG
EOF

cat > group_vars/production/vars.yml <<EOF
---
app_version: "1.0.0"
debug_mode: false
log_level: INFO
EOF
```

## 🐛 Troubleshooting

### Common Issues

#### "Connection timeout" or "Unreachable" errors

**Problem:** Inventory configured with non-existent servers

**Solution:**
```bash
# Use local inventory for testing
make test

# Or update inventory with real server IPs
vim inventory/dev/hosts

# Test connectivity
ansible all -i inventory/dev/hosts -m ping
```

#### "Permission denied" errors

**Problem:** SSH key or permissions issue

**Solution:**
```bash
# Check SSH key permissions
chmod 400 ~/.ssh/your-key.pem

# Test SSH connection
ssh -i ~/.ssh/your-key.pem user@server-ip

# Verify inventory settings
ansible-inventory -i inventory/dev/hosts --list
```

#### "sudo password required" errors

**Problem:** Running local playbooks that require sudo

**Solution:**
```bash
# Use demo playbook (no sudo required)
ansible-playbook playbooks/demo.yml

# Or set become=no in inventory
echo "ansible_become=no" >> inventory/local/hosts
```

#### Module or dependency errors

**Problem:** Missing Ansible collections or Python modules

**Solution:**
```bash
# Install Ansible requirements
make install

# Or manually
ansible-galaxy collection install -r requirements.yml

# Check Python dependencies
pip3 install ansible
```

### Verbose Debugging

```bash
# Run with maximum verbosity
ansible-playbook playbooks/deploy.yml -vvvv

# Check syntax before running
ansible-playbook --syntax-check playbooks/deploy.yml

# Verify inventory parsing
ansible-inventory -i inventory/dev/hosts --graph
```

### Jenkins Troubleshooting

```bash
# Check Jenkins logs (Docker)
docker logs jenkins

# Restart Jenkins
docker restart jenkins

# Check Jenkins service (native)
sudo systemctl status jenkins
sudo systemctl restart jenkins
```

## 📚 Additional Resources

### Documentation Files

- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference guide
- **[SETUP.md](SETUP.md)** - Complete setup instructions
- **[docs/AWS_SETUP.md](docs/AWS_SETUP.md)** - AWS EC2 deployment guide
- **[docs/Vagrantfile.example](docs/Vagrantfile.example)** - Local VM setup

### Useful Links

- [Ansible Documentation](https://docs.ansible.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

### Example Use Cases

1. **Local Development & Testing**
   ```bash
   git clone https://github.com/atulkamble/jenkins-ansible-project.git
   cd jenkins-ansible-project
   make install && make test
   ansible-playbook playbooks/demo.yml
   ```

2. **AWS EC2 Deployment**
   - Follow [AWS_SETUP.md](docs/AWS_SETUP.md)
   - Launch EC2 instances
   - Update inventory with instance IPs
   - Run `make deploy-dev`

3. **Vagrant Local VMs**
   ```bash
   cp docs/Vagrantfile.example Vagrantfile
   vagrant up
   # Update inventory with VM IPs (192.168.56.x)
   make test-dev
   ```

4. **Jenkins CI/CD Pipeline**
   ```bash
   docker-compose up -d
   # Configure Jenkins at http://localhost:8080
   # Create pipeline pointing to this repo
   ```

## 🤝 Contributing

Contributions are welcome! Here's how:

1. **Fork the repository**
   ```bash
   # Click 'Fork' on GitHub
   git clone https://github.com/YOUR_USERNAME/jenkins-ansible-project.git
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```

3. **Make changes and test**
   ```bash
   # Make your changes
   make syntax-check
   make test
   ansible-playbook playbooks/demo.yml
   ```

4. **Commit and push**
   ```bash
   git add .
   git commit -m "Add amazing feature"
   git push origin feature/amazing-feature
   ```

5. **Submit a Pull Request**
   - Go to your fork on GitHub
   - Click 'New Pull Request'
   - Describe your changes

### Code Guidelines

- Follow Ansible best practices
- Test all changes locally first
- Update documentation for new features
- Use meaningful commit messages
- Add comments for complex logic

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Atul Kamble**
- GitHub: [@atulkamble](https://github.com/atulkamble)
- Repository: [jenkins-ansible-project](https://github.com/atulkamble/jenkins-ansible-project)

## 🙏 Acknowledgments

- Jenkins community for CI/CD excellence
- Ansible community for automation tools
- Open source contributors worldwide
- All users and contributors to this project

## ⭐ Show Your Support

Give a ⭐ if this project helped you!

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/atulkamble/jenkins-ansible-project/issues)
- **Discussions:** [GitHub Discussions](https://github.com/atulkamble/jenkins-ansible-project/discussions)

---

**Made with ❤️ by [Atul Kamble](https://github.com/atulkamble)**

# ✅ **📌 Project Overview**

This project demonstrates:

* Jenkins CI pipeline
* Ansible for automated provisioning & deployment
* GitHub → Jenkins → Ansible → EC2 full CI/CD workflow
* Infrastructure deployment using Ansible roles
* Automated service start, updates, rollback

Works perfectly for:
✔ DevOps Hands-On
✔ Practical Exams
✔ Resume/GitHub Projects
✔ Real-world client projects

---

# 📁 **PROJECT STRUCTURE**

```
jenkins-ansible-project/
├── Jenkinsfile
├── ansible/
│   ├── ansible.cfg
│   ├── inventory
│   │   └── hosts
│   ├── playbooks/
│   │   ├── install_dependencies.yml
│   │   ├── deploy_app.yml
│   │   ├── rollback.yml
│   └── roles/
│       └── webserver/
│           ├── tasks/
│           │   ├── main.yml
│           │   ├── install.yml
│           │   ├── deploy.yml
│           │   └── rollback.yml
│           ├── templates/
│           │   └── index.html.j2
└── src/
    └── index.html
```

---

# 🔧 **1. Jenkinsfile (CI/CD Pipeline)**

```groovy
pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/atul/jenkins-ansible-project.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                ansiblePlaybook credentialsId: 'ec2-key',
                                 inventory: 'ansible/inventory/hosts',
                                 playbook: 'ansible/playbooks/install_dependencies.yml'
            }
        }

        stage('Deploy Application') {
            steps {
                ansiblePlaybook credentialsId: 'ec2-key',
                                 inventory: 'ansible/inventory/hosts',
                                 playbook: 'ansible/playbooks/deploy_app.yml'
            }
        }
    }

    post {
        failure {
            ansiblePlaybook credentialsId: 'ec2-key',
                             inventory: 'ansible/inventory/hosts',
                             playbook: 'ansible/playbooks/rollback.yml'
        }
    }
}
```

---

# 🧩 **2. ansible.cfg**

```ini
[defaults]
inventory = inventory/hosts
host_key_checking = False
retry_files_enabled = False
roles_path = roles
```

---

# 🌐 **3. Inventory File (hosts)**

```
[web]
18.212.xx.xx ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/ansible.pem
```

---

# 📘 **4. Playbook: install_dependencies.yml**

```yaml
---
- name: Install dependencies on EC2
  hosts: web
  become: yes

  roles:
    - { role: webserver, tasks_from: install }
```

---

# 📘 **5. Playbook: deploy_app.yml**

```yaml
---
- name: Deploy web application to EC2
  hosts: web
  become: yes

  roles:
    - { role: webserver, tasks_from: deploy }
```

---

# 🌀 **6. Playbook: rollback.yml**

```yaml
---
- name: Rollback to previous version
  hosts: web
  become: yes

  roles:
    - { role: webserver, tasks_from: rollback }
```

---

# 🛠 **7. Role: webserver → install.yml**

```yaml
---
- name: Install HTTPD
  yum:
    name: httpd
    state: present

- name: Start and enable service
  service:
    name: httpd
    state: started
    enabled: yes
```

---

# 🚀 **8. Role: webserver → deploy.yml**

```yaml
---
- name: Copy application files
  copy:
    src: "{{ playbook_dir }}/../../src/index.html"
    dest: /var/www/html/index.html
    owner: apache
    group: apache
    mode: '0644'

- name: Restart httpd
  service:
    name: httpd
    state: restarted
```

---

# 🔙 **9. Role: webserver → rollback.yml**

```yaml
---
- name: Restore previous index.html
  copy:
    src: /var/www/html/index.html.bak
    dest: /var/www/html/index.html

- name: Restart httpd
  service:
    name: httpd
    state: restarted
```

---

# 🎨 **10. Sample Application File**

`src/index.html`

```html
<h1>Welcome to Jenkins + Ansible CI/CD</h1>
<p>Deployed using automation!</p>
```

---

# 🖥 **11. Jenkins Requirements**

### **Install plugins**

* Ansible plugin
* Git plugin
* Credentials Binding

### **Add credentials**

* SSH key for EC2
* GitHub credentials (optional)

---

# ☁ **12. Workflow**

```
Developer → GitHub → Jenkins (CI) → Ansible (CD) → EC2 Web Server
```

### Pipeline Flow:

1. Developer pushes code to GitHub
2. Jenkins pulls code
3. Installs dependencies on EC2
4. Deploys application using Ansible
5. On failure → automatic rollback

---

# 📦 **Deliverables (For GitHub or Exam Submission)**

✔ Full project folder
✔ Jenkinsfile
✔ All playbooks
✔ Screenshots of pipeline run
✔ EC2 web page screenshot
✔ GitHub repo link

---
