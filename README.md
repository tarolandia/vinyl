# Vinyl
**_Access Level for him and her_**

_by: Federico Saravia Barrantes [@fsaravia](https://github.com/fsaravia) and Lautaro Orazi [@tarolandia](https://github.com/tarolandia)_

## Introduction

"Vinyl" is a simple gem that allows developer to define different access levels for a resource and a serie of local and global validators to gain access to those levels.
It works by analizing a series of validators defined by you and returning a number representing the access level a particular request is able to reach.

## What is it useful for?

This gem is useful when you need to control the output depending on who wants to access to a resource.
For example: user A wants to get user B's profile.
If A == B, A have full access to data
If A is friend of B, A can see private data but not config data
If A is not friend of B, A only can see public data

In the example we have 3 different levels of access to B information.

## Basic Config

```ruby
  Vinyl::configure do |config|
    config.api_acl_mode = Vinyl::Configuration::STRATEGY_DESCENDING
    config.force_access_control = true 
    config.warn_on_missing_validators = true 
  end
```

__:api_acl_mode can take two values:__

  1. Vinyl::Configuration::STRATEGY_DESCENDING, Check for validators starting on the highest access level
  2. Vinyl::Configuration::STRATEGY_ASCENDING, Check for validators starting on the lowest access level

__:force_access_control true/false__

Deny access if no validators are given for a route/method combination and no global validators exist

__:warn_on_missing_validators true/false__

Display a warning on STDOUT when calling a missing validator


## Defining Rules

A rule defines the access level and the validators for a route/method combination:

```ruby
Vinyl.when_route 
  '/api/route', 
  :with_method => 'POST|GET|PUT|DELETE',
  :get_access_level => 1...n,
  :if_pass => ['validator1', 'validator2', …, 'validatorn']
```

__Example:__
```ruby
Vinyl.when_route '/profiles.json', 
  :with_method => 'GET', 
  :get_access_level => 1, 
  :if_pass => ['is_user']

Vinyl.when_route '/profiles.json', 
  :with_method => 'GET', 
  :get_access_level => 2, 
  :if_pass => ['is_admin']
```


## Defining validators

There are two kind of validators: global and normal validators. All validators you define must return true or false.

Global validators will be applied to all rules defined. You can add a global validator using add_global_validator method:

```ruby
Vinyl.add_global_validator("name_of_global_validator", lambda {
  # your code here
  return true/false
})
```

Normal validators will be applied when a rule includes it into its validators list. Validators can be added using add_validator method:

```ruby
Vinyl.add_validator("name_of_validator", lambda {
  # your code here
  return true/false
})
```


## Defining Variables

Inside validators you can use your models, classes and whatever. If you want a custom variable to be available in the scope of the validators, add it this way:

```ruby
Vinyl.my_variable = variable_value
```

Inside your validator:

```ruby
Vinyl.add_validator("my_validator", lambda {
  puts my_variable # will output variable_value
  return true/false
})
```

__Clearing Variables__

If you need to reset previously defined variables to avoid validation errors just call:

```ruby
Vinyl.reset_variables
```
## Getting Access Level

At this point you had defined your rules, validators and variables. Now you are ready to get call access level.

```ruby
access_level = Vinyl.check_level('/call/route','call_method')
```

If you need to avoid a global validator you can use bypass method:

```ruby
access_level = Vinyl.bypass("global_validator_name").check_level('/call/route','call_method')
```

or a list of them

```ruby
access_level = Vinyl.bypass(["global_1","global_2"]).check_level('/call/route','call_method')
```

Using bypass means exclude the validators only for the current check.

## License

See the `UNLICENSE` file included with this gem distribution.
