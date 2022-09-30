############################
#       VARIABLES          #
############################
ENV = env
TERRAFORM = `terraform -v | sed -n 's/^Terraform v//p'`
TERRAFORM_VERSION = "1.2.6"
TERRAFORM_PROJECT_NAME = project
 
############################
#       ENVIRONMENTS       #
############################
dev01: 
	$(eval ENV=dev01)
 
############################
#       TARGETS            #
############################ 
check-config:
aws_region =$(shell cat ../env/${ENV}/variables.tfvars | grep aws_region | awk '{print $$3}' | sed 's/\"//g')
profile =$(shell cat ../env/${ENV}/variables.tfvars | grep profile | awk '{print $$3}' | sed 's/\"//g')
TERRAFORM_PROJECT_NAME = $(shell cat ../env/${ENV}/variables.tfvars | grep project | awk '{print $$3}' | sed 's/\"//g')

check-version:
	@if [ "${TERRAFORM}" != "${TERRAFORM_VERSION}" ] ; then \
		 echo "You're not running required version of Terraform which is V${TERRAFORM_VERSION} please download from https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/"; \
		 exit 1; \
	fi
 
init:
	@if [ "${ENV}" = "local" ]; then \
		echo "terraform {">backend.tf; \
		echo " backend \"local\" {">>backend.tf; \
		echo "    path=\"../data/${ENV}/${TERRAFORM_PROJECT_NAME}/terraform.tfstate\" ">>backend.tf; \
		echo "  }">>backend.tf; \
		echo "}">>backend.tf; \
		SUFFIX='-backend-config=path="../data/${ENV}/${TERRAFORM_PROJECT_NAME}/terraform.tfstate" -backend=true'; \
	else \
		echo "terraform {">backend.tf; \
		echo " backend \"s3\" {">>backend.tf; \
		echo "    bucket=\"rm-tfstate-${ENV}\" ">>backend.tf; \
		echo "    key=\"${ENV}/${TERRAFORM_PROJECT_NAME}/terraform.tfstate\" ">>backend.tf; \
		echo "    region=\"${aws_region}\" ">>backend.tf; \
		echo "    profile=\"${profile}\" ">>backend.tf; \
		echo "    dynamodb_table=\"TerraformStateLock\" ">>backend.tf; \
		echo "  }">>backend.tf; \
		echo "}">>backend.tf; \
		SUFFIX="-backend-config=backend=s3 -backend-config=bucket=rm-tfstate-${ENV} -backend-config=region=${aws_region}  -backend-config=profile=${profile}  -backend-config=key=${ENV}/${TERRAFORM_PROJECT_NAME}/terraform.tfstate -backend=true"; \
	fi

	@terraform -chdir=../terraform/ init -reconfigure \
			  -var-file=../env/${ENV}/variables.tfvars \
			  ${SUFFIX}
 
 apply:
	@terraform -chdir=../terraform/ apply -auto-approve  \
 		-var-file=../env/${ENV}/variables.tfvars
	@echo "">backend.tf;

 destroy:
	@terraform -chdir=../terraform/ destroy  \
 		-var-file=../env/${ENV}/variables.tfvars 
	@echo "">backend.tf;
	
#######################
#  TERRAFORM ACTIONS  #
#######################
# dev01: check-version check-config init apply
#stg: check-version init apply
#prod: check-version init apply
deploy: check-version check-config init apply
undeploy: check-version check-config init destroy

