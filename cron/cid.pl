#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Taobao::ItemCatsGet;
use Ptt::Schema;
use Encode;
use Ptt;
use Data::Dumper;

my $connect_info = Ptt->config->{"Model::PttDB"}->{connect_info};
my $dsn      = delete $connect_info->{dsn};
my $user     = delete $connect_info->{user};
my $password = delete $connect_info->{password};

my $schema = Ptt::Schema->connect(
    $dsn,
    $user,
    $password,
    $connect_info,
);

my $app_key = Ptt->config->{app_key};
my $secret_key = Ptt->config->{secret_key};

my $taobao_itemcatsget = Taobao::ItemCatsGet->new(
	app_key => $app_key, 
	secret_key => $secret_key, 
);

get_cid(1, 0, "0");

sub get_cid {
    my $is_parent  = shift;
    my $parent_cid = shift;
    my $cid_tree   = shift;

    return if ! defined $parent_cid || $parent_cid eq "";
    return unless $is_parent;
    
    my $item_cat = $taobao_itemcatsget->get(parent_cid => $parent_cid);

    sleep 1;

    return unless $item_cat;

    foreach ( @$item_cat ) {
	$_->{cid_tree} = "$cid_tree>$_->{cid}";
	db( $_ );
	get_cid($_->{is_parent}, $_->{cid}, $_->{cid_tree});
    }
}

sub db {
    my $h = shift;

    if ( $h->{is_parent} ) {
	$h->{is_leaf} = 'n';
    } else {
	$h->{is_leaf} = 'y';
    }

    my $level = () = split(/>/, $h->{cid_tree}, -1);
    $level -= 1;

    $schema->resultset('Cid')->update_or_create(
	{
	    cid => $h->{cid},
	    dt_created => \"now()",
	    dt_updated => \"now()",
	    cid_tree => $h->{cid_tree},
	    parent_cid => $h->{parent_cid},
	    is_leaf => $h->{is_leaf},
	    name => $h->{name},
	    level => $level,
	}
	);
}
