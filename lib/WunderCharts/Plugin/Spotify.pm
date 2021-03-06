package WunderCharts::Plugin::Spotify;

use Moo;
use MooX::StrictConstructor;

use Cpanel::JSON::XS qw( decode_json );
use Data::Printer;
use Types::Standard qw( InstanceOf );
use URI                                   ();
use WunderCharts::Plugin::Spotify::Album  ();
use WunderCharts::Plugin::Spotify::Artist ();
use WunderCharts::Plugin::Spotify::Track  ();
use WunderCharts::Plugin::Spotify::User   ();
use WWW::Spotify                          ();

has _client => (
    is  => 'lazy',
    isa => InstanceOf ['WWW::Spotify'],
);

with(
    'WunderCharts::Plugin::Role::HasGetResourceByID',
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

sub _build_service_url { 'https://spotify.com' }

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

    if ( substr( $arg, 0, 1 ) eq '@' ) {
        return ( 'user', substr( $arg, 1 ) );
    }

    return ( 'user', $arg ) if $arg !~ m{[^0-9A-Za-z]};

    if ( $arg =~ m{\Aspotify:(album|artist|track|user):([0-9a-zA-Z]*)\z} ) {
        return ( $1, $2 );
    }

    # https://open.spotify.com/album/7kMnBrFZfdqSWQBGW0wAyz
    # https://open.spotify.com/artist/11zHPjHnZN0ACA50rSnTcy
    # https://open.spotify.com/user/oalders
    # https://play.spotify.com/user/oalders

    if ( $arg =~ m{\Ahttp}i ) {
        my $uri      = URI->new($arg);
        my @segments = $uri->path_segments;
        return ( $segments[1], $segments[2] );
    }

    die "$arg does not appear to be a valid Spotify resource.";
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

sub get_album_by_id {
    my $self = shift;
    my $id   = shift;

    return WunderCharts::Plugin::Spotify::Album->new(
        raw => $self->_handle_response( 'album', $id ) );
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
    my $nick = shift;
    return 'https://open.spotify.com/user/' . $nick;
}

1;
__END__

# ABSTRACT: Use the Spotify API to look up resources

=head2 get_resource( $str )

Call this method if you don't know what type of resource you're requesting.
You can pass a Spotify URI or username.  This method will attempt to detect the
resource you're requesting and will return an appropriate object for the
resource.

=head2 get_resource_by_id( $resource_type, $id )

Call this method if you know the resource and the id of the resource you're
looking for.

    my $plugin   = WunderCharts::Plugin::Spotify->new(...);
    my $id       = '0eGsygTp906u18L0Oimnem';
    my $resource = $plugin->get_resource_by_id( 'track', $id );

    # If successful, $resource returns a WunderCharts::Plugin::Spotify::Track
    # object.

Valid resource types are C<artist>, C<track> and C<user>.

=
