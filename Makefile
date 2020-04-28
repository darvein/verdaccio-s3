#include .env
#export

tf-apply:
	@echo "[+] Applying terraform"
	cd infra; \
		source .env \
		TF_VAR_bucket_name=${VERDACCIO_S3_BUCKET} \
		TF_VAR_ssh_key_name=${TF_SSH_KEY_NAME} \
		TF_VAR_ec2_subnet_id=${TF_EC2_SUBNET_ID} \
		TF_VAR_ec2_sg_id=${TF_EC2_SG_ID} \
		terraform apply

tf-destroy:
	@echo "[+] Destroying terraform"
	cd infra; terraform destroy
