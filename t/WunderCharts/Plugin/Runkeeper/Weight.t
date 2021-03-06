use strict;
use warnings;

use lib 't/lib';

use Test::More;
use Test::WunderCharts::Plugin qw( resource_for_service );

my $weight = resource_for_service( 'Runkeeper', 'Weight', 'weight.json' );
ok( $weight, 'compiles' );

done_testing();
