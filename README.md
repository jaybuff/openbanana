# Opensesame

Opensesame is a gem that, currently, provides a `db:grant` rake task for Rails
projects.

What this `db:grant` task does is creates the database and sets up the initial grants for the database
configured in the `config/database.yml` file

To use Opensesame, include it in your `Rakefile`:
```
require 'opensesame/tasks'

And in your `Gemfile`:

gem "opensesame", "~> 0.2"


Make sure you have a source for either `maestro` or `dogwood` in your Gemfile.```

### Environment variables

* `DB_USER` overrides the default user (root) to grant privileges
* `DB_PASSWORD` overrides the default password (*empty*) to grant privileges
* `DB_HOST` overrides the hostname for the database server (defaults to
  *localhost*)


For sharded configurations using a shards.yml file (such as using the octopus gem,
see https://github.com/tchandy/octopus) or with extra sharded entries in database.yml
(named *production* or *development*, etc.; such as using the data_fabric gem,
see https://github.com/bpot/data_fabric), adds a `db:grant_shards` task to create
and grant for a set of shard databases.

An example shard.yml looks like:

octopus:
  ...
  production:
    ungrouped_shard:
      adapter: mysql2
      database: foo
      .... also specify username, password, host, etc.
    shard_group:
      shard1:
        database: bar_1
        ....
      shard2:
        database: bar_2
        ....
   ...

or entries in database.yml that look like:

...
shard_1_production:
  adapter: mysql2
  database: foo_prod_s1
  .. etc.
shard_2_production:
  ...
