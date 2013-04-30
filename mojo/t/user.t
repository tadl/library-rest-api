use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../library-rest.pl";

my $t = Test::Mojo->new;

$t->get_ok('/api/user/1.json')
    ->status_is(200)
    ->json_has('/id')
    ->json_is('/id' => 1)
    ->json_has('/name')
    ->json_has('/name_parts');

$t->get_ok('/api/user/100999.json')
    ->status_is(404);

done_testing();
