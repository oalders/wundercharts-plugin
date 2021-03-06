package Test::WunderCharts::Plugin;

use strict;
use warnings;
use feature qw( state );

use Cpanel::JSON::XS qw( decode_json );
use Module::Load qw( load );
use Path::Tiny qw( path );
use Sub::Exporter -setup => {
    exports => [
        'config_for_service',   'is_live',       'plugin_for_service',
        'resource_for_service', 'trackables_ok', 'user_object_for_service'
    ]
};
use Test::Fatal qw( lives_ok );

## no critic (BuiltinFunctions::ProhibitStringyEval)

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
    my $service = lc shift;
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
        refresh_token       => 'seekrit',
    };
}

sub is_live {
    my $service = shift;
    return config_for_service($service)->{live};
}

sub plugin_for_service {
    my $service      = shift;
    my $plugin_class = plugin_class_for_service($service);
    load($plugin_class);

    # Some classes don't require any kind of auth
    unless ( $plugin_class->can('_access_token') ) {
        return $plugin_class->new;
    }

    my $config = config_for_service($service);
    return $plugin_class->new(
        access_token    => $config->{access_token},
        consumer_key    => $config->{consumer_key},
        consumer_secret => $config->{consumer_secret},
        $plugin_class->can('_access_token_secret')
        ? ( access_token_secret => $config->{access_token_secret} )
        : (),
        $plugin_class->can('_refresh_token')
        ? ( refresh_token => $config->{refresh_token} )
        : (),
    );
}

sub resource_for_service {
    my $service  = shift;
    my $resource = shift;
    my $filename = shift;

    my $file
        = path(
        sprintf( 't/test-data/%s/%s/%s', $service, $resource, $filename ) );
    die "$file not found" unless $file->exists;

    my $data;
    if ( $filename =~ m{\.pl\z} ) {
        $data = eval $file->slurp;
        die 'user data does not eval' unless $data;
    }
    elsif ( $filename =~ m{\.json} ) {
        $data = decode_json( $file->slurp );
    }

    my $class = plugin_class_for_service($service) . "::$resource";
    load($class);

    my $obj = $class->new( raw => $data );
    trackables_ok($obj);
    return $obj;
}

sub user_object_for_service {
    my $service   = shift;
    my $user_file = shift;

    my $file
        = path( sprintf( 't/test-data/%s/User/%s', $service, $user_file ) );
    die "$file not found" unless $file->exists;

    my $user_data;
    if ( $user_file =~ m{\.pl\z} ) {
        $user_data = eval $file->slurp;
        die 'user data does not eval' unless $user_data;
    }
    elsif ( $user_file =~ m{\.json} ) {
        $user_data = decode_json( $file->slurp );
    }

    my $class = plugin_class_for_service($service) . '::User';
    load($class);

    return $class->new( raw => $user_data );
}

sub plugin_class_for_service {
    my $service = shift;
    return 'WunderCharts::Plugin::' . $service;
}

sub trackables_ok {
    my $obj = shift;
    foreach my $trackable ( @{ $obj->trackables } ) {
        lives_ok { $obj->$trackable }
        "$trackable: " . ( $obj->$trackable || q{} );
    }
}
1;
