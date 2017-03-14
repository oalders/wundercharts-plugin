package WunderCharts::Plugin::Fitbit;

use Moo;
use MooX::StrictConstructor;

use Data::Printer;
use DateTime ();
use Types::Standard qw( InstanceOf );
use WebService::Fitbit                 ();
use WunderCharts::Plugin::Fitbit::Activity ();
use WunderCharts::Plugin::Fitbit::User ();

has _client => (
    is  => 'lazy',
    isa => InstanceOf ['WebService::Fitbit'],
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasMechUserAgent',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
    'WunderCharts::Plugin::Role::RequiresOAuthRefreshToken',
);

sub _build__client {
    my $self = shift;
    return WebService::Fitbit->new(
        access_token  => $self->_access_token,
        app_key       => $self->_consumer_key,
        app_secret    => $self->_consumer_secret,
        refresh_token => $self->_refresh_token,
        ua            => $self->_user_agent,
    );
}

sub _build_service_url { 'https://www.fitbit.com' }

sub get_resource_series {
    my $self          = shift;
    my $resource_type = shift;
    my $cutoff        = shift;

    my $method = 'get_' . $resource_type . '_series';
    return $self->$method($cutoff);
}

sub get_activity_series {
    my $self     = shift;
    my $earliest = shift;
    my $latest   = shift || DateTime->now->truncate( to => 'day' );

    my $i = 0;
    my @series;

    while (1) {
        my $dt = $earliest->clone->add( days => $i );
        my $uri = sprintf '/1/user/-/activities/date/%s.json', $dt->ymd;
        my $res = $self->_client->get($uri);

        die sprintf 'Cannot fetch activity for %s (%s)', $dt->ymd, np($res)
            unless $res->success;

        push @series,
            WunderCharts::Plugin::Fitbit::Activity->new(
            raw => $res->content );
        last if $dt->ymd eq $latest->ymd;
        $i++;
    }
    return @series;
}
1;
__END__

# ABSTRACT: Use the Fitbit API to look up resources

=head2 get_resource_series( $resource_type )

Returns a list of resources for the given type.

    my $plugin   = WunderCharts::Plugin::Fitbit->new(...);
    my $resource = $plugin->get_resource_series( 'activity' );

    # If successful, $resource returns an ArrayRef of
    # WunderCharts::Plugin::Fitbit::Activity objects.

Valid resource types are C<activity>.

=cut
