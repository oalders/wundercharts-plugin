package WunderCharts::Plugin::Role::Instagram::HasServiceURL;

use Moo::Role;

with 'WunderCharts::Plugin::Role::HasServiceURL';

sub _build_service_url { 'https://instagram.com' }

1;
