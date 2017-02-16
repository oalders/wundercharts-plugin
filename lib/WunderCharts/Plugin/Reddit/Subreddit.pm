package WunderCharts::Plugin::Reddit::Subreddit;

use Moo;
use MooX::StrictConstructor;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );

with 'WunderCharts::Plugin::Role::HasRawData';

has accounts_active => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{accounts_active} },
);

has id => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{id} },
);

# The name key returns something like 't5_' . $self->id.  That's not helpful
# for display purposes.

has name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_raw->{url} },
);

has subscribers => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_raw->{subscribers} },
);

with(
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::HasTrackableData',
);

sub _build_trackables {
    [ 'accounts_active', 'subscribers' ];
}

sub _build_resource_url {
    my $self = shift;
    return sprintf 'https://www.reddit.com/user/%s', $self->name;
}

1;
