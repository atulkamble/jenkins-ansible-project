# Jenkins-Ansible CI/CD Project

A complete CI/CD pipeline using Jenkins and Ansible for automated application deployment across multiple environments.

## 🚀 Features

- **Automated CI/CD Pipeline** with Jenkins
- **Multi-Environment Deployment** (Dev, Staging, Production)
- **Infrastructure as Code** using Ansible
- **Automated Testing** and validation
- **Role-based Configuration** for modularity
- **Load Balancing** with HAProxy
- **Web Server** deployment with Nginx
- **Database** setup with MySQL
- **Application Server** configuration (Java, Node.js)

## 📋 Prerequisites

- Jenkins (2.400+)
- Ansible (2.14+)
- Python (3.8+)
- Git
- SSH access to target servers

## 🏗️ Project Structure

```
jenkins-ansible-project/
├── Jenkinsfile                 # Jenkins pipeline definition
├── ansible.cfg                 # Ansible configuration
├── inventory/
│   ├── dev/
│   │   └── hosts              # Development inventory
│   └── prod/
│       └── hosts              # Production inventory
├── playbooks/
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
│   ├── app.py                 # Sample application
│   └── requirements.txt       # Python dependencies
└── scripts/
    ├── setup-jenkins.sh       # Jenkins setup script
    └── test-ansible.sh        # Ansible test script
```

## 🔧 Setup

### 1. Configure Inventory

Edit inventory files for your environment:

```bash
# Development
vim inventory/dev/hosts

# Production
vim inventory/prod/hosts
```

### 2. Configure Ansible

Update SSH keys and connection settings in `ansible.cfg` if needed.

### 3. Install Dependencies

```bash
# Install Ansible collections
make install

# Or manually
ansible-galaxy collection install -r requirements.yml
```

### 4. Setup Jenkins

```bash
# Run setup script
chmod +x scripts/setup-jenkins.sh
./scripts/setup-jenkins.sh
```

Configure Jenkins:
1. Go to **Manage Jenkins** > **Global Tool Configuration**
2. Add Ansible installation
3. Configure Git
4. Add SSH credentials

### 5. Create Jenkins Pipeline

1. Create a new Pipeline job
2. Point to this repository
3. Jenkins will use the `Jenkinsfile` automatically

## 🚀 Usage

### Using Make Commands

```bash
# Check syntax
make syntax-check

# Lint playbooks
make lint

# Test connectivity
make test

# Deploy to development
make deploy-dev

# Deploy to production
make deploy-prod
```

### Using Ansible Directly

```bash
# Deploy to development
ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml \
  --extra-vars "env=development"

# Setup infrastructure
ansible-playbook -i inventory/dev/hosts playbooks/setup.yml

# Run tests
ansible-playbook -i inventory/dev/hosts playbooks/test.yml
```

### Using Jenkins

1. Go to Jenkins dashboard
2. Select the pipeline job
3. Click **Build Now**
4. Monitor the pipeline stages
5. For production deployment, approve the manual step

## 📊 Pipeline Stages

1. **Checkout** - Clone repository
2. **Validate Ansible** - Syntax checking
3. **Ansible Lint** - Code quality checks
4. **Deploy to Development** - Automated deployment
5. **Test Deployment** - Validation tests
6. **Deploy to Production** - Manual approval required

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

## 🧪 Testing

```bash
# Test connectivity
ansible all -i inventory/dev/hosts -m ping

# Run validation playbook
ansible-playbook -i inventory/dev/hosts playbooks/test.yml

# Check specific role
ansible-playbook playbooks/setup.yml --tags nginx --check
```

## 🐳 Docker Setup

Run Jenkins and Ansible in containers:

```bash
# Start services
docker-compose up -d

# Access Jenkins
open http://localhost:8080

# Execute Ansible in container
docker exec -it ansible-control ansible --version
```

## 📝 Customization

### Add New Environment

1. Create inventory file: `inventory/staging/hosts`
2. Update Jenkinsfile with new stage
3. Configure environment-specific variables

### Add New Role

```bash
# Create role structure
ansible-galaxy init roles/newrole

# Add tasks in roles/newrole/tasks/main.yml
# Add to playbooks/setup.yml
```

### Modify Application

Edit files in `app/` directory and update `playbooks/deploy.yml` accordingly.

## 🐛 Troubleshooting

### Connectivity Issues

```bash
# Test SSH connection
ssh -i ~/.ssh/id_rsa ansible@target-host

# Verify inventory
ansible-inventory -i inventory/dev/hosts --list
```

### Jenkins Issues

```bash
# Check Jenkins logs
docker logs jenkins

# Restart Jenkins
docker restart jenkins
```

### Ansible Issues

```bash
# Verbose output
ansible-playbook playbooks/deploy.yml -vvv

# Check syntax
ansible-playbook --syntax-check playbooks/deploy.yml
```

## 📚 Documentation

- [Ansible Documentation](https://docs.ansible.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Jenkins community
- Ansible community
- Open source contributors

---

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
