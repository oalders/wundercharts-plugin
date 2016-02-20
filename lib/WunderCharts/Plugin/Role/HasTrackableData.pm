package WunderCharts::Plugin::Role::HasTrackableData;

use Moo::Role;

use Types::Standard qw( ArrayRef HashRef );

has trackable_data => (
    is      => 'ro',
    isa     => HashRef,
    lazy    => 1,
    builder => '_build_trackable_data',
);

has trackables => (
    is       => 'ro',
    isa      => ArrayRef,
    init_arg => undef,
    lazy     => 1,
    builder  => '_build_trackables',
);

sub _build_trackable_data {
    my $self = shift;

    my %data;
    $data{$_} = $self->$_ for @{ $self->trackables };
    return \%data;
}

1;

__END__
# ABSTRACT: Provides a HashRef of trackable data via Moo role

=pod

=head1 DESCRIPTION

Adds a C<trackable_data()> attribute to plugins.  This is a C<HashRef>
containing the various trackable attributes within the class.

=cut
