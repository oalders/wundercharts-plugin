package WunderCharts::Plugin::Facebook;

use Moo;
use MooX::StrictConstructor;

use Facebook::Graph          ();
use Facebook::Graph::Request ();
use Try::Tiny qw( catch try );
use Types::Standard qw( InstanceOf );
use URI                                   ();
use URI::QueryParam                       ();
use WunderCharts::Plugin::Facebook::Photo ();
use WunderCharts::Plugin::Facebook::User  ();

has _client => (
    is      => 'lazy',
    isa     => InstanceOf ['Facebook::Graph'],
    handles => { fetch => 'fetch' },
);

with(
    'WunderCharts::Plugin::Role::HasIDFilter',
    'WunderCharts::Plugin::Role::HasServiceURL',
    'WunderCharts::Plugin::Role::HasLWPUserAgent',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::RequiresOAuth2',
);

sub _build__client {
    my $self = shift;

    return Facebook::Graph->new(
        app_id       => $self->_consumer_key,
        secret       => $self->_consumer_secret,
        access_token => $self->_access_token,
    );
}

sub _build_url_for_service { 'https://facebook.com' }

# use the id 'me' to get info about the user who is connecting
sub get_user_by_id {
    return shift->get_user_by_nick(@_);
}

sub get_user_by_nick {
    my $self = shift;
    my $id   = shift;

    my $info = $self->_client->fetch( $self->maybe_extract_id($id) );

    return WunderCharts::Plugin::Facebook::User->new( raw => $info );
}

sub get_object {
    my $self = shift;
    my $id   = shift;

    my $raw;

    try {
        $raw
            = $self->_client->query->find($id)
            ->include_metadata->select_fields( 'id', 'name', )
            ->request( ua => $self->_user_agent )->as_hashref;
    }
    catch {
        die "Cannot fetch data for $id";
    };

    my $resource = $raw->{metadata}->{type};
    my $class    = 'WunderCharts::Plugin::Facebook::' . ucfirst($resource);
    my %args     = (
        raw          => $raw,
        raw_comments => $self->_get_metadata_summary( $raw, 'comments' ),
        raw_likes    => $self->_get_metadata_summary( $raw, 'likes' ),
    );

    return $class->new(%args);
}

sub _get_metadata_summary {
    my $self = shift;
    my $raw  = shift;
    my $type = shift;

    my $link = $raw->{metadata}->{connections}->{$type};
    my $uri  = URI->new($link);
    $uri->query_param( summary => 1 );

    my $summary;
    try {
        $summary = Facebook::Graph::Request->new( ua => $self->_user_agent )
            ->get($uri)->as_hashref;
    }
    catch {
        die "Cannot get metadata summary for $type";
    };

    return $summary;
}

1;
