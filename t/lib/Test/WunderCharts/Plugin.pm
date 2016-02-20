package Test::WunderCharts::Plugin;

use strict;
use warnings;

use Module::Load qw( load );
use Path::Tiny qw( path );
use Sub::Exporter -setup =>
    { exports => [ 'plugin_for_service', 'user_object_for_service' ] };

sub plugin_for_service {
    my $service      = shift;
    my $plugin_class = plugin_class_for_service($service);
    load($plugin_class);
    return $plugin_class->new(
        access_token    => 'foo',
        consumer_key    => 'bar',
        consumer_secret => 'baz',
        $plugin_class->can('_access_token_secret')
        ? ( access_token_secret => 'qux' )
        : (),
    );
}

sub user_object_for_service {
    my $service = shift;
    my $user    = shift;
    my $user_data
        = eval path( sprintf( 't/test-data/%s/User/%s.pl', $service, $user ) )
        ->slurp;

    my $class = plugin_class_for_service($service) . '::User';
    load($class);

    return $class->new( user => $user_data );
}

sub plugin_class_for_service {
    my $service = shift;
    return 'WunderCharts::Plugin::' . $service;
}

1;
