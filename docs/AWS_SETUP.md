# AWS EC2 Setup Guide

## 🚀 Launch EC2 Instances

### Using AWS Console

1. **Go to EC2 Dashboard** → Launch Instance

2. **Configure Instances**:
   - **AMI**: Ubuntu Server 22.04 LTS
   - **Instance Type**: 
     - Web Servers: t2.micro (2)
     - App Servers: t2.small (2)
     - Database: t2.small (1)
     - Load Balancer: t2.micro (1)
   - **Key Pair**: Create or select existing
   - **Network**: Default VPC or create new

3. **Security Group Configuration**:

   **Web Servers Security Group**:
   ```
   SSH (22)      - Your IP
   HTTP (80)     - 0.0.0.0/0
   HTTPS (443)   - 0.0.0.0/0
   ```

   **App Servers Security Group**:
   ```
   SSH (22)      - Your IP
   Custom (8080) - Web Servers SG
   ```

   **Database Security Group**:
   ```
   SSH (22)      - Your IP
   MySQL (3306)  - App Servers SG
   ```

   **Load Balancer Security Group**:
   ```
   SSH (22)      - Your IP
   HTTP (80)     - 0.0.0.0/0
   HTTPS (443)   - 0.0.0.0/0
   ```

4. **Launch Instances** with appropriate tags:
   ```
   Name: web1-dev
   Environment: development
   Role: webserver
   ```

### Using AWS CLI

```bash
# Set variables
KEY_NAME="ansible-key"
REGION="us-east-1"
AMI_ID="ami-0c7217cdde317cfec"  # Ubuntu 22.04 LTS

# Create key pair
aws ec2 create-key-pair \
  --key-name $KEY_NAME \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/${KEY_NAME}.pem
chmod 400 ~/.ssh/${KEY_NAME}.pem

# Create security groups
WEB_SG=$(aws ec2 create-security-group \
  --group-name web-servers-sg \
  --description "Web servers security group" \
  --query 'GroupId' --output text)

APP_SG=$(aws ec2 create-security-group \
  --group-name app-servers-sg \
  --description "App servers security group" \
  --query 'GroupId' --output text)

DB_SG=$(aws ec2 create-security-group \
  --group-name db-servers-sg \
  --description "Database servers security group" \
  --query 'GroupId' --output text)

# Configure security group rules
aws ec2 authorize-security-group-ingress \
  --group-id $WEB_SG \
  --protocol tcp --port 22 --cidr $(curl -s ifconfig.me)/32

aws ec2 authorize-security-group-ingress \
  --group-id $WEB_SG \
  --protocol tcp --port 80 --cidr 0.0.0.0/0

# Launch instances
# Web Server 1
aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type t2.micro \
  --key-name $KEY_NAME \
  --security-group-ids $WEB_SG \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=web1-dev},{Key=Role,Value=webserver}]'

# Repeat for other instances...
```

### Using Terraform

See `terraform/` directory for Infrastructure as Code approach.

## 📝 Update Ansible Inventory

After launching instances, get their public IPs:

```bash
# List instances
aws ec2 describe-instances \
  --filters "Name=tag:Environment,Values=development" \
  --query 'Reservations[*].Instances[*].[Tags[?Key==`Name`].Value|[0],PublicIpAddress,PrivateIpAddress]' \
  --output table
```

Update `inventory/dev/hosts`:

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
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/ansible-key.pem
ansible_become=yes
env=development
```

## 🔧 Initial Server Setup

```bash
# Test connectivity with ubuntu user (default)
ansible all -i inventory/dev/hosts -m ping -u ubuntu

# Create ansible user on all servers
ansible all -i inventory/dev/hosts -u ubuntu -b -m user \
  -a "name=ansible shell=/bin/bash create_home=yes groups=sudo"

# Setup sudo without password
ansible all -i inventory/dev/hosts -u ubuntu -b -m copy \
  -a "content='ansible ALL=(ALL) NOPASSWD:ALL' dest=/etc/sudoers.d/ansible mode=0440"

# Copy SSH key to ansible user
ansible all -i inventory/dev/hosts -u ubuntu -b -m authorized_key \
  -a "user=ansible key='{{ lookup('file', '~/.ssh/ansible-key.pem.pub') }}' state=present"

# Update inventory to use ansible user
# Change ansible_user=ubuntu to ansible_user=ansible in inventory/dev/hosts
```

## 🧪 Verify Setup

```bash
# Test with ansible user
ansible all -i inventory/dev/hosts -m ping

# Test sudo
ansible all -i inventory/dev/hosts -m command -a "sudo whoami" -b

# Gather facts
ansible all -i inventory/dev/hosts -m setup -a "filter=ansible_distribution*"
```

## 💰 Cost Optimization

### Use Spot Instances

```bash
# Launch spot instance
aws ec2 request-spot-instances \
  --spot-price "0.0116" \
  --instance-count 1 \
  --type "one-time" \
  --launch-specification file://spot-specification.json
```

### Auto-shutdown Schedule

```bash
# Stop instances at night (using CloudWatch Events)
aws events put-rule \
  --name stop-dev-instances \
  --schedule-expression "cron(0 22 * * ? *)"
```

### Cleanup

```bash
# Terminate all development instances
aws ec2 terminate-instances \
  --instance-ids $(aws ec2 describe-instances \
    --filters "Name=tag:Environment,Values=development" \
    --query 'Reservations[*].Instances[*].InstanceId' \
    --output text)

# Delete security groups
aws ec2 delete-security-group --group-id $WEB_SG
aws ec2 delete-security-group --group-id $APP_SG
aws ec2 delete-security-group --group-id $DB_SG
```

## 🔐 Security Hardening

### Enable CloudWatch Monitoring

```bash
aws ec2 monitor-instances --instance-ids i-1234567890abcdef0
```

### Setup AWS Systems Manager Session Manager

```bash
# Attach IAM role for SSM
aws iam attach-role-policy \
  --role-name EC2-SSM-Role \
  --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore
```

### Enable VPC Flow Logs

```bash
aws ec2 create-flow-logs \
  --resource-type VPC \
  --resource-ids vpc-xxxxx \
  --traffic-type ALL \
  --log-destination-type cloud-watch-logs \
  --log-group-name /aws/vpc/flowlogs
```

## 📊 Monitoring

### CloudWatch Alarms

```bash
# CPU utilization alarm
aws cloudwatch put-metric-alarm \
  --alarm-name web1-high-cpu \
  --alarm-description "Alert when CPU exceeds 80%" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2
```

## 🌐 Domain Configuration

### Route53 DNS Setup

```bash
# Create hosted zone
aws route53 create-hosted-zone \
  --name dev.example.com \
  --caller-reference $(date +%s)

# Create A records
aws route53 change-resource-record-sets \
  --hosted-zone-id Z1234567890ABC \
  --change-batch file://dns-changes.json
```

## 📦 AMI Creation

After configuration, create custom AMI:

```bash
# Create AMI from configured instance
aws ec2 create-image \
  --instance-id i-1234567890abcdef0 \
  --name "ansible-managed-ubuntu-$(date +%Y%m%d)" \
  --description "Pre-configured Ubuntu with Ansible user"
```
