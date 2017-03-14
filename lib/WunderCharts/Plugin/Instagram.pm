package WunderCharts::Plugin::Instagram;

use Moo;
use MooX::StrictConstructor;

use Cpanel::JSON::XS qw( decode_json );
use Types::Standard qw( InstanceOf );
use URI::FromHash qw(uri);
use WunderCharts::Plugin::Instagram::Image ();
use WunderCharts::Plugin::Instagram::User  ();
use WunderCharts::Plugin::Instagram::Video ();

has _client => (
    is  => 'lazy',
    isa => InstanceOf ['API::Instagram'],
);

with(
    'WunderCharts::Plugin::Role::HasGetResourceByID',
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasMechUserAgent',
    'WunderCharts::Plugin::Role::Instagram::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _create_uri {
    my $self  = shift;
    my $path  = shift;
    my $query = shift || {};

    return uri(
        scheme => 'https',
        host   => 'api.instagram.com',
        path   => '/v1/' . $path,
        query  => { access_token => $self->_access_token, %{$query} },
    );
}

sub detect_resource {
    my $self = shift;
    my $arg  = shift;

    if ( substr( $arg, 0, 1 ) eq '@' ) {
        return ( 'user', substr( $arg, 1 ) );
    }

    return ( 'user', $arg ) if $arg !~ m{[^0-9A-Za-z\.]};

    my $uri = URI->new($arg);

    # toss out empty strings
    my @parts = grep { $_ } $uri->path_segments;
    if ( $parts[0] && $parts[0] eq 'p' ) {
        return ( 'media', $parts[1] );
    }

    return ( 'user', $parts[0] );
}

sub get_image_by_id {
    my $self = shift;
    return $self->get_media_by_id(@_);
}

sub get_media_by_id {
    my $self = shift;
    my $id   = shift;

    my $uri;

    # looks like a shortcode
    if ( $id =~ m{[a-zA-Z]} ) {
        $uri = $self->_create_uri( 'media/shortcode/' . $id );
    }
    else {
        $uri = $self->_create_uri( 'media/' . $id );
    }

    my $raw   = $self->_get_url($uri);
    my $class = 'WunderCharts::Plugin::Instagram::' . ucfirst $raw->{type};

    return $class->new( raw => $self->_get_url($uri) );
}

sub get_resource {
    my $self = shift;
    my $name = shift;

    my @resource = $self->detect_resource($name);
    if ( $resource[0] eq 'user' && $resource[1] =~ m{[a-zA-Z]} ) {
        return $self->get_user_by_nick( $resource[1] );
    }
    return $self->get_resource_by_id(@resource);
}

sub _get_url {
    my $self = shift;
    my $uri  = shift;
    my $res  = $self->_user_agent->get($uri);

    unless ( $res->code == 200 ) {
        die sprintf 'Could not fetch %s (status code %s)', $uri, $res->code;
    }

    my $json = decode_json( $res->decoded_content );

    unless ( $json->{meta}->{code} == 200 ) {
        die np($json);
    }
    return $json->{data};
}

# use the id 'me' to get info about the user who is connecting
sub get_user_by_id {
    my $self = shift;
    my $id   = shift;

    my $uri = $self->_create_uri( 'users/' . $id );

    return WunderCharts::Plugin::Instagram::User->new(
        raw => $self->_get_url($uri) );
}

sub get_user_by_nick {
    my $self = shift;
    my $nick = shift;
    $nick = $self->maybe_extract_id($nick);

    my $uri = $self->_create_uri( 'users/search', { q => $nick } );

    my @users = @{ $self->_get_url($uri) };

    # User object returned via search URL does not contain the "counts" key,
    # so we'll make a second API call to get that.
    # See https://www.instagram.com/developer/endpoints/users/
    foreach my $user (@users) {
        if ( $user->{username} eq $nick ) {
            return $self->get_user_by_id( $user->{id} );
        }
    }
}

sub get_video_by_id {
    my $self = shift;
    return $self->get_media_by_id(@_);
}

1;
