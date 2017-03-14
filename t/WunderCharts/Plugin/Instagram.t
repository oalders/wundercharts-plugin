use strict;
use warnings;

use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Instagram');

my @urls = ( 'https://instagram.com/oalders', );

foreach my $url (@urls) {
    is(
        $plugin->maybe_extract_id($url),
        'oalders', 'extracts id url with query'
    );
}

my %things = (
    'https://instagram.com/oalders' => [ 'user', 'oalders' ],
    'https://www.instagram.com/p/dmQVviwWoQ/?taken-by=oalders' =>
        [ 'media', 'dmQVviwWoQ' ],
    '@oalders' => [ 'user', 'oalders' ],
    'o.alders' => [ 'user', 'o.alders' ],
    'oalders'  => [ 'user', 'oalders' ],
);

foreach my $thing ( keys %things ) {
    is_deeply(
        [ $plugin->detect_resource($thing) ], $things{$thing},
        "detected resource $thing"
    );
}

done_testing();
