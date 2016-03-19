package WunderCharts::Plugin::Twitter;

use Moo;
use MooX::StrictConstructor;

use Net::Twitter;
use Types::Standard qw( InstanceOf );
use WunderCharts::Plugin::Twitter::Status;
use WunderCharts::Plugin::Twitter::User;

has _client => (
    is => 'lazy',
    isa => InstanceOf ['Net::Twitter'],
);

with(
    'WunderCharts::Plugin::Role::HasGetResourceByID',
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth',
);

# Using our own UA leads to JSON parsing errors in Net::Twitter.  Enabling
# debug_ua() will similarly lead to JSON errors, so only turn it on with the
# expectation that you'll see what's going on under the hood but that parsing
# will fail.

sub _build__client {
    my $self = shift;

    my $nt = Net::Twitter->new(
        access_token        => $self->_access_token,
        access_token_secret => $self->_access_token_secret,
        consumer_key        => $self->_consumer_key,
        consumer_secret     => $self->_consumer_secret,
        traits              => ['API::RESTv1_1'],
        useragent_class     => 'LWP::UserAgent',
    );

    if ( $ENV{WC_UA_DEBUG} ) {
        debug_ua( $nt->ua, $ENV{WC_UA_DEBUG} );
    }
    return $nt;
}

sub _build_url_for_service { 'https://twitter.com/' }

sub _user_agent {
    my $self = shift;
    return $self->_client->ua;
}

sub detect_resource {
    my $self = shift;
    my $arg  = shift;

    if ( substr( $arg, 0, 1 ) eq '@' ) {
        return ( 'user', substr( $arg, 1 ) );
    }

    return ( 'user', $arg ) if $arg !~ m{[^0-9A-Za-z]};

    # https://twitter.com/wundercounter
    # https://twitter.com/wundercounter/status/570454045099307008

    if ( $arg =~ m{\Ahttp} ) {
        my $uri = URI->new($arg);
        my @segments = grep { $_ } $uri->path_segments;
        if ( @segments == 1 ) {
            return ( 'user', $segments[0] );
        }
        if ( $segments[1] eq 'status' ) {
            return ( 'status', $segments[2] );
        }
    }

    die "$arg does not appear to be a valid Twitter resource.";
}

# Expects an id assigned by the API -- usually a number
sub get_user_by_id {
    my $self = shift;
    my $id   = shift;

    my $raw = $self->_client->show_user( { user_id => $id } );

    return WunderCharts::Plugin::Twitter::User->new( raw => $raw );
}

# search for user via @nick
sub get_user_by_nick {
    my $self = shift;

    my $id  = $self->maybe_extract_id(shift);
    my $raw = $self->_client->show_user($id);

    return WunderCharts::Plugin::Twitter::User->new( raw => $raw );
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

sub get_status_by_id {
    my $self = shift;
    my $id   = shift;

    my $raw = $self->_client->show_status($id);
    return WunderCharts::Plugin::Twitter::Status->new( raw => $raw );
}

sub url_for {
    my $self          = shift;
    my $resource_type = shift;
    my $id            = shift;

    return $self->url_for_user($id) if $resource_type eq 'user';
}

1;
