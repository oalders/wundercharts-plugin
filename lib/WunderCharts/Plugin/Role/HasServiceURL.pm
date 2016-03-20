package WunderCharts::Plugin::Role::HasServiceURL;

use Moo::Role;

use Types::URI qw( Uri );

has service_url => (
    is       => 'ro',
    isa      => Uri,
    lazy     => 1,
    coerce   => 1,
    init_arg => undef,
    builder  => '_build_service_url',
);

1;

__END__
# ABSTRACT: Provides an service_url() attribute

=pod

=head1 DESCRIPTION

Adds a C<service_url()> attribute to plugins.

=cut
