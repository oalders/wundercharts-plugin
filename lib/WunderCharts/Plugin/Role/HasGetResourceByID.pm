package WunderCharts::Plugin::Role::HasGetResourceByID;

use Moo::Role;

sub get_resource_by_id {
    my $self          = shift;
    my $resource_type = shift;
    my $id            = shift;

    my $method = sprintf( 'get_%s_by_id', $resource_type );
    return $self->$method($id);
}

1;

__END__
# ABSTRACT: Provides a get_resource_by_id() method

=pod

=head1 DESCRIPTION

Adds a C<get_resource_by_id()> method to plugins.

=cut
