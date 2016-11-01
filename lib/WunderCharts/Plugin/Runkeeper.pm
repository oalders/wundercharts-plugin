package WunderCharts::Plugin::Runkeeper;

use Moo;
use MooX::StrictConstructor;

use Cpanel::JSON::XS qw( decode_json );
use Types::Standard qw( InstanceOf );
use WebService::HealthGraph 0.000004 ();
use WunderCharts::Plugin::Runkeeper::Weight ();

has _client => (
    is  => 'lazy',
    isa => InstanceOf ['WebService::HealthGraph'],
);

with(
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _build__client {
    my $self = shift;

    return WebService::HealthGraph->new(
        debug => $ENV{WC_UA_DEBUG} ? 1 : 0,
        token => $self->_access_token,
    );
}

sub _build_service_url { 'https://runkeeper.com' }

sub get_resource_series {
    my $self          = shift;
    my $resource_type = shift;
    my $cutoff        = shift;

    my $method = 'get_' . $resource_type . '_series';
    return $self->$method($cutoff);
}

sub get_weight_series {
    my $self   = shift;
    my $cutoff = shift;

    my $uri = $self->_client->uri_for(
        'weight',
        {
            $cutoff ? ( noEarlierThan => $cutoff->ymd ) : (),
            pageSize => 100,
        },
    );

    my $feed = $self->_client->get( $uri, { feed => 1 } );

    my @series;
    while ( my $item = $feed->next ) {
        push @series,
            WunderCharts::Plugin::Runkeeper::Weight->new( raw => $item );
    }
    return @series;
}

1;
__END__

# ABSTRACT: Use the Runkeeper API to look up resources

=head2 get_resource_series( $resource_type )

Returns a list of resources for the given type.

    my $plugin   = WunderCharts::Plugin::Runkeeper->new(...);
    my $resource = $plugin->get_resource_series( 'weight' );

    # If successful, $resource returns an ArrayRef of
    # WunderCharts::Plugin::Runkeeper::Weight objects.

Valid resource types are C<weight> and C<fitness_activity>.

=
