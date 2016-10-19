# README
  This project is a api rest example.
  Users can signup and signin into system.
  Users can CRUD cards with tasks (todo list).
  Examples - See docs file.

  TODO: Create endpoints to CRUD Tasks

* Ruby version
  2.3.1

* Rails version
  5.0.0

* System dependencies
  postgresql 9.5

* Database creation
  Create a new database.yml to postgresql
  rake db:create
  rake db:migrate

* Database initialization
  rake db:seed

* How to run the test suite
  rake db:create RAILS_ENV=test
  rake db:migrate RAILS_ENV=test
  rspec
