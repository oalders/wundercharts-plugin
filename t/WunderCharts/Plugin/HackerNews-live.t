#!/usr/bin/env perl;

use strict;
use warnings;

use Test::More;
use Test::RequiresInternet ( 'api.github.com' => 443, );

use lib 't/lib';
use Test::WunderCharts::Plugin qw( plugin_for_service );

my $plugin = plugin_for_service('HackerNews');

{
    my $user = $plugin->get_user_by_id('oalders');
    ok( $user, 'got oalders user' );
    is( $user->id, 'oalders', 'id for user' );
    ok( $user->karma,          'has some karma for user' );
    ok( $user->trackable_data, 'trackable_data for user' );
}

{
    my $user = $plugin->get_resource(
        'https://news.ycombinator.com/user?id=oalders');
    ok( $user, 'user via get_resource' );
}

{
    my $story = $plugin->get_item_by_id('11424372');
    ok( $story, 'got 11424372 story' );
    is( $story->id, '11424372', 'id for story' );
    ok( $story->score,          'has a score for story' );
    ok( $story->trackable_data, 'trackable_data for story' );
}

{
    my $story = $plugin->get_resource(
        'https://news.ycombinator.com/item?id=11424372');
    ok( $story, 'story via get_resource' );
}

{
    my $comment = $plugin->get_item_by_id('11424522');
    ok( $comment, 'got 11424522 comment' );
    is( $comment->id, '11424522', 'id for comment' );
    cmp_ok( $comment->score, '>=', 0, 'has a score for comment' );
    ok( $comment->trackable_data, 'trackable_data for comment' );
}

{
    my $comment = $plugin->get_resource(
        'https://news.ycombinator.com/item?id=11424522');
    ok( $comment, 'story via get_resource' );
}

{
    my $comment
        = $plugin->get_resource(
        'https://news.ycombinator.com/vote?for=11461044&dir=up&auth=dfda5fbc9d8fc038c5c1575812a67b2278a0792b&goto=item%3Fid%3D11458628'
        );
    ok( $comment, 'comment via upvote link' );
    unlike( $comment->name, qr{&\#x27;}, 'entities are decoded' );
}

{
    my $comment = $plugin->get_resource(
        'https://news.ycombinator.com/item?id=10030854');
    ok( $comment, 'comment via item URL' );
}

{
    my $poll = $plugin->get_resource(
        'https://news.ycombinator.com/item?id=7059569');
    ok( $poll, 'poll via item URL' );
}

{
    my $poll
        = $plugin->get_resource(
        'https://news.ycombinator.com/vote?for=7059571&dir=up&auth=6f77c6f1a92f9fef5fce72818ac34ae82bdce081&goto=item%3Fid%3D7059569'
        );
    ok( $poll, 'pollopt via vote URL' );
}

done_testing();
