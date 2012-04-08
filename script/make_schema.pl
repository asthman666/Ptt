#!/usr/bin/perl

use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Ptt;
use DBIx::Class::Schema::Loader qw/ make_schema_at /;

my $connect_info = Ptt->config->{"Model::PttDB"}->{connect_info};
my $dsn      = delete $connect_info->{dsn};
my $user     = delete $connect_info->{user};
my $password = delete $connect_info->{password};

make_schema_at(
    'Ptt::Schema',
    { debug => 1,
      dump_directory => "$Bin/../lib",
      use_moose => 1,
    },
    [ $dsn, $user, $password ]
);
