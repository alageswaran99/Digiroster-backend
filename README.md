# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version 3.3.0

- Rails version 7.0.7

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- heroku logs --tail -a freshcare

- heroku run rails c -a freshcare

- heroku info freshcare

- heroku run rails db:migrate --app freshcare

- heroku run rails console --app freshcare

- https://devcenter.heroku.com/articles/heroku-cli-commands

- heroku logs --tail -a digiroster

- heroku run rails c -a digiroster

- heroku run rails db:migrate --app digiroster

- heroku run rails c -a digiroster-api-qa

- heroku run rails db:migrate --app digiroster-api-qa

- EDITOR=vim rails credentials:edit --environment production

### To run test suite

You must have test.key which is copy of development.key

```
RAILS_ENV=test ruby test/app/suites/freshcare_test_suite.rb
```

cd /Users/Ramkumar.Rajendran/Documents/GitHub/FreshcareV2
rvm use 3.3.0
rvm gemset use rails7
Rails Commands::

- rails generate scaffold Appointment client_id:bigint agent_id:bigint account_id:bigint other_info:jsonb notes:text start_time:datetime end_time:datetime
- rails generate scaffold Feedback client_id:bigint agent_id:bigint account_id:bigint other_info:jsonb description:text appointment_id:bigint note_type:integer
- rails g model AgentAppointment agent_id:bigint appointment_id:bigint account_id:bigint status:integer
- rails generate model RecurringTask client_id:bigint agent_id:bigint account_id:bigint other_info:jsonb notes:text start_time:datetime end_time:datetime created_by:bigint
- rails g scaffold Group name:string account_id:bigint description:text group_type:integer
- rails generate scaffold Holiday agent_id:bigint account_id:bigint reason:text from_time:datetime to_time:datetime leave_type:integer

Devise upgrades::

- To have custom email configuration for devise check this link https://stackoverflow.com/questions/17464134/dynamic-devise-sender-email-address
- bypass_sign_in(@user) https://github.com/heartcombo/devise/wiki/How-To:-Allow-users-to-edit-their-password
