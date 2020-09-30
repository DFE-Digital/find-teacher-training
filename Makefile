IMAGE=${DOCKER_IMAGE}

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z\.\-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

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
		docker run --name find-rspec-runner ${IMAGE} \
		                  rails spec SPEC_OPTS='--format RspecJunitFormatter --out rspec-results.xml'
		test_result=$$?
		docker cp find-rspec-runner:/app/coverage .
		docker cp find-rspec-runner:/app/rspec-results.xml .
		exit ${test_result}

.PHONY: js.test
js.test: ## Run Javascript tests
		docker run --name find-yarn-test-runner ${IMAGE} yarn test --coverage
		test_result=$$?
		docker cp find-yarn-test-runner:/app/coverage .
		exit ${test_result}

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
