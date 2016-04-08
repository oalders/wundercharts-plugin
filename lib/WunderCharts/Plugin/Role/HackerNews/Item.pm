package WunderCharts::Plugin::Role::HackerNews::Item;

use Moo::Role;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( InstanceOf );

has id => (
    is       => 'ro',
    isa      => NonEmptyStr,
    lazy => 1,
    default => sub { shift->_item->id },
);

has score => (
    is       => 'ro',
    isa      => PositiveOrZeroInt,
    lazy => 1,
    default => sub { shift->_item->score || 0 },
);

has _item => (
    is => 'ro',
    isa => InstanceOf['WebService::HackerNews::Item'],
    init_arg => 'item',
);

with(
    'WunderCharts::Plugin::Role::HasResourceURL',
    'WunderCharts::Plugin::Role::HasTrackableData',
);

sub _build_trackables {
    ['score'];
}

sub _build_resource_url {
    my $self = shift;
    return sprintf 'https://news.ycombinator.com/item?id=%s', $self->id;
}

1;
