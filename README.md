# Verdaccio with AWS S3 storage backend

Verdaccio is a popular NPM Private registry service that can be used in a variaty of combinations. This repository uses it with Docker and AWS S3 + HTTP Authentication.

## Pre-requisites

You will need to have:

- An AWS Account
- Vagrant installed
- Ansible installed
- Terraform CLI installed

Make sure you have configured valid credentials on your shell session.

## Development with Vagrant

Virtualbox machine setup with Verdaccio  provided by Ansible
```
vagrant-provision
vagrant-ssh
```

## Verdaccio configuration with Ansible
Ansible playbooks exeuction for Verdaccio, NGINX and NodeJS setup
```
ansible-galaxy
ansible-verdaccio
```

## Infrastructure deployment
Infrastructure deployment on AWS Cloud provider. Simply an EC2 instance, an EIP and a S3 Bucket.
```
tf-apply
tf-output
tf-destroy
```

## Testing
Python testing of Verdaccio service and the AWS Infra itself
```
pytest-verdaccio
pytest-terraform
```

