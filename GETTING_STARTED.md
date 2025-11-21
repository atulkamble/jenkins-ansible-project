# Getting Started with Jenkins-Ansible Project

Welcome! This guide will help you get started with the Jenkins-Ansible CI/CD project in just a few minutes.

## 🚀 5-Minute Quick Start

### Step 1: Clone the Repository

```bash
git clone https://github.com/atulkamble/jenkins-ansible-project.git
cd jenkins-ansible-project
```

### Step 2: Install Dependencies

```bash
make install
```

**Expected output:**
```
Starting galaxy collection install process
Nothing to do. All requested collections are already installed.
```

### Step 3: Test the Setup

```bash
make test
```

**Expected output:**
```
Testing local connectivity...
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

✅ **Success!** Your environment is ready.

### Step 4: Run the Demo

```bash
make demo
```

This will:
- Create `~/jenkins-ansible-demo` directory
- Deploy a sample Python web application
- Set up configuration files
- Display deployment summary

**Expected output:**
```
╔══════════════════════════════════════════════════════╗
║     DEPLOYMENT COMPLETED SUCCESSFULLY! ✅            ║
╚══════════════════════════════════════════════════════╝

📁 Application Directory: /Users/YOUR_USER/jenkins-ansible-demo

📝 Files Deployed:
   - app.py
   - requirements.txt
   - config/app.conf
   - README.md

🚀 Next Steps:
   1. cd /Users/YOUR_USER/jenkins-ansible-demo
   2. pip3 install -r requirements.txt
   3. python3 app.py
   4. Open http://localhost:8080
```

### Step 5: Run the Application

```bash
cd ~/jenkins-ansible-demo
python3 app.py
```

**Expected output:**
```
✅ Server started on http://localhost:0.0.0.0:8080
📊 Access endpoints:
   - http://localhost:8080/
   - http://localhost:8080/health
🛑 Press Ctrl+C to stop
```

### Step 6: Test the Application

Open another terminal and run:

```bash
# Test main endpoint
curl http://localhost:8080/

# Test health endpoint
curl http://localhost:8080/health
```

**Expected JSON response:**
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

🎉 **Congratulations!** You've successfully deployed your first application using Ansible!

---

## 📖 What Just Happened?

1. **Ansible** read the `playbooks/demo.yml` playbook
2. Connected to **localhost** (your machine)
3. Created directory structure in `~/jenkins-ansible-demo`
4. Deployed application files (`app.py`, `requirements.txt`, etc.)
5. Generated configuration files from templates
6. Displayed a deployment summary

---

## 🎯 Next Steps

### Option 1: Explore the Project

```bash
# View all available commands
make help

# Check playbook syntax
make syntax-check

# View project structure
tree -L 2

# Read the detailed README
cat README.md
```

### Option 2: Deploy to Remote Servers

1. **Get Servers Ready:**
   - AWS EC2: Follow [docs/AWS_SETUP.md](docs/AWS_SETUP.md)
   - Vagrant VMs: Use [docs/Vagrantfile.example](docs/Vagrantfile.example)
   - Your own servers: Ensure SSH access

2. **Update Inventory:**
   ```bash
   vim inventory/dev/hosts
   # Add your server IPs
   ```

3. **Test Connectivity:**
   ```bash
   make test-dev
   ```

4. **Deploy:**
   ```bash
   make deploy-dev
   ```

### Option 3: Setup Jenkins CI/CD

1. **Start Jenkins:**
   ```bash
   docker-compose up -d
   ```

2. **Access Jenkins:**
   - Open http://localhost:8080
   - Follow setup wizard

3. **Create Pipeline:**
   - New Item → Pipeline
   - Point to this GitHub repository
   - Use `Jenkinsfile` from repo

4. **Run Pipeline:**
   - Click "Build Now"
   - Watch automated deployment!

---

## 📚 Learn More

### Essential Documentation

- **[README.md](README.md)** - Complete project documentation
- **[SETUP.md](SETUP.md)** - Detailed setup for all environments
- **[QUICKSTART.md](QUICKSTART.md)** - Quick reference guide

### Understanding the Project

#### Inventory Files
- `inventory/local/hosts` - For localhost testing (what you just used)
- `inventory/dev/hosts` - For development servers
- `inventory/prod/hosts` - For production servers

#### Playbooks
- `playbooks/demo.yml` - Local demo (what you just ran)
- `playbooks/deploy.yml` - Application deployment
- `playbooks/setup.yml` - Infrastructure setup
- `playbooks/test.yml` - Validation and testing

#### Roles
- `roles/common/` - Base configuration
- `roles/nginx/` - Web server
- `roles/mysql/` - Database
- `roles/haproxy/` - Load balancer
- `roles/java/`, `roles/nodejs/` - Runtimes

---

## 🛠️ Common Tasks

### Modify the Application

```bash
# Edit the Python app
vim app/app.py

# Redeploy
make demo

# Run the updated app
cd ~/jenkins-ansible-demo && python3 app.py
```

### Add New Features

```bash
# Create a new Ansible role
ansible-galaxy init roles/myrole

# Edit the role
vim roles/myrole/tasks/main.yml

# Add to playbook
vim playbooks/setup.yml
```

### Debug Issues

```bash
# Run with verbose output
ansible-playbook playbooks/demo.yml -vvv

# Check syntax
make syntax-check

# Dry run (see what would change)
ansible-playbook playbooks/demo.yml --check
```

---

## ❓ Troubleshooting

### Issue: "ansible: command not found"

**Solution:**
```bash
# Install Ansible
pip3 install ansible

# Or on macOS
brew install ansible
```

### Issue: "Connection timeout" or "Unreachable"

**Solution:**
- For local testing, use `make test` (uses localhost)
- For remote servers, check inventory file has correct IPs
- Verify SSH access: `ssh user@server-ip`

### Issue: "Permission denied"

**Solution:**
```bash
# For local demo, no sudo needed
ansible-playbook playbooks/demo.yml

# For remote servers, check SSH keys
chmod 400 ~/.ssh/your-key.pem
```

### Need More Help?

- Check [README.md](README.md) Troubleshooting section
- Open an issue: https://github.com/atulkamble/jenkins-ansible-project/issues
- Read [Ansible Docs](https://docs.ansible.com/)

---

## 🎓 Learning Resources

### Ansible Basics
- [Ansible Getting Started](https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html)
- [Playbooks Introduction](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)
- [Ansible Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

### Jenkins CI/CD
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Pipeline Tutorial](https://www.jenkins.io/doc/book/pipeline/getting-started/)
- [Jenkinsfile Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)

### DevOps Concepts
- Infrastructure as Code (IaC)
- Configuration Management
- Continuous Integration/Continuous Deployment (CI/CD)
- Automation and Orchestration

---

## ✨ You're All Set!

You now have:
- ✅ A working Ansible environment
- ✅ A deployed sample application
- ✅ Understanding of basic concepts
- ✅ Resources to learn more

**Happy Automating! 🚀**

---

**Questions or feedback?**
- GitHub: [@atulkamble](https://github.com/atulkamble)
- Repository: [jenkins-ansible-project](https://github.com/atulkamble/jenkins-ansible-project)
