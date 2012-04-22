#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Taobao::Taobaoke::ItemsConvert;
use Ptt::Schema;
use Ptt;
use Data::Dumper;
use Debug;

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

my $taobaoke_itemsconvert = Taobao::Taobaoke::ItemsConvert->new(
    app_key => $app_key, 
    secret_key => $secret_key, 
);

my $rs = $schema->resultset('BestItem')->search(
    undef,
    {
	page => 1,
	rows => 40,
    },
    );

my (@need_update, @need_delete);

my $page = 1;

while ( 1 ) {
    my @results = $rs->page($page)->all;

    last unless @results;

    debug("page_num: $page");

    $page++;

    my %num_iids = map {$_->item_id => 1} @results;

    my ( $api_results ) = $taobaoke_itemsconvert->get(num_iids => join(",", keys %num_iids),
						      nick => $nick);
    push @need_update, @$api_results;

    my @api_num_iids = map {$_->{num_iid}} @$api_results;

    debug("found num of api_num_iids: " . scalar(@api_num_iids));

    # find diff
    delete @num_iids{@api_num_iids};

    push @need_delete, keys %num_iids;
}

if ( @need_delete ) {
    debug("need to delete item_id: " . join(",", @need_delete));
    $schema->resultset('BestItem')->search({item_id => {-in => \@need_delete}})->delete;
}

if ( @need_update ) {
    debug("need to update item count: " . scalar(@need_update));
    foreach my $h ( @need_update ) {
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
