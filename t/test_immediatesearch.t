#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Data::Dumper;
use Ptt;

my $model = Ptt->model('ImmediateSearch');
my $qh = {
    ean => '9787534272516',
};
my $filter = {
    site_id => 122,
};
my @results = $model->search($qh, $filter);
print Dumper @results;

