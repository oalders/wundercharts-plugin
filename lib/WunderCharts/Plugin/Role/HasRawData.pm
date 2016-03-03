package WunderCharts::Plugin::Role::HasRawData;

use Moo::Role;

use Types::Standard qw(  HashRef );

has _raw => (
    is       => 'ro',
    isa      => HashRef,
    init_arg => 'raw',
    required => 1,
);

1;
