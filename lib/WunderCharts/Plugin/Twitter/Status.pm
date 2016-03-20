package WunderCharts::Plugin::Twitter::Status;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( HashRef Str);

has favorite_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{favorite_count} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has resource_url => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    builder => '_build_resource_url',
);

has name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{text} },
);

has retweet_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{retweet_count} },
);

has screen_name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{user}->{screen_name} },
);

with(
    'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasTrackableData',
    'WunderCharts::Plugin::Role::Twitter::HasServiceURL',
);

sub _build_resource_url {
    my $self = shift;
    my $url  = $self->url_for_service->clone;
    $url->path( sprintf( '/%s/status/%s', $self->screen_name, $self->id ) );
    return $url->as_string;
}

sub _build_trackables {
    [ 'favorite_count', 'retweet_count', ];
}

1;
