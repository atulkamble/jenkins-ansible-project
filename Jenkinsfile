pipeline {
    agent any
    
    environment {
        ANSIBLE_HOST_KEY_CHECKING = 'False'
        ANSIBLE_CONFIG = "${WORKSPACE}/ansible.cfg"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from repository...'
                checkout scm
            }
        }
        
        stage('Validate Ansible') {
            steps {
                echo 'Validating Ansible playbooks...'
                sh '''
                    ansible-playbook --syntax-check playbooks/deploy.yml
                    ansible-playbook --syntax-check playbooks/setup.yml
                '''
            }
        }
        
        stage('Ansible Lint') {
            steps {
                echo 'Running Ansible Lint...'
                sh 'ansible-lint playbooks/*.yml || true'
            }
        }
        
        stage('Deploy to Development') {
            steps {
                echo 'Deploying to Development environment...'
                sh '''
                    ansible-playbook -i inventory/dev/hosts \
                    playbooks/deploy.yml \
                    --extra-vars "env=development"
                '''
            }
        }
        
        stage('Test Deployment') {
            steps {
                echo 'Testing deployment...'
                sh 'ansible-playbook -i inventory/dev/hosts playbooks/test.yml'
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Deploy'
                echo 'Deploying to Production environment...'
                sh '''
                    ansible-playbook -i inventory/prod/hosts \
                    playbooks/deploy.yml \
                    --extra-vars "env=production"
                '''
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
        always {
            cleanWs()
        }
    }
}
