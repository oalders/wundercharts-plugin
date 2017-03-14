use strict;
use warnings;

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

my %resources = (
    '@cpan_new'                         => [ 'user', 'cpan_new' ],
    'https://twitter.com/cpan_new'      => [ 'user', 'cpan_new' ],
    'https://twitter.com/wundercounter' => [ 'user', 'wundercounter' ],
    'https://twitter.com/wundercounter/status/570454045099307008' =>
        [ 'status', '570454045099307008' ],
);

foreach my $resource ( sort keys %resources ) {
    is_deeply(
        [ $plugin->detect_resource($resource) ],
        $resources{$resource}, 'detected resource for ' . $resource
    );
}

done_testing();
