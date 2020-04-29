include .env

# Set env vars for terraform
export TF_VAR_bucket_name=${VERDACCIO_S3_BUCKET}
export TF_VAR_ssh_private_key=${TF_SSH_PRIVATE_KEY}
export TF_VAR_ssh_public_key=${TF_SSH_PUBLIC_KEY}
export TF_VAR_ec2_subnet_id=${TF_EC2_SUBNET_ID}
export TF_VAR_ec2_sg_id=${TF_EC2_SG_ID}

tf-destroy:
	@echo "[+] Applying terraform..."
	cd infra; terraform destroy

tf-apply:
	@echo "[+] Applying terraform..."
	cd infra; terraform init; terraform apply

tf-output:
	cd infra; terraform output

docker-run:
	@echo "[+] Docker compose starting..."
	docker-compose up -d
	@echo "Done."

docker-stop:
	@echo "[+] Docker compose stopping..."
	docker-compose stop
	@echo "Done."

htpasswd:
	@echo "[+] Generating httpasswd..."
	@htpasswd -Bbn ${HTPASSWD_USER} ${HTPASSWD_PASSWORD} > ./conf/htpasswd
	@echo "Done."
