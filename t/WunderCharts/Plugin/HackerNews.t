use strict;
use warnings;

use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw(plugin_for_service);

my $plugin = plugin_for_service( 'HackerNews' );

my %resources = (
    'https://news.ycombinator.com/user?id=oalders'  => [ 'user', 'oalders', ],
    'https://news.ycombinator.com/item?id=11424372' => [ 'item', '11424372' ],
);

foreach my $resource ( keys %resources ) {
    my @detected = $plugin->detect_resource( $resource );
    is_deeply( \@detected, $resources{$resource}, $resource );
}

done_testing();
