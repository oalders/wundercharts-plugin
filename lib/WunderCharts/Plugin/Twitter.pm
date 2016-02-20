package WunderCharts::Plugin::Twitter;

use Moo;
use MooX::StrictConstructor;

use Net::Twitter;
use Types::Standard qw( InstanceOf );
use WunderCharts::Plugin::Twitter::User;

has _client => (
    is => 'lazy',
    isa => InstanceOf ['Net::Twitter'],
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasUserAgent',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth',
);

sub _build__client {
    my $self = shift;

    return Net::Twitter->new(
        consumer_key        => $self->_consumer_key,
        consumer_secret     => $self->_consumer_secret,
        traits              => ['API::RESTv1_1'],
        ua                  => $self->_user_agent,
        access_token        => $self->_access_token,
        access_token_secret => $self->_access_token_secret,
    );
}

sub _build_url_for_service { 'https://twitter.com/' }

# Expects an id assigned by the API -- usually a number
sub get_user {
    my $self = shift;
    my $id   = shift;

    my $info = $self->_client->show_user( { user_id => $id } );

    return WunderCharts::Plugin::Twitter::User->new( user => $info );
}

# search for user via @nick
sub get_user_by_nick {
    my $self = shift;

    my $id   = $self->maybe_extract_id(shift);
    my $info = $self->_client->show_user($id);

    return WunderCharts::Plugin::Twitter::User->new( user => $info );
}

1;
