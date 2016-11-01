use strict;
use warnings;

use Test::Fatal qw( exception );
use Test::Most;

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service);

my $plugin = plugin_for_service('Runkeeper');

ok( $plugin, 'got plugin');

done_testing();
