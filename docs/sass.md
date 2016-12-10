# Sass with compass
Cli container already contains `ruby`, `bundler`.

## Create Gemfile in theme folder

Example:
```ruby
source "https://rubygems.org"
gem 'sass', '~>3.4.0'
gem 'compass'
gem 'bootstrap-sass', '~>3.2.0'
```

## Install tools

**Every developer runs `bundle install` to pull necessary gem dependencies**

This command should be run in the folder with Gemfile:

```
fin exec bundle install
```

There are two folder (`.bundle`, `.bundler`) and a file (`Gemfile.lock`) will be created.
Please add this directories (`.bundle`/`.bundler`) to `.gitignore`

## Compile SASS

Run in the theme folder:

```
fin exec bundle exec compass compile
```

This is important not run `compass compile` directly, but run it via `bundle exec` so that proper gem versions were used (defined in the Gemfile).

## Compass watcher

You can run watcher to keep your CSS files up to date as changes are made:

```
fin exec bundle exec compass watch --poll
```
