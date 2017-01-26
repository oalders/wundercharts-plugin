package WunderCharts::Plugin::Reddit;

use Moo;
use MooX::StrictConstructor;

use Types::Standard qw( InstanceOf );
use WebService::Reddit ();
use WunderCharts::Plugin::Reddit::User  ();

has _client => (
    is  => 'lazy',
    isa => InstanceOf ['WebService::Reddit'],
);

with(
    'WunderCharts::Plugin::Role::HasGetResourceByID',
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasMechUserAgent',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _build_service_url { 'https://www.reddit.com' }

sub detect_resource {
    my $self = shift;
    my $arg  = shift;

    if ( substr( $arg, 0, 1 ) eq '@' ) {
        return ( 'user', substr( $arg, 1 ) );
    }

    return ( 'user', $arg ) if $arg !~ m{[^0-9A-Za-z]};

    my $uri = URI->new($arg);

    # toss out empty strings
    my @parts = grep { $_ } $uri->path_segments;
    if ( $parts[0] && $parts[0] eq 'r' ) {
        return ( 'subreddit', $parts[1] );
    }

    return ( 'user', $parts[0] );

    die "$arg does not appear to be a valid Reddit resource.";
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

sub get_user_by_nick {
    my $self = shift;
    my $nick   = shift;

    my $uri = sprintf '/user/%s/about', $nick;

    return WunderCharts::Plugin::Reddit::User->new(
        raw => $self->_client->get($uri)->content->{data} );
}

# use the id 'me' to get info about the user who is connecting
sub get_subreddit_by_nick {
    my $self = shift;
    my $nick   = shift;

    my $uri = sprintf '/r/%s/about', $nick;

    return WunderCharts::Plugin::Reddit::Subreddit->new(
        raw => $self->_client->get($uri)->content->{data} );
}

sub url_for_user {
    my $self     = shift;
    my $username = shift;

    my $url = $self->service_url->clone;
    $url->path('/user/' . $username);
    return $url;
}

1;
