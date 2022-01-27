ifndef VERBOSE
.SILENT:
endif

IMAGE=dfedigital/find-teacher-training:${IMAGE_TAG}

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z\.\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build docker image; make build [IMAGE_TAG=<docker image tag>]
		docker-compose build

.PHONY: webpacker-compile
webpacker-compile: ## Run webpack
		docker run --rm ${IMAGE} rails webpacker:compile

.PHONY: rubocop
rubocop: ## Run ruby linter
		docker run --rm ${IMAGE} rubocop app config lib spec --format clang

.PHONY: lint-sass
lint-sass: ## Run sass linter
		docker run --rm ${IMAGE} scss-lint app/webpacker/styles

.PHONY: brakeman
brakeman: ## Run Brakeman static analysis
		docker run --rm ${IMAGE} brakeman

.PHONY: rspec
rspec: ## Run Ruby tests
		docker-compose run -T -e RAILS_ENV=test --name find-rspec-runner \
		                  web rspec --format RspecJunitFormatter --out rspec-results.xml --format documentation
		test_result=$$?
		docker cp find-rspec-runner:/app/coverage .
		docker cp find-rspec-runner:/app/rspec-results.xml .
		exit ${test_result}

.PHONY: js.test
js.test: ## Run Javascript tests
		docker-compose run -T --name find-yarn-test-runner \
		web /bin/sh -c 'apk add yarn && yarn install --frozen-lockfile && yarn test --coverage'
		test_result=$$?
		docker cp find-yarn-test-runner:/app/coverage .
		exit ${test_result}

.PHONY: shell
shell: ## Shell into the container
		docker run -it --rm ${IMAGE} sh

.PHONY: publish.codeclimate
publish.codeclimate: ## Publish coverage to Code Climate
		curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter
		chmod +x ./cc-test-reporter
		./cc-test-reporter before-build
		# As the tests were run in the docker container the paths to the coverage are prefixed with "/app/"
		# So we need to replace it with the docker hosts current directory
		sed "s|\"/app/|\"`pwd`/|g" coverage/.resultset.json -i
		# Format the two different test coverage formats (SimpleCov anf lcov) to code climates json format
		./cc-test-reporter format-coverage --input-type simplecov --output coverage/rspec.json
		./cc-test-reporter format-coverage --input-type lcov --output coverage/javascript.json
		# Aggregate the two results to form a single result for our code base
		./cc-test-reporter sum-coverage --output 'coverage/total.json' coverage/javascript.json coverage/rspec.json
		# Upload the our test coverage to code climate
		./cc-test-reporter upload-coverage --input coverage/total.json

.PHONY: ci
ci:	## Run in automation
	$(eval export DISABLE_PASSCODE=true)
	$(eval export AUTO_APPROVE=-auto-approve)

.PHONY: review
review: ## Init review environment
	$(eval DEPLOY_ENV=review)
	$(if $(APP_NAME), , $(error Missing environment variable "APP_NAME", Please specify a name for your review app))
	$(eval AZ_SUBSCRIPTION=s121-findpostgraduateteachertraining-development)
	$(eval backend_key=-backend-config=key=pr-$(APP_NAME).tfstate)
	$(eval export TF_VAR_paas_app_environment_config=review)
	$(eval export TF_VAR_paas_app_environment=pr-$(APP_NAME))
	$(eval export TF_VAR_paas_web_app_host_name=$(APP_NAME))
	echo Review app: https://find-pr-$(APP_NAME).london.cloudapps.digital in bat-qa space

.PHONY: qa
qa: ## Set DEPLOY_ENV to qa
	$(eval DEPLOY_ENV=qa)
	$(eval env=qa)
	$(eval AZ_SUBSCRIPTION=s121-findpostgraduateteachertraining-development)
	$(eval SPACE=bat-qa)

.PHONY: staging
staging: ## Set DEPLOY_ENV to staging
	$(eval DEPLOY_ENV=staging)
	$(eval env=staging)
	$(eval AZ_SUBSCRIPTION=s121-findpostgraduateteachertraining-test)
	$(eval SPACE=bat-staging)

.PHONY: production
production: ## Set DEPLOY_ENV to production
	$(if $(CONFIRM_PRODUCTION), , $(error Production can only run with CONFIRM_PRODUCTION))
	$(eval DEPLOY_ENV=production)
	$(eval env=prod)
	$(eval AZ_SUBSCRIPTION=s121-findpostgraduateteachertraining-production)
	$(eval SPACE=bat-prod)
	$(eval HOSTNAME=www)

.PHONY: sandbox
sandbox: ## Set DEPLOY_ENV to production
	$(eval DEPLOY_ENV=sandbox)
	$(eval env=sandbox)
	$(eval AZ_SUBSCRIPTION=s121-findpostgraduateteachertraining-production)
	$(eval SPACE=bat-prod)

.PHONY: deploy-plan
deploy-plan: deploy-init ## Run terraform plan for ${DEPLOY_ENV} eg: make qa plan, make staging plan, make production plan
	cd terraform && . workspace_variables/$(DEPLOY_ENV).sh \
		&& terraform plan -var-file=workspace_variables/$(DEPLOY_ENV).tfvars

deploy-init:
	$(if $(IMAGE_TAG), , $(eval export IMAGE_TAG=main))
	$(if $(or $(DISABLE_PASSCODE),$(PASSCODE)), , $(error Missing environment variable "PASSCODE", retrieve from https://login.london.cloud.service.gov.uk/passcode))
	$(eval export TF_VAR_paas_sso_code=$(PASSCODE))
	$(eval export TF_VAR_paas_app_docker_image=dfedigital/find-teacher-training:$(IMAGE_TAG))
	$(eval export TF_VAR_paas_app_config_file=./workspace_variables/app_config.yml)
	az account set -s ${AZ_SUBSCRIPTION} && az account show
	cd terraform && terraform init -reconfigure -backend-config=workspace_variables/$(DEPLOY_ENV)_backend.tfvars $(backend_key)
	echo "🚀 DEPLOY_ENV is $(DEPLOY_ENV)"

.PHONY: deploy
deploy: deploy-init ## Run terraform apply for ${DEPLOY_ENV} eg: make qa deploy, make staging deploy, make production deploy
	cd terraform && . workspace_variables/$(DEPLOY_ENV).sh \
		&& terraform apply -var-file=workspace_variables/$(DEPLOY_ENV).tfvars $(AUTO_APPROVE)

.PHONY: install-fetch-config
install-fetch-config: ## Install the fetch-config script
	[ ! -f bin/fetch_config.rb ] \
		&& curl -s https://raw.githubusercontent.com/DFE-Digital/bat-platform-building-blocks/master/scripts/fetch_config/fetch_config.rb -o bin/fetch_config.rb \
		&& chmod +x bin/fetch_config.rb \
		|| true

.PHONY: edit-app-secrets
edit-app-secrets: install-fetch-config ## Edit Find App Secrets
	. terraform/workspace_variables/$(DEPLOY_ENV).sh && bin/fetch_config.rb -s azure-key-vault-secret:$${TF_VAR_key_vault_name}/$${TF_VAR_key_vault_app_secret_name} \
		-e -d azure-key-vault-secret:$${TF_VAR_key_vault_name}/$${TF_VAR_key_vault_app_secret_name} -f yaml -c

.PHONY: print-app-secrets
print-app-secrets: install-fetch-config ## View Find App Secrets
	. terraform/workspace_variables/$(DEPLOY_ENV).sh && bin/fetch_config.rb -s azure-key-vault-secret:$${TF_VAR_key_vault_name}/$${TF_VAR_key_vault_app_secret_name} \
		-f yaml
.PHONY: console ## start a rails console, eg: make qa console
console:
	cf target -s ${SPACE}
	cf ssh find-${env} -t -c "cd /app && /usr/local/bin/bundle exec rails c"

.PHONY: destroy ## terraform destroy
destroy: deploy-init
	cd terraform && . workspace_variables/$(DEPLOY_ENV).sh \
		&& terraform destroy -var-file=workspace_variables/$(DEPLOY_ENV).tfvars $(AUTO_APPROVE)

enable-maintenance: ## make qa enable-maintenance / make prod enable-maintenance CONFIRM_PRODUCTION=y
	$(if $(HOSTNAME), $(eval REAL_HOSTNAME=${HOSTNAME}), $(eval REAL_HOSTNAME=${DEPLOY_ENV}))
	cf target -s ${SPACE}
	cd service_unavailable_page && cf push
	cf map-route find-unavailable find-postgraduate-teacher-training.service.gov.uk --hostname ${REAL_HOSTNAME}
	echo Waiting 5s for route to be registered... && sleep 5
	cf unmap-route find-${DEPLOY_ENV} find-postgraduate-teacher-training.service.gov.uk --hostname ${REAL_HOSTNAME}

disable-maintenance: ## make qa disable-maintenance / make prod disable-maintenance CONFIRM_PRODUCTION=y
	$(if $(HOSTNAME), $(eval REAL_HOSTNAME=${HOSTNAME}), $(eval REAL_HOSTNAME=${DEPLOY_ENV}))
	cf target -s ${SPACE}
	cf map-route find-${DEPLOY_ENV} find-postgraduate-teacher-training.service.gov.uk --hostname ${REAL_HOSTNAME}
	echo Waiting 5s for route to be registered... && sleep 5
	cf unmap-route find-unavailable find-postgraduate-teacher-training.service.gov.uk --hostname ${REAL_HOSTNAME}
	cf delete -rf find-unavailable
