use strict;
use warnings;

use Test::Fatal qw( exception );
use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Spotify');

my %resources = (
    'https://open.spotify.com/album/0sNOF9WDwhWunNAHPD3Baj' =>
        [ 'album', '0sNOF9WDwhWunNAHPD3Baj' ],
    'https://open.spotify.com/user/oalders' => [ 'user',   'oalders' ],
    'https://play.spotify.com/user/oalders' => [ 'user',   'oalders' ],
    '@oalders'                              => [ 'user',   'oalders' ],
    'oalders'                               => [ 'user',   'oalders' ],
    'spotify:artist:one'                    => [ 'artist', 'one' ],
    'spotify:track:two'                     => [ 'track',  'two' ],
    'spotify:user:three'                    => [ 'user',   'three' ],
);

foreach my $uri ( keys %resources ) {
    is_deeply( [ $plugin->detect_resource($uri) ], $resources{$uri}, $uri );
}

like(
    exception { $plugin->detect_resource('!oalders') },
    qr{does not appear to be a valid Spotify resource},
    'exception on resource not found'
);

done_testing();
