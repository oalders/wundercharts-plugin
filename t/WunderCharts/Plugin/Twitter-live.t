use strict;
use warnings;

use Test::Fatal;
use Test::More;
use Test::RequiresInternet (
    'api.twitter.com' => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Twitter');

SKIP: {
    skip 'No live config', 3 unless $config->{live};

    my $plugin = plugin_for_service('Twitter');
    {
        my $user = $plugin->get_user_by_nick('wundercounter');
        ok( $user, 'got wundercounter user' );
    }

    {
        my $user = $plugin->get_user(29385636);
        ok( $user, 'got wundercounter user' );
    }

    like(
        exception { $plugin->get_user('wundercounterx') },
        qr{User not found},
        'exception on user not found'
    );
}

done_testing();
