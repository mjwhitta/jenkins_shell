# Jenkins shell

Simulate a Linux shell or Windows cmd prompt using Jenkins.

## How to install

Open a terminal and run the following:

```
$ gem install jenkins_shell
```

Or install from source:

```
$ git clone https://gitlab.com/mjwhitta/jenkins_shell.git
$ cd jenkins_shell
$ bundle install && rake install
```

## How to use

```
$ jsh http[s]://[user[:pass]@]host[:port][/path]
```

## Links

- [Source](https://gitlab.com/mjwhitta/jenkins_shell)
- [RubyGems](https://rubygems.org/gems/jenkins_shell)

## TODO

- Make the `cd` command work with Linux
- RDoc
