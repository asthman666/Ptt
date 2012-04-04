#!/usr/bin/env perl
use strict;
use warnings;
use Taobao;

my $app_key = shift;
my $secret_key = shift;
my $nick = shift;

my $tb = Taobao->new();

my $api_params = {
    fields  => 'num_iid,title,nick,pic_url,price,click_url',
    method  => 'taobao.taobaoke.items.get',
    nick    => $nick,
    keyword => 'perl',
};

my $url = $tb->url($api_params);

print $url, "\n";

use LWP::UserAgent;

my $ua = LWP::UserAgent->new();
my $res = $ua->get($url);

my $content = $res->content;

print $content, "\n";
