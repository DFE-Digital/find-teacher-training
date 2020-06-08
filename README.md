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

## Linting

It's best to lint just your app directories and not those belonging to the framework, e.g.

```bash
bundle exec rubocop app config lib spec Gemfile --format clang -a

or

bundle exec scss-lint app/webpacker/styles
```
