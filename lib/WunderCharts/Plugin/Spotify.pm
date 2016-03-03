package WunderCharts::Plugin::Spotify;

use Moo;
use MooX::StrictConstructor;

use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;
use WWW::Spotify ();
use Types::Standard qw( InstanceOf );
use URI                                 ();
use WunderCharts::Plugin::Spotify::User ();

has _client => (
    is => 'lazy',
    isa => InstanceOf ['WWW::Spotify'],
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _build__client {
    my $self = shift;

    return WWW::Spotify->new(
        current_access_token => $self->_access_token,
        oauth_client_id      => $self->_consumer_key,
        oauth_client_secret  => $self->_consumer_secret,
    );
}

sub _build_url_for_service { 'https://spotify.com' }

# use the id 'me' to get info about the user who is connecting
sub get_user_by_id {
    return shift->get_user_by_nick(@_);
}

sub get_user_by_nick {
    my $self = shift;
    my $id   = shift;

    my $user_json = $self->_client->user( $self->maybe_extract_id($id) );
    my $user      = decode_json($user_json);

    die 'user not retrieved: ' . np( $user->{error} )
        if exists $user->{error};

    return WunderCharts::Plugin::Spotify::User->new( raw => $user );
}

sub url_for_user {
    my $self = shift;
    my $id   = shift;

    return 'https://open.spotify.com/user/' . $id;
}

1;
