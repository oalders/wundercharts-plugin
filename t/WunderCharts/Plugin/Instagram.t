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

done_testing();
