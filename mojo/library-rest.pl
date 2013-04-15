#!/usr/bin/env perl
use strict;
use warnings;

use Mojolicious::Lite;
use Mojo::JSON;

use UNIVERSAL::require;
use FindBin;
use lib "$FindBin::Bin";

#my $impl = "Local::LRI::MockLRIDummy";
my $impl = "Local::LRI::MockLRIText";

$impl->use;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

get '/api/v0/library/:id' => sub {
  my $self = shift;
  my $library = $impl->get_library($self->stash('id'));
  if ($library) {
    $self->stash( library => $library );
    $self->render('library');
  } else {
    $self->render_not_found;
  }
};

get '/api/v0/user/:id' => sub {
  my $self = shift;
  my $user = $impl->get_user($self->stash('id'));
  if ($user) {
    $self->stash( user => $user );
    $self->render('user');
  } else {
    $self->render_not_found;
  }
};

get '/api/v0/about' => sub {
  my $self = shift;
  my $about = $impl->about();
  if ($about) {
    $self->stash( about => $about );
    $self->render('about');
  } else {
    $self->render_not_found;
  }
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Greetings';
<pre>
Greetings. This is an experiment / proof of concept for a RESTful API for library systems
(such as Evergreen and Koha).

To try it out, visit some of the following URLs:

/api/v0/user/123
/api/v0/user/123.json
/api/v0/user/123.xml
/api/v0/library/42
/api/v0/library/42.json
/api/v0/library/42.xml
/api/v0/about
</pre>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %></body>
</html>

@@ library.html.ep
% layout 'default';
% title 'Library';
LIB ID <%= $library->{id} %><br />
LIB NAME <%= $library->{name} %>

@@ library.json.ep
<%== Mojo::JSON->new->encode($library) %>

@@ library.xml.ep
<response><library><id><%= $library->{id} %></id><name><%= $library->{name} %></name></library></response>

@@ user.html.ep
% layout 'default';
% title 'User';
User ID <%= $user->{id} %><br />
User Name <%= $user->{name} %>

@@ user.json.ep
<%== Mojo::JSON->new->encode($user) %>

@@ user.xml.ep
<response><user><id><%= $user->{id} %></id><name><%= $user->{name} %></name></user></response>

@@ about.html.ep
% layout 'default';
% title 'About';
<%= $about->{about} %>

@@ about.json.ep
<%== Mojo::JSON->new->encode($about) %>

@@ about.xml.ep
<response><about><%= $about->{about} %></about></response>
