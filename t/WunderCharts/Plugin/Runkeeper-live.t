use strict;
use warnings;

use Test::Fatal qw( exception );
use Test::More;
use Test::RequiresInternet (
    'api.runkeeper.com' => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( is_live plugin_for_service );

my $service = 'Runkeeper';

SKIP: {
    skip 'No live config', 2 unless is_live($service);
    my $plugin = plugin_for_service($service);

    my @weight_series = $plugin->get_resource_series('weight');
    ok( @weight_series, 'got weight series' );

    # Assumes user has fat_percent measurements
    foreach my $item (@weight_series) {
        foreach my $trackable ( 'fat_percent', 'timestamp', 'weight' ) {
            ok(
                $item->$trackable,
                sprintf( '%s: %s', $trackable, $item->$trackable )
            );
        }
    }
}

done_testing();
