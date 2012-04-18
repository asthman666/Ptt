#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Taobao::Taobaoke::ItemsGet;
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

foreach ( @cids ) {
    my $api_params = {
	fields => 'num_iid,title,nick,pic_url,price,click_url,seller_credit_score,volume,item_location,commission,commission_rate',
	method => 'taobao.taobaoke.items.get',
	nick   => $nick,
	cid    => $_,
	sort   => 'commissionNum_desc',
    };

    my ($results) = $taobaoke_itemsget->get($api_params);

    foreach my $h ( @$results ) {
	print $h->{num_iid} . "\n";
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
	    }
	    );
    }

}



