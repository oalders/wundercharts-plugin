use strict;
use warnings;

use Test::Fatal qw( exception);
use Test::More;
use Test::RequiresInternet ( 'api.instagram.com' => 443 );

use lib 't/lib';
use Test::WunderCharts::Plugin qw( config_for_service plugin_for_service );

my $config = config_for_service('Instagram');

SKIP: {
    skip 'No live config', 5 unless $config->{live};

    my $plugin = plugin_for_service('Instagram');

    {
        my $user = $plugin->get_user_by_nick('oalders');
        ok( $user, 'got oalders user' );
        ok( ( $user->followers_count > 0 ), 'has followers' );
        ok( ( $user->following_count > 0 ), 'follows accounts' );
    }

    {
        my $user = $plugin->get_user_by_id('5894185');
        ok( $user, 'got oalders user by id' );
    }

    {
        my $media = $plugin->get_media_by_id('dk4enZwWvP');
        ok( $media, 'got image dk4enZwWvP by shortcode' );
    }

SKIP: {
        skip 'need to upload a video', 1;
        {
            my $media = $plugin->get_media_by_id('BDCoNacva1f/');
            ok( $media, 'got video dk4enZwWvP by shortcode' );
        }
    }

    like(
        exception { $plugin->get_user_by_id('wundercounterx') },
        qr{404}, 'exception on user not found'
    );
}

done_testing();
