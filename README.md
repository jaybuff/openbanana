# Opensesame

Opensesame is a gem that, currently, provides a `db:grant` rake task for Rails
projects.

What this `db:grant` task does is creates the database and sets up the initial grants for the database
configured in the `config/database.yml` file

To use Opensesame, include it in your `Rakefile`:
```
require 'opensesame/tasks'

And in your `Gemfile`:

gem "opensesame", "~> 0.1"


Make sure you have a source for either `maestro` or `dogwood` in your Gemfile.```

### Environment variables

* `DB_USER` overrides the default user (root) to grant privileges
* `DB_PASSWORD` overrides the default password (*empty*) to grant privileges
* `DB_HOST` overrides the hostname for the database server (defaults to
  *localhost*)
