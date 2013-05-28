#!/usr/bin/env perl
use strict;
use warnings;

use Mojolicious::Lite;
use Mojo::JSON;

use UNIVERSAL::require;

my $impl = "Local::MockLibraryREST";

$impl->use;

my $ils = $impl->new();

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

get '/api/library/:id' => sub {
  my $self = shift;
  $self->res->headers->header('Access-Control-Allow-Origin' => '*');
  my $library = $ils->get_library($self->stash('id'));
  if ($library) {
    $self->stash( library => $library );
    $self->render('library');
  } else {
    $self->render_not_found;
  }
};

get '/api/user/:id' => sub {
  my $self = shift;
  $self->res->headers->header('Access-Control-Allow-Origin' => '*');
  my $user = $ils->get_user($self->stash('id'));
  if ($user) {
    $self->stash( user => $user );
    $self->render('user');
  } else {
    $self->render_not_found;
  }
};

get '/api/circ' => sub {
  my $self = shift;
  $self->res->headers->header('Access-Control-Allow-Origin' => '*');
  my $circs = $ils->get_circ();
  $self->stash( circ => $circs );
  #$self->render('circ');
  $self->respond_to(
    json => sub { $self->render(template=>'circ') },
    xml => sub { $self->render(template=>'circ') },
  );
};

get '/api/auth' => sub {
    my $self = shift;
    $self->res->headers->header('Access-Control-Allow-Origin' => '*');
    $self->res->headers->header('Access-Control-Allow-Methods' => 'GET, POST, OPTIONS');
    # should accept user and pass as POST
    my $user = $self->param('user');
    my $pass = $self->param('pass');
    my $auth_data = $ils->get_auth($user, $pass);
    if ($auth_data) {
        $self->stash(auth_data => $auth_data);
        $self->render('auth');
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

/api/user/123
/api/user/123.json
/api/user/123.xml
/api/library/42
/api/library/42.json
/api/library/42.xml
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

@@ circ.json.ep
<%== Mojo::JSON->new->encode($circ) %>

@@ circ.xml.ep
<response>
<circ>
<id><%= $circ->{id} %></id>
<title><%= $circ->{title} %></title>
<author><%= $circ->{author} %></author>
<due_date><%= $circ->{due_date} %></due_date>
</circ>
</response>

@@ auth.json.ep
<%== Mojo::JSON->new->encode($auth_data) %>
