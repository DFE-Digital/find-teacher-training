[![Build Status](https://dfe-ssp.visualstudio.com/Become-A-Teacher/_apis/build/status/Find/find-teacher-training?branchName=master)](https://dfe-ssp.visualstudio.com/Become-A-Teacher/_build/latest?definitionId=296&branchName=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/f97679a5f6ddaa3f8981/maintainability)](https://codeclimate.com/github/DFE-Digital/find-teacher-training/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f97679a5f6ddaa3f8981/test_coverage)](https://codeclimate.com/github/DFE-Digital/find-teacher-training/test_coverage)

# Find Teacher Training

## Prerequisites

- Ruby 2.6.5
- NodeJS 12.16.x
- Yarn 1.12.x

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

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec rubocop app config lib spec Gemfile --format clang -a

or

bundle exec scss-lint app/webpacker/styles
```

## End of cycle feature flags

We use terraform to deploy and configure the application.
Application configuration variables and feature flags are configured for each environment in the [app_config.yml](/terraform/workspace_variables/app_config.yml) file.

### Enable ‘Nearing end of cycle’ interim page
Turning this flag on redirects requests from `/` to `/cycle-ending-soon`.

To enable this feature locally, add the following to `config/settings/development.local.yml`

```yaml
cycle_ending_soon: true
```

To enable this feature on a deployed environment, the following environment variable needs to be updated to `true` in [app_config.yml](/terraform/workspace_variables/app_config.yml)

```
SETTINGS__CYCLE_ENDING_SOON
```

### Disable ‘Apply for this course’ button
Turning this flag off removes the ‘Apply for this course button’ on each course listing.

To disable this feature locally, add the following to `config/settings/development.local.yml`

```yaml
display_apply_button: false
```

To disable this feature on a deployed environment, the following environment variable needs to be updated to `false` in [app_config.yml](/terraform/workspace_variables/app_config.yml)

```
SETTINGS__DISPLAY_APPLY_BUTTON
```

### Enable ‘Cycle has ended’ interim page 

Turning this flag on redirects all home, search, results and course page requests to `/cycle-has-ended`.

To enable this feature locally, add the following to `config/settings/development.local.yml`

```yaml
cycle_has_ended: true
```

To enable this feature on a deployed environment, the following environment variable needs to be updated to `true` in the [app_config.yml](/terraform/workspace_variables/app_config.yml)

```
SETTINGS__CYCLE_HAS_ENDED
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
