[![Build Status](https://dfe-ssp.visualstudio.com/Become-A-Teacher/_apis/build/status/Find/find-teacher-training?branchName=master)](https://dfe-ssp.visualstudio.com/Become-A-Teacher/_build/latest?definitionId=296&branchName=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/f97679a5f6ddaa3f8981/maintainability)](https://codeclimate.com/github/DFE-Digital/find-teacher-training/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f97679a5f6ddaa3f8981/test_coverage)](https://codeclimate.com/github/DFE-Digital/find-teacher-training/test_coverage)

# Find Teacher Training

## Prerequisites

- Ruby 2.7.2
- NodeJS 12.18.x
- Yarn 1.22.x

## Using asdf-vm to manage tool versions

The `.tool-version` file in the root of the repository is used to specify the runtime versions of ruby and node.
1. Download and install asdf-vm [🔗](https://asdf-vm.com/#/core-manage-asdf)
2. Install ruby and node plugins

    >```
    > asdf plugin add ruby
    > asdf plugin add nodejs
    >```

3. Then run `asdf install` to install the ruby and node versions specified in the `.tool-versions` file.

## Setting up the app in development

1. Run `bundle install` to install the gem dependencies
2. Run `yarn` to install node dependencies
3. Run `bundle exec rails server` to launch the app on http://localhost:3002

## Running specs, linter(without auto correct) and annotate models and serializers

```
bundle exec rake
```

## Running specs

```
bundle exec rspec
```

## Deploying

Application is hosted on [GOV.UK PaaS](https://www.cloud.service.gov.uk) and every merged PR is continuously deployed to Production.
- [Deployment Workflow](/docs/deployment.md)
- [Getting started with PaaS](/docs/paas.md)

## Linting

### Rubocop

We inherit the Rubocop config from [Apply for teacher training](https://github.com/DFE-Digital/apply-for-teacher-training).
To pull the latest version, run `bundle exec rake rubocop:copy_config_from_apply`. Then to run Rubocop:

```bash
bundle exec rubocop -a
```

(`-a` will auto-correct violations where possible)

### SCSS

```bash
bundle exec scss-lint app/webpacker/styles
```

## Application Secrets

Secrets like API keys and tokens are configured in a YAML file and stored as `base64` encoded string in GitHub secrets.
```yaml
SENTRY_DSN: xxx
SETTINGS__GOOGLE__GCP_API_KEY : xxx
SETTINGS__GOOGLE__MAPS_API_KEY : xxx
SETTINGS__SKYLIGHT_AUTH_TOKEN: xxx
```
The above yaml file is populated with values for each environment and the output of the below command is stored in GitHub secrets as `APP_SECRETS_QA`, or `APP_SECRETS_STAGING` or `APP_SECRETS_PRODUCTION` respectively.
```shell
base64 -w0 app_secrets.yml
```
Note: This process will soon be moved to Azure keyVault for easier management of secrets.
