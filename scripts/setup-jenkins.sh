#!/bin/bash
# Setup Jenkins with required plugins and configuration

set -e

echo "Setting up Jenkins for Ansible integration..."

# Install required Jenkins plugins
jenkins_cli="java -jar jenkins-cli.jar -s http://localhost:8080/"

plugins=(
    "ansible"
    "git"
    "workflow-aggregator"
    "pipeline-stage-view"
    "ssh-agent"
    "credentials-binding"
)

for plugin in "${plugins[@]}"; do
    echo "Installing plugin: $plugin"
    $jenkins_cli install-plugin "$plugin" || true
done

echo "Restarting Jenkins..."
$jenkins_cli safe-restart

echo "Jenkins setup complete!"
echo "Please configure Ansible in Jenkins: Manage Jenkins > Global Tool Configuration > Ansible"
