#!/usr/bin/env perl
use strict;
use warnings;
use Douban::BookLookup;
use Data::Dumper;

my $d = Douban::BookLookup->new();
my $ref = $d->get("9787543639133");

print Dumper $ref;
