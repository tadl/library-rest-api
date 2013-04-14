use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../library-rest.pl";

my $t = Test::Mojo->new;

$t->get_ok('/api/v0/library/1.json')
    ->status_is(200)
    ->json_has('/id')
    ->json_is('/id' => 1)
    ->json_has('/name');

$t->get_ok('/api/v0/library/100999.json')
    ->status_is(404);

done_testing();
