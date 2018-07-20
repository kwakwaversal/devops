use Mojolicious::Lite;

plugin Minion => {Pg => 'postgresql://postgres:password@db/postgres'};
plugin 'Minion::Admin';

# Slow task
app->minion->add_task(poke_mojo => sub {
  my $job = shift;
  $job->app->ua->get('mojolicious.org');
  $job->app->log->debug('We have poked mojolicious.org for a visitor');
});

# Perform job in a background worker process
get '/' => sub {
  my $c = shift;
  $c->minion->enqueue('poke_mojo');
  $c->render(text => 'We will poke mojolicious.org for you soon.');
};

app->start;
