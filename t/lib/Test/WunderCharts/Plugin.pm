package Test::WunderCharts::Plugin;

use strict;
use warnings;
use feature qw( state );

use Module::Load qw( load );
use Path::Tiny qw( path );
use Sub::Exporter -setup => {
    exports => [
        'config_for_service', 'plugin_for_service', 'user_object_for_service'
    ]
};

sub config {
    state $config;
    return $config if $config;

    my $file = path('config.pl');
    if ( $file->exists ) {
        $config = eval $file->slurp;
    }
    return $config;
}

sub config_for_service {
    my $service = shift;
    my $config  = config();
    if ($config) {
        return $config->{$service};
    }
    return {
        access_token        => 'foo',
        access_token_secret => 'qux',
        consumer_key        => 'bar',
        consumer_secret     => 'baz',
        live                => 0,
    };
}

sub plugin_for_service {
    my $service      = shift;
    my $plugin_class = plugin_class_for_service($service);
    load($plugin_class);
    my $config = config_for_service($service);
    return $plugin_class->new(
        access_token    => $config->{access_token},
        consumer_key    => $config->{consumer_key},
        consumer_secret => $config->{consumer_secret},
        $plugin_class->can('_access_token_secret')
        ? ( access_token_secret => $config->{access_token_secret} )
        : (),
    );
}

sub user_object_for_service {
    my $service = shift;
    my $user    = shift;

    my $file
        = path( sprintf( 't/test-data/%s/User/%s.pl', $service, $user ) );
    die "$file not found" unless $file->exists;

    my $user_data = eval $file->slurp;

    my $class = plugin_class_for_service($service) . '::User';
    load($class);

    return $class->new( user => $user_data );
}

sub plugin_class_for_service {
    my $service = shift;
    return 'WunderCharts::Plugin::' . $service;
}

1;
