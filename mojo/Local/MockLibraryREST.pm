package Local::MockLibraryREST;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $type = ref($class) || $class;
    my $self = {};

    return bless $self, $type;
}

my $libraries = {
    1 => {
        id => 1,
        name => 'Example Library One'
    },
    2 => {
        id => 2,
        name => 'Example Library Two'
    },
};

my $users = {
    1 => {
        id => 1,
        name => 'John Q Public',
        name_parts => [ 'John', 'Q', 'Public' ],
    },
    2 => {
        id => 2,
        name => 'John Q Public',
        name_parts => [ 'John', 'Q', 'Public' ],
    },
    123 => {
        id => 123,
        name => 'John Q Public',
        name_parts => [ 'John', 'Q', 'Public' ],
    },
};

sub get_library {
    my $self = shift;
    my $id = shift;
    if (exists($libraries->{$id})) {
        return $libraries->{$id};
    }
    return;
}

sub get_user {
    my $self = shift;
    my $id = shift;

    if (exists($users->{$id})) {
        return $users->{$id};
    }
    return;
}

sub get_token {
    my $self = shift;
    my $user = shift;
    my $pass = shift;

    return 'FAKE_TOKEN_' . $user . '_TOKEN_FAKE';
}

1;
