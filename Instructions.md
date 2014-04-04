# Important Steps in Creating a Rails App
## Installing PostgreSQL locally
[Link to tutorial for heroku](https://devcenter.heroku.com/articles/heroku-postgresql#local-setup)


## Extras
[If rails server throws up a "already running" error](https://stackoverflow.com/questions/15072846/server-is-already-running-in-rails)

## Gemfile
`sublime .Gemfile`

## Git
1. `git init`
2. ensure that `.gitignore` ignores the bundler config, SQLite database and logfiles and tempfiles.
3. add augmented .gitignore

```
# Ignore other unneeded files.
database.yml
doc/
*.swp
*~
.project
.DS_Store
.idea
```

## Heroku
- add pg to production in Gemfile
- `bundle install --without production`

```shell
$ rake assets:precompile
$ git commit -a -m "Add precompiled assets for Heroku"
```

`heroku create`

## Planning The App
- Create a data model

### Scaffolding
`rails generate scaffold <Capitalized singular version of resource> <attribute>:<type> <attribute2>:<type>`

then migrate using `rake db:migrate`

Youc an ensure that the command uses the version of Rake corresponding to our `Gemfile`:

```
bundle exec rake db:migrate
```

- Set up validation
- Assign resource relationships using `belongs_to`, `has_many`, etc.


### Deploying to Heroku with Changes

```
$ heroku create
$ rake assets:precompile
$ git commit -a -m "Add precompiled assets for Heroku"
$ git push heroku master
```

Migrate the production database:

`heroku run rake db:migrate

## Using RSpec instead of Test::Unit

```shell
$ cd ~/rails_projects
$ rails new sample_app --skip-test-unit
$ cd sample_app
```

in Gemfile:
```ruby
group :development, :test do
  gem 'sqlite3', '1.3.5'
  gem 'rspec-rails', '2.11.0'    # also installs RSpec as it is a dependency
end
```

```ruby
group :test do
  gem 'capybara', '1.1.2'
end
```

Configuring rails to use RSpec:
```shell
$ rails generate rspec:install
```

## Static Pages
Generating a controller called StaticPages with actions for a home page and help page 

```shell
$ rails generate controller StaticPages home help --no-test-framework
```

` --no-test-framework` suppresses generation of default RSpec tests.


## Undoing Code Generation
These two commands cancel each other out:
```shell
  $ rails generate controller FooBars baz quux
  $ rails destroy  controller FooBars baz quux
```

## Test Driven Development: Integration Tests
- BDD = Behaviour Driven Development
- Known as _request specs_ in the RSpec context
- allow us to simulate the actions of a user interacting with our application using a web browser
- write tests FIRST before application code.
  + known as the fail, implement, pass development cycle
- implement using the "Red, Green, Refactor" cycle

Generate an integration test (request spec) for our static pages:
```shell
$ rails generate integration_test static_pages
```

running the test (using bundle exec) 

```shell
bundle exec rspec spec/requests/static_pages_spec.rb
```

example title test:

```ruby
it "should have the right title" do
  visit '/static_pages/home'
  page.should have_selector('title',
                    :text => "Ruby on Rails Tutorial Sample App | Home")
end
```


# Installing Guard
May need growl and growl notify

Test gems on OSX:

```ruby
# Test gems on Macintosh OS X
group :test do
  gem 'capybara', '1.1.2'
  gem 'rb-fsevent', '0.9.1', :require => false
  gem 'growl', '1.0.3'
end
```

Initialising Guard:
```shell
$ bundle exec guard init rspec
```

Ensure that Guard doesn't run all the tests after a failing test passes:

```ruby
guard 'rspec', :version => 2, :all_after_pass => false do
```

then start guard 

```shell
bundle exec guard
```

## Spork

add to gemfile :development :test group
```shell
  gem 'guard-spork', '1.2.0'
  gem 'childprocess', '0.3.6'
  gem 'spork', '0.9.2'
```

then run `bundle update`, `bundle install` and `bundle exec spork --bootstrap`


Start a spork server:

```shell
$ bundle exec spork
```

Using guard w/ spark:

```shell
bundle exec guard init spork
```

add spork to guardfile. With that configuration in place, we can start Guard and Spork at the same time with the guard command:

```shell
$ bundle exec guard
```

## Installing Bootstrap

### Listing 5.3. Adding the bootstrap-sass gem to the Gemfile.

```ruby
gem 'rails', '3.2.15'
gem 'bootstrap-sass', '2.1'
.
.
.
```

The first step in adding custom CSS to our application is to create a file to contain it:

`app/assets/stylesheets/custom.css.scss`

and wthin
```scss
@import "bootstrap";
```

## Generating Models
first generate the controller 

```shell
rails generate controller Users new --no-test-framework
```

generate the model

```shell
rails generate model User name:string email:string
```
(Note that, in contrast to the plural convention for controller names, model names are singular: a Users controller, but a User model.)

This creates a migration in db/migrate

# Model Annotation
Although it’s not strictly necessary, you might find it convenient to annotate your Rails models using the annotate gem (Listing 6.4).