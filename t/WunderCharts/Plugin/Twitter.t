use strict;
use warnings;

use Test::Fatal;
use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Twitter');

is(
    $plugin->maybe_extract_id(
        'https://twitter.com/rjbs?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor'
    ),
    'rjbs',
    'extracts id url with query'
);

done_testing();
