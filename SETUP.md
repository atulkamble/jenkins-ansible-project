# Setup Guide for Jenkins-Ansible Project

## 📋 Quick Start (Local Testing)

The project is pre-configured for local testing on your machine.

### Test Local Setup

```bash
# Test connectivity (uses localhost)
make test

# Or use the local inventory explicitly
ansible all -i inventory/local/hosts -m ping
```

## 🖥️ Configuring for Remote Servers

### Option 1: AWS EC2 Instances

1. **Launch EC2 Instances** in AWS Console:
   - 2 Web Servers (Ubuntu 22.04)
   - 2 App Servers (Ubuntu 22.04)
   - 1 Database Server (Ubuntu 22.04)
   - 1 Load Balancer (Ubuntu 22.04)

2. **Configure Security Groups**:
   ```
   - SSH (22) - From your IP
   - HTTP (80) - From anywhere
   - HTTPS (443) - From anywhere
   - Custom TCP (8080) - App servers
   - MySQL (3306) - Between app and DB servers only
   ```

3. **Setup SSH Access**:
   ```bash
   # Copy your EC2 key pair
   cp ~/Downloads/your-key.pem ~/.ssh/ec2-key.pem
   chmod 400 ~/.ssh/ec2-key.pem
   
   # Test SSH connection
   ssh -i ~/.ssh/ec2-key.pem ubuntu@<EC2-IP>
   ```

4. **Create Ansible User on Each Server**:
   ```bash
   # SSH into each server and run:
   sudo useradd -m -s /bin/bash ansible
   sudo usermod -aG sudo ansible
   echo "ansible ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ansible
   
   # Setup SSH key
   sudo mkdir -p /home/ansible/.ssh
   sudo cp ~/.ssh/authorized_keys /home/ansible/.ssh/
   sudo chown -R ansible:ansible /home/ansible/.ssh
   sudo chmod 700 /home/ansible/.ssh
   sudo chmod 600 /home/ansible/.ssh/authorized_keys
   ```

5. **Update Inventory File**:
   ```bash
   # Edit inventory/dev/hosts
   vim inventory/dev/hosts
   ```
   
   Replace localhost entries with your EC2 public IPs:
   ```ini
   [webservers]
   web1.dev.example.com ansible_host=54.123.45.67
   web2.dev.example.com ansible_host=54.123.45.68
   
   [appservers]
   app1.dev.example.com ansible_host=54.123.45.69
   app2.dev.example.com ansible_host=54.123.45.70
   
   [databases]
   db1.dev.example.com ansible_host=54.123.45.71
   
   [loadbalancers]
   lb1.dev.example.com ansible_host=54.123.45.72
   
   [development:vars]
   ansible_user=ansible
   ansible_ssh_private_key_file=~/.ssh/ec2-key.pem
   env=development
   ```

6. **Test Connection**:
   ```bash
   ansible all -i inventory/dev/hosts -m ping
   ```

### Option 2: Vagrant Virtual Machines

1. **Install Vagrant and VirtualBox**:
   ```bash
   brew install vagrant virtualbox
   ```

2. **Create Vagrantfile**:
   ```ruby
   # See docs/Vagrantfile.example for complete config
   ```

3. **Start VMs**:
   ```bash
   vagrant up
   ```

4. **Update Inventory**:
   ```bash
   # Edit inventory/dev/hosts with Vagrant IPs
   # Usually 192.168.56.10, 192.168.56.11, etc.
   ```

### Option 3: Docker Containers

1. **Use Docker Compose for SSH-enabled containers**:
   ```bash
   # Start infrastructure containers
   docker-compose -f docker-compose.infra.yml up -d
   ```

2. **Update Inventory**:
   ```bash
   # Use container names or IPs from docker network
   ```

## 🔑 SSH Key Setup

### Generate SSH Key Pair

```bash
# Generate new SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_rsa -C "ansible@jenkins"

# Copy public key to servers
ssh-copy-id -i ~/.ssh/ansible_rsa.pub ansible@<server-ip>
```

### Update Ansible Configuration

Edit `inventory/dev/hosts`:
```ini
[development:vars]
ansible_user=ansible
ansible_ssh_private_key_file=~/.ssh/ansible_rsa
```

## 🧪 Testing Your Setup

### Step 1: Test Connectivity
```bash
ansible all -i inventory/dev/hosts -m ping
```

### Step 2: Test Privilege Escalation
```bash
ansible all -i inventory/dev/hosts -m command -a "sudo whoami" -b
```

### Step 3: Gather Facts
```bash
ansible all -i inventory/dev/hosts -m setup | less
```

### Step 4: Check Syntax
```bash
make syntax-check
```

### Step 5: Run in Check Mode (Dry Run)
```bash
ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml --check
```

## 🚀 Deployment Workflow

### Development Environment

```bash
# 1. Setup infrastructure
make setup-dev

# 2. Deploy application
make deploy-dev

# 3. Run tests
ansible-playbook -i inventory/dev/hosts playbooks/test.yml
```

### Production Environment

```bash
# 1. Setup infrastructure
make setup-prod

# 2. Deploy application (requires approval)
make deploy-prod

# 3. Verify deployment
ansible-playbook -i inventory/prod/hosts playbooks/test.yml
```

## 🔧 Troubleshooting

### Connection Timeout
```bash
# Check if server is reachable
ping <server-ip>

# Check SSH connectivity
ssh -vvv -i ~/.ssh/ansible_rsa ansible@<server-ip>

# Check firewall rules
# On server:
sudo ufw status
```

### Permission Denied
```bash
# Verify SSH key permissions
chmod 400 ~/.ssh/ansible_rsa

# Verify ansible user exists on server
ssh -i ~/.ssh/ansible_rsa ansible@<server-ip> whoami
```

### Ansible Module Failures
```bash
# Run with verbose output
ansible-playbook -i inventory/dev/hosts playbooks/deploy.yml -vvv

# Check Python version on target
ansible all -i inventory/dev/hosts -m command -a "python3 --version"
```

## 📊 Monitoring Deployment

### View Logs
```bash
# On target servers
sudo journalctl -u myapp -f

# Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Check Service Status
```bash
ansible webservers -i inventory/dev/hosts -m service -a "name=nginx state=started" -b
```

## 🔐 Security Best Practices

1. **Never commit private keys to Git**
2. **Use Ansible Vault for secrets**:
   ```bash
   ansible-vault create group_vars/all/vault.yml
   ```
3. **Rotate SSH keys regularly**
4. **Use bastion hosts for production**
5. **Implement IP whitelisting**

## 📚 Next Steps

1. Configure Jenkins pipeline
2. Setup CI/CD automation
3. Implement monitoring with Prometheus/Grafana
4. Add backup and restore procedures
5. Document disaster recovery process

## 🆘 Getting Help

- Check `README.md` for general documentation
- Review playbook comments for specific roles
- Enable verbose mode: `-vvv`
- Check Ansible logs: `/var/log/ansible.log`
