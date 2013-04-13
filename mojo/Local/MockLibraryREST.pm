package Local::MockLibraryREST;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $type = ref($class) || $class;
    my $self = {};

    return bless $self, $type;
}

sub get_library {
    my $self = shift;
    my $id = shift;
    return {
        id => $id,
        name => 'Example Library ' . $id,
    };
}

sub get_user {
    my $self = shift;
    my $id = shift;

    return {
        id => $id,
        name => 'John Q Public',
        name_parts => [ 'John', 'Q', 'Public' ],
    };
}

1;
