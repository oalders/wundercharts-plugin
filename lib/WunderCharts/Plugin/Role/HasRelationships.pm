package WunderCharts::Plugin::Role::HasRelationships;

use Moo::Role;

use Types::Standard qw( ArrayRef Str );

has belongs_to => (
    is        => 'ro',
    isa       => Str,
    predicate => 'has_belongs_to',
    lazy      => 1,
    builder   => '_build_belongs_to',
);

has has_many => (
    is        => 'ro',
    isa       => ArrayRef,
    predicate => 'has_has_many',
    lazy      => 1,
    builder   => '_build_has_many',
);

1;
