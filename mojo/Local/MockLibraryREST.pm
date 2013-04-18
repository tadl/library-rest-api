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
        name => 'Alice J Public',
        name_parts => [ 'Alice', 'J', 'Public' ],
    },
    123 => {
        id => 123,
        name => 'Bob R Public',
        name_parts => [ 'Bob', 'R', 'Public' ],
    },
};

# mapping of library card numbers to patron ids
my $cards = {
    1001 => 1,
    1002 => 2,
    1123 => 123,
};

# user credentials
my $creds = {
    1001 => '$1$XENTOaqg$eOBJ39bOViO6C8Qf2p.oB1', # "john"
    1002 => '$1$8zUXi9JI$lmPBH06URfmB4PFxUTya4.', # "alice"
    1123 => '$1$3z4lCvcK$1.QL66bx/Qer4NRYWK4UM/', # "bob"
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

sub get_auth {
    my $self = shift;
    my $user = shift;
    my $pass = shift;

    # look up user by library card number and verify password
    if (my $auth_user = $users->{$cards->{$user}}) {
        my $hash = $creds->{$auth_user};
        if (crypt($pass,$hash) eq $hash) {
            return {
                user=>$auth_user->{id},
                token => 'FAKE_TOKEN_' . $user . '_TOKEN_FAKE'
            };
        }
    }
    return 0;
}

1;
