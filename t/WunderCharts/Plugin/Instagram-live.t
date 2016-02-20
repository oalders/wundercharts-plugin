use strict;
use warnings;

use Test::Fatal;
use Test::More;
use Test::RequiresInternet ( 'api.instagram.com' => 443 );

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Instagram');

SKIP: {
    skip 'No live config', 2 unless $config->{live};

    my $plugin = plugin_for_service('Instagram');

    {
        my $user = $plugin->get_user_by_nick('oalders');
        ok( $user, 'got oalders user' );
    }

    like(
        exception { $plugin->get_user_by_id('wundercounterx') },
        qr{404}, 'exception on user not found'
    );
}

done_testing();
