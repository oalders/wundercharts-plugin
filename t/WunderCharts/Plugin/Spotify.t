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

done_testing();
