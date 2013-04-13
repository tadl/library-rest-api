use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../library-rest.pl";

my $t = Test::Mojo->new;

$t->get_ok('/')
    ->status_is(200)
    ->element_exists('pre');

done_testing();
