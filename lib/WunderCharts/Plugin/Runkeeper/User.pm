package WunderChart::Plugin::Runkeeper::User;

use Moo;
use MooX::StrictConstructor;

with 'WunderCharts::Plugin::Role::HasRawData';

has id => (
    is      => 'ro',
    isa     => Int,
    lazy    => 1,
    default => sub { shift->_raw->{userID} },
);

1;
