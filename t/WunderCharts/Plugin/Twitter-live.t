use strict;
use warnings;

use Test::Fatal qw( exception );
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
        my $user = $plugin->get_user_by_id(29385636);
        ok( $user, 'got wundercounter user' );
    }

    {
        my $status = $plugin->get_status_by_id(570454045099307008);
        ok( $status, 'got wundercounter status' );
    }

    {
        ok(
            $plugin->get_resource(
                'https://twitter.com/wundercounter/status/570454045099307008'
            ),
            'get_resource via status url'
        );
    }

    {
        ok(
            $plugin->get_resource('https://twitter.com/wundercounter'),
            'get_resource via user url'
        );
    }

    {
        ok(
            $plugin->get_resource('wundercounter'),
            'get_resource via nick'
        );
    }

    {
        ok(
            $plugin->get_resource('@wundercounter'),
            'get_resource via @nick'
        );
    }

    like(
        exception { $plugin->get_user_by_nick('wundercounterx') },
        qr{User not found},
        'exception on user not found'
    );
}

done_testing();
