package WunderCharts::Plugin::Role::HackerNews::Item;

use Moo::Role;

use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( InstanceOf );

has id => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_item->id },
);

# Submissions have a title
# Comments have text
has name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { $_[0]->_item->title || $_[0]->_item->text },
);

has score => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { shift->_item->score || 0 },
);

has _item => (
    is       => 'ro',
    isa      => InstanceOf ['WebService::HackerNews::Item'],
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
