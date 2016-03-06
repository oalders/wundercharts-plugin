use strict;
use warnings;

use Test::Fatal;
use Test::More;
use Test::RequiresInternet (
    'accounts.spotify.com' => 443,
    'api.spotify.com'      => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Spotify');

SKIP: {
    skip 'No live config', 2 unless $config->{live};
    my $plugin = plugin_for_service('Spotify');

    {
        my $user = $plugin->get_user_by_nick('oalders');
        ok( $user, 'got oalders user' );
    }

    my $artist
        = $plugin->get_resource('spotify:artist:0OdUWJ0sBjDrqHygGUXeCF');
    is( $artist->name, 'Band of Horses', 'Artist name' );

    my $track = $plugin->get_resource('spotify:track:0eGsygTp906u18L0Oimnem');
    is( $track->name, 'Mr. Brightside', 'Track name' );

    like(
        exception { $plugin->get_user_by_id('wundercounterx') },
        qr{404}, 'exception on user not found'
    );
}

done_testing();
