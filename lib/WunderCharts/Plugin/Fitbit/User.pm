package WunderCharts::Plugin::Fitbit::User;

use Moo;
use MooX::StrictConstructor;

use Types::Standard qw( Str );

with 'WunderCharts::Plugin::Role::HasRawData';

has id => (
    is      => 'ro',
    isa     => Str,
    lazy    => 1,
    default => sub { shift->_raw->{encodedID} },
);

1;
