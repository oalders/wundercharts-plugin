package WunderCharts::Plugin::Role::HackerNews::Item;

use Moo::Role;

use HTML::Entities qw( decode_entities );
use Types::Common::Numeric qw( PositiveOrZeroInt );
use Types::Common::String qw( NonEmptyStr );
use Types::Standard qw( InstanceOf );

has id => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub { shift->_item->id },
);

has kids_count => (
    is      => 'ro',
    isa     => PositiveOrZeroInt,
    lazy    => 1,
    default => sub { scalar @{ shift->_item->kids } },
);

# Submissions have a title
# Comments have text
# 0 is a valid title.  See https://news.ycombinator.com/item?id=7059570
has name => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    default => sub {
        decode_entities(
            defined $_[0]->_item->title
            ? $_[0]->_item->title
            : $_[0]->_item->text
        );
    },
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
