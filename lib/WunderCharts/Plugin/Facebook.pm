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
use WunderCharts::Plugin::Facebook::Page  ();

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
sub get_page_by_id {
    return shift->get_user_by_nick(@_);
}

sub get_page_by_nick {
    my $self = shift;
    my $id   = shift;

    my $info = $self->_client->fetch( $self->maybe_extract_id($id) );

    return WunderCharts::Plugin::Facebook::Page->new( raw => $info );
}

sub get_photo_by_id {
    my $self = shift;
    my $id   = shift;

    return $self->get_resource($id);
}

sub get_resource {
    my $self = shift;
    my $id   = shift;

    my $raw;

    # Can't select fields at this point because we don't necessarily know what
    # kind of resource it is.  ->select_fields( 'id', 'link', 'name', )

    try {
        $raw
            = $self->_client->query->find($id)
            ->include_metadata
            ->request( ua => $self->_user_agent )->as_hashref;
    }
    catch {
        die "Cannot fetch data for $id. $_";
    };

    my $resource = $raw->{metadata}->{type};
    my $class    = 'WunderCharts::Plugin::Facebook::' . ucfirst($resource);
    my %args     = (
        raw => $raw,
        lc($resource) eq 'photo'
        ? (
            raw_comments => $self->_get_metadata_summary( $raw, 'comments' ),
            raw_likes    => $self->_get_metadata_summary( $raw, 'likes' ),
            )
        : (),
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
