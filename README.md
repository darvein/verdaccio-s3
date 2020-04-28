# Verdaccio with AWS S3 storage backend

## What requirements?

Requirements for deployment:

- AWS Account and access key credentials

Requirements for development:

- Docker cli installed
- Docker compose
- Terraform

## What we'll get?

- Verdaccio deploy with docker-compose as the orchestrator
- Nginx frontend for Verdaccio on port tcp/80

## Limitations

- Verdaccio will only work with AWS S3 backend as a storage
- Authentication to Verdaccio is a single user defined in the .env file which will generate a htpasswd file.

## How to use it?

Most of the work is automated with a Makefile that makes all the work for you, you just need to provide some configurations in the `.env` file which needs to be created from `.env.example`.

Note that for development purposes you have to provide your AWS Credentials in the .env file so Docker will know how to reach the AWS S3 bucket. In case you want to run Verdaccio locally, otherwise leave the AWS Creds variables empty so when the app is deployed on AWS EC2 it will access S3 via a IAM Role.


## TODO

- Implement Let's Encrypt SSL certificate to nginx and domain name support.
- Move verdaccio s3 docker image to docker registry, stop building it during deploy.
- The IAM Role should only have access to the verdaccio s3 bucket, nothing else.
