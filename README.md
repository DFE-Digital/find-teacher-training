[![Build Status](https://dfe-ssp.visualstudio.com/Become-A-Teacher/_apis/build/status/Find/find-teacher-training?branchName=master)](https://dfe-ssp.visualstudio.com/Become-A-Teacher/_build/latest?definitionId=296&branchName=master)
[![Maintainability](https://api.codeclimate.com/v1/badges/f97679a5f6ddaa3f8981/maintainability)](https://codeclimate.com/github/DFE-Digital/find-teacher-training/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/f97679a5f6ddaa3f8981/test_coverage)](https://codeclimate.com/github/DFE-Digital/find-teacher-training/test_coverage)

# Find Teacher Training

## Prerequisites

- Ruby 2.7.5
- NodeJS 16.13.x
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

## Setting environment variables

Environment variables and app secrets for each environment are stored in Azure KeyVault and gets applied each time the application is deployed. There are make commands which assist in viewing/editing these environment variables from a local console.
Please note that you need to have the [az cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed for this to work.

You also need an activated PIM request to view/edit secrets all environments except qa.

Environment | KeyVault             | Azure Subscription
----------- | -------------------- | ------ |
qa          | s121d01-shared-kv-01 | s121-findpostgraduateteachertraining-development
staging     | s106t01-shared-kv-01 | s106-applyforpostgraduateteachertraining-test
sandbox     | s106p01-shared-kv-01 | s106-applyforpostgraduateteachertraining-production
production  | s106p01-shared-kv-01 | s106-applyforpostgraduateteachertraining-production

### View environment variables

From the root of the repository run the below command, for environments other than qa, make sure you have an activated PIM request
```
make <qa|staging|sandbox|production> print-app-secrets
```

### Edit environment variables
From the root of the repository run the below command, for environments other than qa, make sure you have an activated PIM request
```
make <qa|staging|sandbox|production> edit-app-secrets
```
This will present the app secrets in YAML format in your editor (`vim`), you can make changes to the file and once saved, the secrets will be uploaded to KeyVault and applied to the app after the subsequent deployment.
