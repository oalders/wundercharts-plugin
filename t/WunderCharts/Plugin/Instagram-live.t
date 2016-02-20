use strict;
use warnings;

use Test::Fatal;
use Test::More skip_all => 'credentials required';
use Test::RequiresInternet ( 'api.instagram.com' => 443 );
use WunderCharts::Model;

use lib 't/lib';
use WunderCharts::Test::Fixtures;

my $fixtures = WunderCharts::Test::Fixtures->new;

my $plugin = plugin_for_service('Instagram');

{
    my $user = $plugin->get_user_by_nick('oalders');
    ok( $user, 'got oalders user' );
}

like(
    exception { $plugin->get_user_by_id('wundercounterx') },
    qr{404}, 'exception on user not found'
);

done_testing();
