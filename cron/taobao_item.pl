#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Taobao::Taobaoke::ItemsGet;
use Taobao::ItemList;
use Ptt::Schema;
use Ptt;
use Data::Dumper;

my $cid = shift;
exit(0) unless $cid;

my @cids = split(/,/, $cid);

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

my $app_key    = Ptt->config->{app_key};
my $secret_key = Ptt->config->{secret_key};
my $nick       = Ptt->config->{nick};

my $taobaoke_itemsget = Taobao::Taobaoke::ItemsGet->new(
    app_key => $app_key, 
    secret_key => $secret_key, 
);

my $taobao_itemlist = Taobao::ItemList->new(
    app_key => $app_key, 
    secret_key => $secret_key, 
);

foreach ( @cids ) {
    my $api_params = {
	fields => 'num_iid,title,nick,pic_url,price,click_url,seller_credit_score,volume,item_location,commission,commission_rate,cid',
	method => 'taobao.taobaoke.items.get',
	nick   => $nick,
	cid    => $_,
	sort   => 'commissionNum_desc',
    };

    my ($results) = $taobaoke_itemsget->get($api_params);

    print "result num: " . scalar(@$results) . "\n";

    sleep 1;

    my %seen;

    my @num_iids;
    foreach ( @$results ) {
	push @num_iids, $_->{num_iid};
	if ( @num_iids == 20 ) {
	    my $items = $taobao_itemlist->get(\@num_iids);

	    sleep 1;

	    foreach ( @$items ) {
		$seen{$_->{num_iid}} = $_->{cid};
	    }
	    
	    @num_iids = ();
	}
    }

    foreach my $h ( @$results ) {
	my $cid = $seen{$h->{num_iid}};

	my $tree = $schema->resultset('Cid')->find($cid)->cid_tree;
	my $root_cid = (split(/>/, $tree))[1];

	$schema->resultset('BestItem')->update_or_create(
	    {
		item_id => $h->{num_iid},
		dt_created => \"now()",
	        dt_updated => \"now()",
		title => $h->{title},
		pic_url => $h->{pic_big_url},
		price => $h->{price},
		click_url => $h->{click_url},
		nick => $h->{nick},
		score => $h->{seller_credit_score},
		volume => $h->{volume},
		cid => $cid,
		root_cid => $root_cid,
	    }
	    );
    }

}



