package WunderCharts::Plugin::Spotify::HasResourceURL;

use Moo::Role;

# define attribute
with 'WunderCharts::Plugin::Role::HasResourceURL';

sub _build_resource_url {
    my $self = shift;
    return $self->{_raw}->{external_urls}->{spotify};
}

1;
