package Local::LRI::MockLRIText;
#
# This is just a cheesy alternate connection implementation, to test the concept.
#
use strict;
use warnings;
use lib './..';
use parent 'Local::LRI';

use version; our $VERSION = version->declare('v0.1.0');

my $MOCKTEXTFILE = 'lri_text_dummy_textfile';

sub new {
    my $class = shift;
    my $type = ref($class) || $class;
    my $self = {};

    return bless $self, $type;
}

sub get_library {
    my $self = shift;
    my $id = shift;

    my %lib = ();
    open(my $fh, "<", $MOCKTEXTFILE) or die "$MOCKTEXTFILE: $!";
    while (<$fh>) {
	chomp;
	next unless /^library/;
	my @tokens = split /\t/;
	next unless $tokens[1] =~ /^id:/;
	my @idtok = split(':',$tokens[1]);
	next unless $idtok[1] == $id;
	next unless $tokens[2] =~ /^name:/;
	my @nametok = split(':',$tokens[2]);
	$lib{id} = $idtok[1];
	$lib{name} = $nametok[1];
	last;
    }
    close($fh);

    if (exists($lib{id})) {
        return \%lib;
    }
    return;
}

sub get_user {
    my $self = shift;
    my $id = shift;

    my %pat = ();
    open(my $fh, "<", $MOCKTEXTFILE) or die "$MOCKTEXTFILE: $!";
    while (<$fh>) {
	next unless /^patron/;
	my @tokens = split /\t/;
	next unless $tokens[1] =~ /^id:/;
	my @idtok = split(':',$tokens[1]);
	next unless $idtok[1] == $id;
	next unless $tokens[2] =~ /^name:/;
	my @nametok = split(':',$tokens[2]);
	next unless $tokens[3] =~ /^name_parts:/;
	my @partstok = split(':',$tokens[3]);
	my @parts = split('|',$partstok[1]);
	$pat{id} = $idtok[1];
	$pat{name} = $nametok[1];
	$pat{name_parts} = [@parts];
	last;
    }
    close($fh);

    if (exists($pat{id})) {
        return \%pat;
    }
    return;
}

1;
