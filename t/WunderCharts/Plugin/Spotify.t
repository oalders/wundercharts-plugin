use strict;
use warnings;

use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Spotify');

my @urls = (
    'https://api.spotify.com/v1/users/oalders',
    'https://open.spotify.com/user/oalders',
    'https://play.spotify.com/user/oalders',
    'spotify:user:oalders',
);

foreach my $url (@urls) {
    is(
        $plugin->maybe_extract_id($url),
        'oalders', 'extracts id url with query'
    );
}

my %resources = (
    'spotify:artist:one' => [ 'artist', 'one' ],
    'spotify:track:two'  => [ 'track',  'two' ],
    'spotify:user:three' => [ 'user',   'three' ],
);

foreach my $uri ( keys %resources ) {
    is_deeply( [ $plugin->detect_resource($uri) ], $resources{$uri}, $uri );
}

done_testing();
