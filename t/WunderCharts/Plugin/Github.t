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

done_testing();
