# Feature Flags

Find has a basic feature flag facility based on the [config gem](https://github.com/rubyconfig/config).

# Adding new feature flags

All flags are defined under the `feature_flags` key of [config/settings.yml](config/settings.yml).

Add new feature names in alphabetical order, setting true/false as required. Typically most flags should be set to false initially.

# Using them in code

In code, feature flag state should be checked via the `FeatureFlag` class.

`FeatureFlag.active?(:display_apply_button)`

This will raise an appropriate error if the feature name isn't recognised.

# Switching them on and off in deployed environments

- Change the true/false value for the flag in [config/settings.yml](config/settings.yml)
- Commit the change
- Raise and merge a PR

This will change the flag across QA, Staging, and Production.

To test a feature on QA before deploying to Staging and Production, instead of updating settings.yml you can add a temporary environment variable override to [app_config.yml](terraform/workspace_variables/app_config.yml), eg -

```
qa:
  <<: *default
  RAILS_ENV: qa
  RACK_ENV: qa
  SETTINGS__FEATURE_FLAGS__<FEATURE_NAME>: true
```

This should be removed as soon as the feature is ready to be switched on in production. Refrain from adding overrides to the staging and production blocks of this file so as to minimise the spread of feature flag config across two files.

# Urgent changes to feature flags

If a feature needs to be switched off quickly, the process is the same as above. If another dev isn't around to review the PR (eg - an out of hours change), then merge without approval.

It is possible to modify the environment variable created by the config gem for a given feature flag, however restarting the server manually causes a short period of downtime. As deploys are fairly quick, the time saved from changing the environment variable directly isn't considerable and should be discouraged.

# Development and Test

When developing a feature, switch the flag in settings.yml but don't commit the change until it's ready to be switched on in a deployed environment.

When writing tests, use the methods in FeatureFlagHelper to stub flag checks as required.
