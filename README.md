# Guard::Cloudformation

[![Build History][2]][1] [![Dependency Status][4]][3]

[1]: http://travis-ci.org/tongueroo/guard-cloudformation
[2]: https://secure.travis-ci.org/tongueroo/guard-cloudformation.png?branch=master
[3]: https://gemnasium.com/tongueroo/guard-cloudformation
[4]: https://gemnasium.com/tongueroo/guard-cloudformation.png

Guard::Cloudformation automatically runs validates cloud formation templates via cfn-validate-template.

## Installation

Please be sure to AWS cfn cli tools install:

    $ brew install aws-cfn-tools

Please be sure to have [Guard](https://github.com/guard/guard) installed before continuing.

Install the gem:

    $ gem install guard-cloudformation

Add the guard-cloudformation definition to your Guardfile by running this command:

    $ guard init cloudformation

## Options

```ruby
:all_on_start => false    # Whether to run validate all Cloudformation templates on start up
                          # default: true

:templates_path => "."    # The path(s) to your Cloudformation templates
                          # default: ["templates"]

:notification => false    # Whether to display notifications after the validation is done running
                          # default: true
```