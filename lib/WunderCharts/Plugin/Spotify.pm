package WunderCharts::Plugin::Spotify;

use Moo;
use MooX::StrictConstructor;

use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;
use List::AllUtils qw( any );
use Types::Standard qw( InstanceOf );
use URI                                   ();
use WunderCharts::Plugin::Spotify::Artist ();
use WunderCharts::Plugin::Spotify::Track  ();
use WunderCharts::Plugin::Spotify::User   ();
use WWW::Spotify                          ();

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

=head2 get_resource

Given a string, this method will try to determine which Spotify resource it
belongs to, currently a user or a track.

    spotify:artist:0OdUWJ0sBjDrqHygGUXeCF
    spotify:track:0eGsygTp906u18L0Oimnem
    spotify:user:oalders

=cut

sub _handle_response {
    my $self     = shift;
    my $resource = shift;
    my $id       = shift;

    my $raw = decode_json(
        $self->_client->$resource( $self->maybe_extract_id($id) ) );

    die "$resource $id not retrieved " . np( $raw->{error} )
        if exists $raw->{error};
    return $raw;
}

sub detect_resource {
    my $self = shift;
    my $arg  = shift;

    if ( $arg =~ m{\Aspotify:(artist|track|user):([0-9a-zA-Z]*)\z} ) {
        return ( $1, $2 );
    }

    # https://open.spotify.com/user/oalders
    # https://play.spotify.com/user/oalders

    if ( $arg =~ m{\Ahttp} ) {
        my $uri      = URI->new($arg);
        my @segments = $uri->path_segments;
        return ( $segments[1], $segments[2] );
    }
}

sub get_resource {
    my $self = shift;
    my $arg  = shift;

    my ( $resource, $id ) = $self->detect_resource($arg);

    my $method = 'get_' . $resource . '_by_id';
    return $self->$method($id);
}

# use the id 'me' to get info about the user who is connecting
sub get_user_by_id {
    return shift->get_user_by_nick(@_);
}

sub get_artist_by_id {
    my $self = shift;
    my $id   = shift;

    return WunderCharts::Plugin::Spotify::Artist->new(
        raw => $self->_handle_response( 'artist', $id ) );
}

sub get_track_by_id {
    my $self = shift;
    my $id   = shift;

    return WunderCharts::Plugin::Spotify::Track->new(
        raw => $self->_handle_response( 'track', $id ) );
}

sub get_user_by_nick {
    my $self = shift;
    my $id   = shift;

    my $raw = $self->_handle_response( 'user', $id );
    return WunderCharts::Plugin::Spotify::User->new( raw => $raw );
}

sub url_for_user {
    my $self = shift;
    my $id   = shift;

    return 'https://open.spotify.com/user/' . $id;
}

1;
