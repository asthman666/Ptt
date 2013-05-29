#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Getopt::Long;
use Ptt;
use Debug;
use Data::Dumper;
use utf8;
use Amazon;
use XML::Simple;
use LWP::UserAgent;

my $ptt = Ptt->new;

my $amazon = Amazon->new(
    access_key => $ptt->config->{aws_access_key},
    secret_key => $ptt->config->{aws_secret_key},
    associate_tag => $ptt->config->{aws_associate_tag}, 
);

my $request = {
    Operation => 'ItemLookup',
    ItemId => 'B00AH6OXP0',
    IdType => 'ASIN',
    ResponseGroup => 'ItemAttributes',
};

my $ua = LWP::UserAgent->new();

my $url = $amazon->url($request);
debug $url;

my $resp = $ua->get($url);
my $content = $resp->decoded_content;
my $items = eval{ XMLin($content, ForceArray => ['Item'])->{Items}->{Item} };

foreach my $h ( @$items ) {
    foreach ( @{$h->{ItemAttributes}} ) {

    }
}
