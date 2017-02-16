package WunderCharts::Plugin::Reddit::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );

with 'WunderCharts::Plugin::Role::HasRawData';

has id => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

has comment_karma => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{comment_karma} },
);

has link_karma => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{link_karma} },
);

has name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{name} },
);

with(
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::HasTrackableData',
);

sub _build_trackables {
    [ 'comment_karma', 'link_karma' ];
}

sub _build_resource_url {
    my $self = shift;
    return sprintf 'https://www.reddit.com/user/%s', $self->name;
}

sub login {
    my $self = shift;
    return $self->name;
}

sub nick {
    my $self = shift;
    return $self->name;
}

1;
