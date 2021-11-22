# Feature Flags

Find has a feature flag facility at '/feature-flags'. When a flag is toggled, its state is updated in Redis. 

# Adding new feature flags

All flags are defined under '/app/lib/feature-flags.rb'.

Add new feature names to this file. Flags will be deemed to have a 'false' state initially until you toggle them via the UI (see 'Switching them on and off in deployed environments').

# Using them in code

In code, feature flag state should be checked via the `FeatureFlag` class.

```sh
$ FeatureFlag.active?(:display_apply_button)
```

This will raise an appropriate error if the feature name isn't recognised.

# Switching them on and off in deployed environments

- Change the true/false value for the flag in the Feature Flags UI (`/feature-flags`)
- Note this `/feature-flags` is publicly accessible in all environments except production. In production `/feature-flags` is protected by _basic auth_ and you will require the necessary credentials to gain access.
- You can also toggle feature flags in the console via the `FeatureFlag` class if you prefer

```sh
$ FeatureFlag.activate(:foo)
$ FeatureFlag.deactivate(:foo)
```
