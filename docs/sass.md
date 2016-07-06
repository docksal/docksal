# Sass with compass
Cli container already contains `ruby`, `bundler`.

**Create Gemfile in theme folder**

Example:
```ruby
source "https://rubygems.org"
gem 'sass', '~>3.4.0'
gem 'compass'
gem 'bootstrap-sass', '~>3.2.0'
```

**Every developer runs `bundle install` to pull necessary gem dependencies**

This command should be run in the folder with Gemfile:
> dsh exec bundle install

There are two folder (`.bundle`, `.bundler`) and a file (`Gemfile.lock`) will be created.
Please add this directories (`.bundle`/`.bundler`) to `.gitignore`

**Compile sass**

Please run in the theme folder:
> dsh exec bundle exec compass compile

This is very important, do not run `compass compile` directly, run it via `bundle exec` so the proper gem versions are used (defined in the Gemfile).
Also you can run watcher to keep your CSS files up to date as changes are made:
> dsh exec bundle exec compass watch
