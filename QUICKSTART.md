# Quick Start Guide

## ✅ Project Successfully Created!

Your Jenkins-Ansible project is now ready for local testing and can be configured for remote deployments.

## 🎯 Current Status

✅ Project structure created
✅ Local testing configured (using localhost)
✅ Syntax validation passed
✅ Connectivity test passed

## 🚀 Quick Commands

### Test Project Locally
```bash
# Test connectivity (localhost)
make test

# Check playbook syntax
make syntax-check

# View all available commands
make help
```

### Expected Output
```
Testing local connectivity...
ansible all -i inventory/local/hosts -m ping
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

## 📁 Project Structure
```
jenkins-ansible-project/
├── Jenkinsfile              # Jenkins CI/CD pipeline
├── ansible.cfg              # Ansible configuration
├── Makefile                 # Quick commands
├── inventory/
│   ├── local/hosts         # Local testing (active)
│   ├── dev/hosts           # Development servers
│   └── prod/hosts          # Production servers
├── playbooks/
│   ├── deploy.yml          # Application deployment
│   ├── setup.yml           # Infrastructure setup
│   └── test.yml            # Testing & validation
├── roles/                   # Ansible roles
│   ├── common/
│   ├── nginx/
│   ├── java/
│   ├── nodejs/
│   ├── mysql/
│   └── haproxy/
├── app/                     # Sample application
└── docs/                    # Setup guides
```

## 🔧 Next Steps

### Option 1: Continue with Local Testing
```bash
# Run test playbook locally
ansible-playbook -i inventory/local/hosts playbooks/test.yml

# Test specific roles
ansible-playbook playbooks/setup.yml --tags common --check
```

### Option 2: Setup Real Servers

#### For AWS EC2:
1. Read `docs/AWS_SETUP.md`
2. Launch EC2 instances
3. Update `inventory/dev/hosts` with real IPs
4. Test with `make test-dev`

#### For Vagrant VMs:
1. Install Vagrant: `brew install vagrant virtualbox`
2. Copy `docs/Vagrantfile.example` to project root as `Vagrantfile`
3. Start VMs: `vagrant up`
4. Update inventory with Vagrant IPs

#### For Docker:
```bash
# Start Jenkins & Ansible containers
docker-compose up -d

# Access Jenkins
open http://localhost:8080
```

## 📚 Documentation

- **SETUP.md** - Complete setup guide for all environments
- **docs/AWS_SETUP.md** - AWS EC2 specific instructions
- **docs/Vagrantfile.example** - Vagrant configuration
- **README.md** - Full project documentation

## 🧪 Testing Your Changes

### Syntax Check
```bash
make syntax-check
```

### Dry Run (Check Mode)
```bash
ansible-playbook -i inventory/local/hosts playbooks/deploy.yml --check
```

### Verbose Output
```bash
ansible-playbook -i inventory/local/hosts playbooks/test.yml -vvv
```

## 🛠️ Customization

### Add Your Own Servers

Edit `inventory/dev/hosts`:
```ini
[webservers]
your-server.example.com ansible_host=YOUR_IP

[development:vars]
ansible_user=YOUR_USER
ansible_ssh_private_key_file=~/.ssh/YOUR_KEY
```

### Test Connectivity
```bash
make test-dev
```

## 🔐 Security Notes

- SSH keys are in `.gitignore`
- Never commit credentials
- Use Ansible Vault for secrets:
  ```bash
  ansible-vault create secrets.yml
  ```

## 🐛 Troubleshooting

### "Connection timeout" errors?
→ Your inventory points to non-existent servers
→ Solution: Use local inventory or setup real servers (see SETUP.md)

### "Permission denied" errors?
→ Check SSH key permissions: `chmod 400 ~/.ssh/your-key.pem`
→ Verify SSH access: `ssh -i ~/.ssh/your-key.pem user@server`

### "Module not found" errors?
→ Install requirements: `make install`

## 💡 Tips

1. **Always test locally first**: Use `make test` before remote deployments
2. **Use check mode**: Add `--check` to see what would change
3. **Enable verbose mode**: Add `-vvv` for detailed debugging
4. **Keep inventory updated**: Document server changes
5. **Use tags**: Run specific parts: `--tags nginx`

## 🎓 Learning Resources

- [Ansible Documentation](https://docs.ansible.com/)
- [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
- [Best Practices](https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html)

## 🆘 Need Help?

Check these files:
1. `SETUP.md` - Environment setup
2. `docs/AWS_SETUP.md` - AWS specific help
3. `README.md` - Full documentation

Run with verbose output:
```bash
ansible-playbook -i inventory/local/hosts playbooks/test.yml -vvv
```

## ✨ Success Criteria

- [x] Project created
- [x] Dependencies installed
- [x] Syntax validation passed
- [x] Local connectivity working
- [ ] Remote servers configured (optional)
- [ ] Jenkins pipeline configured (optional)
- [ ] First deployment completed (optional)

---

**You're all set!** Start with local testing or configure remote servers using the guides in `docs/`.
