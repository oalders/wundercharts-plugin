package WunderCharts::Plugin::Role::HasResourceURL;

use Moo::Role;

has resource_url => (
    is      => 'ro',
    isa     => NonEmptyStr,
    lazy    => 1,
    builder => '_build_resource_url',
);

1;
