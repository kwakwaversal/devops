#!/usr/bin/env perl

use Mojolicious::Lite;
use Mojo::JSON 'decode_json';
use Mojo::UserAgent;

# ABSTRACT: interface to test the Mattermost incoming API

hook before_render => sub {
    my ($c, $args) = @_;

    # If we're rendering JSON, add a few defaults to the stash
    if (defined $args->{json}) {
        $args->{json}->{timestamp}  = $c->timestamp;
        $args->{json}->{logger_div} = $c->req->url->path->parts->[0];
    }

    # If we're rendering a template or this is an exception, return
    return unless my $template = $args->{template};
    return unless $template =~ /^exception/;

    # Force JSON rendering for exceptions
    $args->{json} //= {};
    $args->{json}->{text} = $args->{exception};
    $args->{json}->{timestamp}  //= $c->timestamp;
    $args->{json}->{logger_div} //= $c->req->url->path->parts->[0];
    $args->{status} = 200;
};

helper actions => sub {
	my ($c, $action, $json) = @_;
	state %actions;

    if ($json) {
        $actions{$action} = $json;
    }

    return $actions{$action} // {};
};

helper timestamp => sub {
    my $t = localtime;
    return "$t";
};

helper ua => sub {
    state $ua = Mojo::UserAgent->new();
};

any '/' => 'home';

post '/actions' => sub {
    my $c      = shift;
    my $action = $c->req->param('action');
    my $json   = decode_json $c->req->param('data');

    # Stores this action using the helper above (this will only persist as long
    # as this service is running, and will not work across multiple processes).
    $c->actions($action, $json);

    $c->render(json => {json => $c->actions($action)});
};

any '/actions/:action' => sub {
    my $c = shift;
    $c->render(json => $c->actions($c->stash('action')));
};

post '/webhook' => sub {
    my $c           = shift;
    my $webhook_url = $c->req->param('webhook-url');
    my $json        = decode_json $c->req->param('data');

    my $tx = $c->ua->post($webhook_url => json => $json);

    $c->render(json => {json => $tx->result->to_string});
};

app->start;

__DATA__
@@ home.html.ep
<div class="container-fluid" id="big-container">
  <div class="row">
    <div class="col-lg-12">
      <nav class="navbar navbar-default" role="navigation">
        <div class="navbar-header">
            <span class="navbar-brand">Mattermost API testing tool</span>
        </div>

        <strong class="navbar-text pull-right">Updated: <span id="hms">00:00:00</span></strong>
        <strong class="navbar-text pull-right">Events: <span id="events">0</span></strong>
        <button id="clear-logs" type="button" class="btn btn-primary navbar-btn pull-right">Clear logs</button>
      </nav>
    </div>
  </div>

  <div class="row">
    <div class="col-md-6">
      <form id="webhook" method="POST" action="<%= url_for 'webhook' %>">
        <div class="input-group">
          <span class="input-group-addon" id="webhook-url">Incoming Webhook URL</span>
          <input type="text" name="webhook-url" class="form-control" id="webhook-url" aria-describedby="basic-addon3"
            value="http://hector.inview.local:8065/hooks/jk5x5idt1ig19jkbfafezb8j9h">
        </div>
        <div class="input-group">
          <span class="input-group-addon" id="basic-addon1"> JSON<br>to<br>Incoming<br>Webhook</span>
<textarea name="data" class="form-control input-sm" rows="15">
{
  "attachments": [
    {
      "pretext": "This is the attachment pretext.",
      "text": "This is the attachment text.",
      "actions": [
        {
          "name": "Ephemeral Message",
          "integration": {
            "url": "http://hector.inview.local:3000/actions/ohsnap",
            "context": {
              "action": "do_something_ephemeral"
            }
          }
        }, {
          "name": "Update",
          "integration": {
            "url": "http://hector.inview.local:3000/actions/ohsnap",
            "context": {
              "action": "do_something_update"
            }
          }
        }
      ]
    }
  ]
}
</textarea>
        </div>

        <button type="submit" class="btn btn-default pull-right">Submit payload to webhook</button>
      </form>

      <br><br>

      <div id="logwebhook" class="logger"></div>
    </div>
    <div class="col-md-6">
      <form id="actions" method="POST" action="<%= url_for 'actions' %>">
        <div class="input-group">
          <span class="input-group-addon" id="action-name">Action Response name</span>
          <input type="text" name="action" class="form-control" id="action-name" aria-describedby="basic-addon3"
            value="ohsnap">
        </div>
        <div class="input-group">
          <span class="input-group-addon" id="basic-addon1"> Store<br>JSON<br>against<br>action</span>
<textarea name="data" class="form-control input-sm" rows="15">
{
  "update": {
    "props": {
      "attachments": [
        {
          "fallback": "test",
          "color": "#FF8000",
          "pretext": "This is optional pretext that shows above the attachment.",
          "text": "Bla bla `here is some code` *formatting is ok*",
          "title": "Example Attachment",
          "title_link": "http://docs.mattermost.com/developer/message-attachments.html"
        }
      ]
    }
  },
  "ephemeral_text": "Thanks for clicking!"
}
</textarea>
        </div>
        <button type="submit" class="btn btn-default pull-right">Store action response</button>
      </form>

      <br><br>

      <div id="logactions" class="logger"></div>
    </div>
  </div>

  <div class="row">
    <div class="col-md-12">
      <div class="alert alert-info alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <p class="pull-right">
          Documentation:
            <a class="btn btn-primary" href="https://docs.mattermost.com/developer/api.html" role="button">Mattermost API</a>
            <a class="btn btn-primary" href="https://docs.mattermost.com/developer/webhooks-incoming.html" role="button">Incoming Webhook</a>
            <a class="btn btn-primary" href="https://docs.mattermost.com/developer/interactive-message-buttons.html" role="button">Interactive Message Buttons</a>
        </p>
        <h1>Incoming Webhook Sandbox</h1>
        <p>
          This tool allows you to submit to a Mattermost Incoming Hook, and set the JSON response for an action integration url.
        </p>
      </div>
    </div>
  </div>
</div>

%= stylesheet '//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css', integrity => 'sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u', crossorigin => 'anonymous';
%= stylesheet '//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.8.0/styles/dracula.min.css';
%= javascript '//cdnjs.cloudflare.com/ajax/libs/highlight.js/9.8.0/highlight.min.js';
%= javascript '//cdnjs.cloudflare.com/ajax/libs/jquery/3.1.1/jquery.min.js';
%= javascript '//maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js', integrity => 'sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa', crossorigin => 'anonymous';

<style>
textarea {
  font-family: Consolas,Monaco,Lucida Console,Liberation Mono,DejaVu Sans Mono,Bitstream Vera Sans Mono,Courier New, monospace;
  font-size: small;
}
</style>

<script>
var event_count = 1;

function animate (selector) {
  var $elem = $(selector);
  if ($elem.is(':animated'))
    return;
  $elem.animate({'opacity': 0}, 200, function () {})
       .animate({'opacity': 1}, 500)
}

function animate_text (selector, value) {
  var $elem = $(selector);
  if ($elem.text() != value) {
    $elem.text(value);
    animate(selector);
  }
}

function parse_response (res) {
  console.log(res);

  animate_text('#events', event_count++);
  animate_text('#hms', res.timestamp);

  if (res.json) {
    $('#log' + res.logger_div).prepend($('<pre id="' + event_count + '">Timestamp: ' + res.timestamp
      + '\n\n<code class="json">$payload = ' + JSON.stringify(res.json, null, 2) + '</code></pre>'));
  }
  else {
    $('#log' + res.logger_div).prepend($('<pre id="' + event_count + '">Timestamp: ' + res.timestamp
      + '\n\n<code class="json">' + res.text + '</code></pre>'));
  }

  hljs.highlightBlock(document.getElementById(event_count));

  animate('#' + event_count);
}

$(function () {
  $('#clear-logs').click(function(e) {
    $('.logger').empty();
  });

  $('form').submit(function(e) {
    var form = $(this);
    $.post(form.attr('action'), form.serialize(), function(data) {
      parse_response(data);
    });
    e.preventDefault();
  });
});

</script>
