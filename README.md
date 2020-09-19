# Zero Rails

[![Build Status](https://travis-ci.org/zhandao/zero-rails.svg?branch=master)](https://travis-ci.org/zhandao/zero-rails)
[![Maintainability](https://api.codeclimate.com/v1/badges/669751e0a8ae32269600/maintainability)](https://codeclimate.com/github/zhandao/zero-rails/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/669751e0a8ae32269600/test_coverage)](https://codeclimate.com/github/zhandao/zero-rails/test_coverage)
[![Depfu](https://badges.depfu.com/badges/b375ff680451d2f77e72abef1ce7ed68/count.svg)](https://depfu.com/github/zhandao/zero-rails?project=Bundler)

Rails API template, **NO available version yet**.

## Features

## Usage

1. - [ ] initialize from the master of basic framework.  
   (template framework for using it by `rails new NAME -m temp/path` is the feature)

   ```bash
   git init
   git remote add origin <YourRepoURL>
   git remote add zero-rails https://github.com/zhandao/zero-rails.git
   git fetch zero-rails master # or pull
   # git branch -va

   git checkout master
   git rebase zero-rails/master # or git merge
   ```
    
2. - [ ] change your app's name (module name) in `application.rb`
3. possible changes in `config/`:
    - [ ] brakeman.ignore: check
    - [ ] database.yml: db name and the other
    - [ ] nginx.conf
    - [ ] puma
    - [ ] secerts.yml
    - [ ] **[MUST]** copy settings.local.example.yml to settings.local.yml and change values of it
    - [ ] sidekiq.yml: concurrency and queues
    - [ ] storage.yml
4. possible changes in `config/initializers`:
    - [ ] action_mailer
    - [ ] cors
    - [ ] generate
    - [ ] kaminari_config
    - [ ] open_api: apidoc info
    - [ ] params_processor
    - [ ] **rake-attack**
    - [ ] rake-timeout
    - [ ] sidekiq
5. remove examples which you wont need:
    - [ ] migration & seed
    - [ ] config/routes
    - [ ] _docs/model_docs & rspec_docs & v* & v*_error
    - [ ] model & model spec & factory
    - [ ] api & view & api spec
6. dependence:
    - [ ] remove gems in Gemfile you wont need
    - [ ] run `bundle install --jobs=4`
7. - [ ] set up database: `rails db:setup`
8. unit test:
    - [ ] run `rspec`
    - [ ] fix test error

