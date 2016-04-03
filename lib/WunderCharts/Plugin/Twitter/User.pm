package WunderCharts::Plugin::Twitter::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( HashRef Str);

has followers_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{followers_count} },
);

has following_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{following_count} },
);

has id => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has listed_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{listed_count} },
);

has name => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{name} },
);

has login => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{screen_name} },
);

has screen_name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{screen_name} },
);

has statuses_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{statuses_count} },
);

with(
    'WunderCharts::Plugin::Role::HasRawData',
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::HasTrackableData',
    'WunderCharts::Plugin::Role::HasUserURL',
    'WunderCharts::Plugin::Role::Twitter::HasServiceURL',
);

sub _build_resource_url {
    my $self = shift;
    return $self->url_for_user( $self->screen_name )->as_string;
}

sub _build_trackables {
    [
        'followers_count', 'following_count', 'listed_count',
        'statuses_count',
    ];
}

sub nick {
    my $self = shift;
    return $self->screen_name;
}

1;
