include .env

# Set env vars for terraform
export TF_VAR_bucket_name=${VERDACCIO_S3_BUCKET}
export TF_VAR_ssh_key_name=${TF_SSH_KEY_NAME}
export TF_VAR_ec2_subnet_id=${TF_EC2_SUBNET_ID}
export TF_VAR_ec2_sg_id=${TF_EC2_SG_ID}

tf-destroy:
	@echo "[+] Applying terraform..."
	cd infra; terraform destroy

tf-apply:
	@echo "[+] Applying terraform..."
	cd infra; terraform apply

docker-run:
	@echo "[+] Docker compose starting..."
	docker-compose up -d
