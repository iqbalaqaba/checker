# Checker
[![Build Status](https://secure.travis-ci.org/netguru/checker.png?branch=master)](http://travis-ci.org/netguru/checker)
[![Coverage Status](https://coveralls.io/repos/netguru/checker/badge.png?branch=master)](https://coveralls.io/r/netguru/checker)
[![Code Climate](https://codeclimate.com/github/netguru/checker.png)](https://codeclimate.com/github/netguru/checker)
[![Gem Version](https://badge.fury.io/rb/checker.png)](http://badge.fury.io/rb/checker)

A collection of modules for which every is designed to check syntax in files to be commited via git.

## Compatibility

Checker works with rubies 1.9.2, 1.9.3 and 2.x.
As for Rails with SASS - tested with RoR 3.2.x


## Usage

### Install
Checker is available in rubygems (current stable version is 0.6.6), so you just need to do:
```
gem install checker
```

If you are using bundler, you can add it to your project via `Gemfile` file (best to put it under `:development` group).
Since checker is a command-line utility, there is no need to load it up in the application:
```ruby
group :development do
  gem 'checker', :require => false
end
```

After installing the gem please follow [Git hook](#git-hook) section for further details.

### Git hook

All you need to do is type in `checker install` and it will automatically install the prepare-commit-msg hook
to your current git project. It will look something like this:

```
#!/bin/bash

#### Begin of checker script
if [ -f /Users/user/.rvm/bin/rvm-shell ]; then
  /Users/user/.rvm/bin/rvm-shell 'ruby-1.9.3-p286' -c 'checker'
else
  checker
fi

if [ $? = 1 ]; then
  exit 1
fi

text=`echo -n ':ok: '; cat $1`
echo "$text" > $1
#### End of checker script
```

If you don't want your commits be prepended by checkered flag you can remove two last lines from the prepare-commit-msg hook.

Now checker will halt the commit if it finds problem with source code. Couple examples:

#### pry
```
[ PRY - 1 files ]
  Checking app/models/user.rb... [FAIL]
46:binding.pry
```

#### conflict
```
[ CONFLICT - 1 files ]
  Checking a.bad.scss... [FAIL]
4:<<<<<<< Updated upstream
30:>>>>>>> Stashed changes
```

#### sass
```
[ SASS - 1 files ]
  Checking a.bad.scss... [FAIL]
Syntax error: Invalid CSS after "qwe:": expected pseudoclass or pseudoelement, was "asd:"
        on line 1 of .checker-cache/3cc74408b797b92e79207a64d97ae429
  Use --trace for backtrace.
```

### Advanced usage

You can specify checker behaviour for your project by changing the git config for checker.
Available options are:

* check

  List of modules, seperated by comma, which checker will use. Defaults to all modules.
  Example: `git config checker.check 'ruby, haml, coffeescript'`

* commit-on-warning

  Boolean value. If given false, checker will not commit when any module returns warning.
  Defaults to true.
  Example: `git config checker.commit-on-warning 'false'`

* rails-for-sass

  Boolean value. Will use rails runner to check for sass syntax using sprockets.
  Works work rails >= 3.1. Defaults to true.
  Example: `git config checker.rails-for-sass 'true'`


### Available modules

#### ruby
Checks for correct syntax in ruby (.rb) files

#### haml
Checks for correct syntax in haml files

#### pry
Checks for any occurence of `binding.pry` or `binding.remote_pry`

#### coffeescript
Checks for correct syntax in coffeescript (.coffee) files

#### sass
Checks for correct syntax in sass and scss files

#### slim
Checks for correct syntax in slim files

#### conflict
Checks for any occurence of git conflicts when merging (looks for `<<<<<<< ` or `>>>>>>> `)

#### rubocop
Checks for if code follows the style guides ( https://github.com/bbatsov/rubocop )

### Dependencies

For various modules to work you may need to install additional dependencies:

* coffeescript - `npm install -g coffee-script` - see https://github.com/jashkenas/coffee-script/
* javascript - install jsl binary - see http://www.javascriptlint.com/download.htm
* haml & sass & slim - `gem install haml sass slim`
* rubocop - `gem install rubocop`

Copyright (c) 2015 Netguru. See LICENSE for further details.
