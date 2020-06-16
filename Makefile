include .env
export

# Set env vars for terraform
export TF_VAR_vpc_id=${AWS_VPC_ID}
export TF_VAR_region=${AWS_DEFAULT_REGION}
export TF_VAR_project_name=${PROJECT_NAME}
export TF_VAR_bucket_name=${VERDACCIO_S3_BUCKET}
export TF_VAR_instance_type=${VERDACCIO_EC2_INSTANCE_TYPE}

vagrant-provision:
	@echo "[+] Creating virtual machine"
	cd vagrant && vagrant up --provision

vagrant-destroy:
	@echo "[+] destroying virtual machine"
	cd vagrant && vagrant destroy verdaccio


vagrant-ssh:
	@echo "[+] creating virtual machine"
	cd vagrant && vagrant ssh

ansible-galaxy:
	@echo "[+] Installing dependencies from Ansible Galaxy"
	cd ansible && ansible-galaxy install -r requirements.yml

ansible-verdaccio:
	@echo "[+] Provisioning verdaccio"
	cd terraform ; \
		terraform output ssh_private_pem > ../sshkey.pem ; \
		chmod 600 ../sshkey.pem
	@VERDACCIO_IP_ADDR=$$(cd terraform; terraform output | grep public_ip_addr | cut -d " " -f 3); \
		cd ansible ; \
		echo "$${VERDACCIO_IP_ADDR}" ; \
		ansible-playbook -i "$${VERDACCIO_IP_ADDR}", --key-file ../sshkey.pem --user ubuntu verdaccio.yml

tf-apply:
	@echo "[+] Applying terraform..."
	cd terraform; terraform init; terraform apply

tf-output:
	cd terraform; terraform output

tf-destroy:
	@echo "[+] Applying terraform..."
	cd terraform; terraform destroy

# VERDACCIO_IP_ADDR=3.229.226.121 make pytest-verdaccio
pytest-verdaccio:
	@echo "[+] Running verdaccio service tests"
	cd tests && pytest verdaccio_test.py
	
pytest-terraform:
	@echo "[+] Running verdaccio service tests"
	cd tests && pytest infra_test.py

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
