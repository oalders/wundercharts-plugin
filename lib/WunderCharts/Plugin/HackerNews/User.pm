package WunderCharts::Plugin::HackerNews::User;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( InstanceOf );

has id => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_user->id },
);

has karma => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_user->karma },
);

has _user => (
    is       => 'ro',
    isa      => InstanceOf ['WebService::HackerNews::User'],
    init_arg => 'user',
);

with(
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::HasTrackableData',
);

sub _build_trackables {
    ['karma'];
}

sub _build_resource_url {
    my $self = shift;
    return sprintf 'https://news.ycombinator.com/user?id=%s', $self->id;
}

sub has_many {
    my $self = shift;
    return [ 'Comment', 'Poll', 'Story' ];
}

sub name {
    return shift->id;
}

1;
