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
use LWP::UserAgent;

my $cat = shift;
exit(0) unless $cat;
my @cats = split /,/, $cat;

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

my @cids;
foreach ( @cats ) {
    sleep 5;

    my $ua = LWP::UserAgent->new();
    $ua->agent('Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20100101 Firefox/12.0');

    my $resp = $ua->get("http://top.taobao.com/level3.php?cat=$_");
    my $content =$resp->decoded_content();

    while ( $content =~ /level3=(\d+)/g ) {
	if ( $schema->resultset('Cid')->find($1) ) {
	    push @cids, $1;
	}
    }
}

exit(0) unless @cids;

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
    foreach my $page_no (1..2) {
	my $api_params = {
	    fields => 'num_iid,title,nick,pic_url,price,click_url,seller_credit_score,volume,item_location,commission,commission_rate,cid',
	    method => 'taobao.taobaoke.items.get',
	    nick   => $nick,
	    cid    => $_,
	    sort   => 'commissionNum_desc',
	    page_no => $page_no,
	};

	my ($results) = $taobaoke_itemsget->get($api_params);

	print "cid: $_, page_no: $page_no, result num: " . scalar(@$results) . "\n";

	sleep 1;

	my %seen;

	my @num_iids;
	foreach ( @$results ) {
	    push @num_iids, $_->{num_iid};
	    if ( @num_iids == 20 ) {
		my $items = $taobao_itemlist->get(\@num_iids);

		sleep 1;

		foreach ( @$items ) {
		    $seen{$_->{num_iid}} = $_;
		}
		
		@num_iids = ();
	    }
	}

	foreach my $h ( @$results ) {
	    %$h = (%$h, %{$seen{$h->{num_iid}}});

	    my $tree = $schema->resultset('Cid')->find($h->{cid})->cid_tree;
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
		    cid => $h->{cid},
		    root_cid => $root_cid,
		    freight_payer => $h->{freight_payer},
		}
		);
	}
    }
}



