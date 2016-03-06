package WunderCharts::Plugin::Instagram;

use Moo;
use MooX::StrictConstructor;

use Cpanel::JSON::XS qw( decode_json );
use Types::Standard qw( InstanceOf );
use URI::FromHash qw(uri);
use WunderCharts::Plugin::Instagram::User ();

has _client => (
    is => 'lazy',
    isa => InstanceOf ['API::Instagram'],
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasMechUserAgent',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _build_url_for_service { 'https://instagram.com' }

# use the id 'me' to get info about the user who is connecting
sub get_user_by_id {
    my $self = shift;
    my $id   = shift;

    my $uri = uri(
        scheme => 'https',
        host   => 'api.instagram.com',
        path   => '/v1/users/' . $id,
        query  => { access_token => $self->_access_token }
    );

    return WunderCharts::Plugin::Instagram::User->new(
        raw => $self->_get_url($uri) );
}

sub get_user_by_nick {
    my $self = shift;
    my $nick = shift;
    $nick = $self->maybe_extract_id($nick);

    my $uri = uri(
        scheme => 'https',
        host   => 'api.instagram.com',
        path   => '/v1/users/search',
        query  => { access_token => $self->_access_token, q => $nick, }
    );

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

sub url_for_user {
    my $self = shift;
    my $id   = shift;

    return 'https://instagram.com/' . $id;
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

1;
