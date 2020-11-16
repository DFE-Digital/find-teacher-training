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
3. Run `rake assets:precompile` to precompile the assets
3. Run `bundle exec rails server` to launch the app on http://localhost:3002

## Setting up the Teacher Training API in development

Find pulls data from the Teacher Training API. In order for the search functionality on Find to work you need to setup
and run the Teacher Training API app locally.

1. Go to the the Teacher Training API on GitHub and clone the repo https://github.com/DFE-Digital/teacher-training-api
2. Run `bundle exec rails db:setup` to create a development and testing database.
3. Run  `bundle exec rails server` to launch the Teacher training API app on http://localhost:3001

## Populate the Teacher Training API development database

1. Open the Teacher Training API app and navigate to `config/azure_environments.yml`. Add the following:
  `qa:
    webapp: s121d01-ttapi-as
    rgroup: s121d01-ttapi-rg
    subscription: s121-findpostgraduateteachertraining-development
  staging:
    webapp: s121t01-ttapi-as
    rgroup: s121t01-ttapi-rg
    subscription: s121-findpostgraduateteachertraining-test
  production:
    webapp: s121p01-ttapi-as
    rgroup: s121p01-ttapi-rg
    subscription: s121-findpostgraduateteachertraining-production
`
2. Visit your Azure roles https://portal.azure.com/#blade/Microsoft_Azure_PIMCommon/ActivationMenuBlade/azurerbac and activate yourself as a contributor on `s121-findpostgraduateteachertraining-test`
3. Visit the Staging database connection security permissions https://preview.portal.azure.com/#@platform.education.gov.uk/resource/subscriptions/64d0000b-ff5d-4d6e-9a98-41f0d8d17da7/resourceGroups/s121t01-ttapi-rg/providers/Microsoft.DBForPostgreSQL/servers/s121t01-teacher-training-psql/connectionSecurity and click `Add current client IP address`. Set your firewall name to something sensible like `david_home` then click the Save icon
5. Run `az logout` then `az login` to refresh your credentials
4. Run `bin/mcb az apps pg_dump -E staging` to get a database dump from staging. This data is sanitised production data
5. Run `psql manage_courses_backend_development < staging_teacher_training_yyyymmdd_hhmmss.sql` (yours will a different filename) to import the data into your database

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
