use strict;
use warnings;

use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Github');

my @urls = (
    'https://github.com/oalders',
    'https://github.com/oalders/wundercharts-plugin'
);

foreach my $url (@urls) {
    is(
        $plugin->maybe_extract_id($url),
        'oalders', 'extracts id url with query'
    );
}

is(
    $plugin->url_for( 'user', 'oalders' ), 'https://github.com/oalders',
    'url_for user'
);

my %resources = (
    'git@github.com:oalders/http-browserdetect.git' =>
        [ 'repo', 'oalders', 'http-browserdetect' ],
    'https://github.com/oalders/' => [ 'user', 'oalders' ],
    'https://github.com/oalders/http-browserdetect/' =>
        [ 'repo', 'oalders', 'http-browserdetect' ],
    'https://github.com/oalders/http-browserdetect.git' =>
        [ 'repo', 'oalders', 'http-browserdetect' ],
    '@oalders' => [ 'user', 'oalders' ],
    'oalders'  => [ 'user', 'oalders' ],
    'oalders/http-browserdetect' =>
        [ 'repo', 'oalders', 'http-browserdetect' ],

);

foreach my $resource ( keys %resources ) {
    my @detected = $plugin->detect_resource($resource);
    is_deeply( \@detected, $resources{$resource}, $resource );
}

done_testing();
