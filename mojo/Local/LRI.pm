package Local::LRI;

# generic LibraryREST interface definition
# you *must* define a module that inherits from this, overrides each of these methods,
# and knows how to talk to your specific ILS. 

use strict;
use warnings;

use version; our $VERSION = version->declare('v0.1');

sub new {
    my $class = shift;
    my $type = ref($class) || $class;
    my $self = {};

    return bless $self, $type;
}

sub get_library {
    my $self = shift;
    my $id = shift;

    return;
}

sub get_user {
    my $self = shift;
    my $id = shift;

    return;
}

# example of generic method not implemented in specific connector
sub about {
    my $self = shift;

    my $about = {
	about => 'experiment / proof of concept for RESTful API for library systems',
    };
    return $about;
}

1;
