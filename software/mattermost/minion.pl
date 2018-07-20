#!/usr/bin/env perl

use Mojolicious::Lite;
use Minion::Backend::Pg;    # class needs to be loaded for `data_section`
use Mojo::Loader 'data_section';
use Mojo::Pg;

# ABSTRACT: unathenticated access to minion admin via /minion

# Instead of throwing around private credentials in environmental variables,
# service names are used from a volume-mounted `.pg_service.conf` file in the
# user's home directory.
my $service_name = $ENV{MINION_SERVICE_NAME} // 'minion-default';

# Checks the current migration version and dies loudly if it doesn't match
helper pg => sub {
    state $pg = Mojo::Pg->new("postgresql://?service=$service_name");
    state $checked_migration_version = 0;

    if (!$checked_migration_version) {
        # get the latest version of the Pg backend (extracted from the backend class)
        my $migration = $pg->migrations->name('minion')
            ->from_data('Minion::Backend::Pg');
        my $latest = $migration->latest;

        my $current = eval {
            my $db = $pg->db;
            local $db->dbh->{RaiseError} = 0;
            my $sql = 'select version from mojo_migrations where name = $1';
            my $results = $db->query($sql, 'minion');
            $results->array->[0];
        };

        if ($current < $latest) {
            die "Current migration version is less than the latest version ($current < $latest). Please update manually";
        }

        if ($current > $latest) {
            die "Current migration version is greater than the latest version ($current > $latest). Please update manually";
        }

        $checked_migration_version++;
    }

    $pg;
};

plugin 'Minion' => {Pg => app->pg};
plugin 'Minion::Admin';

get '/' => sub {
    my $c = shift;
    $c->render(text => 'You probably want to visit /minion');
};

app->start;
