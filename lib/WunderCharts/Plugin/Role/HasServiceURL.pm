package WunderCharts::Plugin::Role::HasServiceURL;

use Moo::Role;

use Types::URI qw( Uri );

has url_for_service => (
    is       => 'ro',
    isa      => Uri,
    lazy     => 1,
    coerce   => 1,
    init_arg => undef,
    builder  => '_build_url_for_service',
);

1;

__END__
# ABSTRACT: Provides an url_for_service() attribute

=pod

=head1 DESCRIPTION

Adds a C<url_for_service()> attribute to plugins.

=cut
