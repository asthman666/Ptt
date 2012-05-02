#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;
use Amazon;

my $access_key = shift;
my $secret_key = shift;

my $amazon = Amazon->new(
    access_key => $access_key,
    secret_key => $secret_key,
    myendpoint => "webservices.amazon.cn",
);

# A simple ItemLookup request
my $request = {
    Service => 'AWSECommerceService',
    Operation => 'ItemLookup',
    AssociateTag => 'putaotao',
    Version => '2011-08-01',
    IdType => 'ASIN',
    ItemId => 'B007765FMI',
    ResponseGroup => 'ItemAttributes,Offers,Images,Reviews',
};

my $url = $amazon->url($request);
print $url, "\n";
