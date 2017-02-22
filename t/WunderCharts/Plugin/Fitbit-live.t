use strict;
use warnings;

use DateTime ();
use Test::Fatal qw( exception );
use Test::More;
use Test::RequiresInternet (
    'api.fitbit.com' => 443,
);

use lib 't/lib';
use Test::WunderCharts::Plugin qw( is_live plugin_for_service trackables_ok );

my $service = 'Fitbit';

SKIP: {
    skip 'No live config', 2 unless is_live($service);
    my $plugin = plugin_for_service($service);

    my @series = $plugin->get_resource_series(
        'activity',
        DateTime->now->subtract( days => 7 )
    );
    ok( @series, 'got weight series' );

    trackables_ok($_) for @series;
}

done_testing();
