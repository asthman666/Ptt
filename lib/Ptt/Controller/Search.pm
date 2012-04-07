package Ptt::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Data::Dumper;
use Taobao::ItemsSearch;
use Taobao::Taobaoke::ItemsConvert;
use Data::Page;
use Page;

sub search : Chained("/") : PathPart("search") : Args(0) {
    my ( $self, $c ) = @_;

    my $q = $c->req->params->{q};
    my $p = $c->req->params->{p} || 1;  # page

    my ($results, $total_results, $facet);

    my $tk_items_convert = Taobao::Taobaoke::ItemsConvert->new(
	app_key    => $c->config->{app_key},
	secret_key => $c->config->{secret_key},
	);

    if ( $q =~ /id=(\d+)/ ) {
	($results, $total_results) = $tk_items_convert->get(
	    num_iids => $1,
	    nick     => $c->config->{nick},
	    );	
    } else {
	my $items_search = Taobao::ItemsSearch->new(
	    app_key    => $c->config->{app_key},
	    secret_key => $c->config->{secret_key},
	    );

	($results, $total_results, $facet) = $items_search->get(
	    'q' => $q,
	    'p' => $p,
	    'page_size' => $c->config->{page_size},
	    'fields' => join(",", qw(num_iid title nick pic_url cid price delist_time post_fee score volume)),
	    );
	
	my $tmp_results;
	my @num_iids;
	foreach ( @$results ) {
	    push @num_iids, $_->{num_iid};
	    $tmp_results->{$_->{num_iid}} = $_;
	}

	if ( @num_iids ) {
	    my ($tk_results) = $tk_items_convert->get(
		num_iids => join(",", @num_iids),
		nick     => $c->config->{nick},
		fields   => join(",", qw(num_iid click_url commission commission_rate)),
		);	
	    foreach ( @$tk_results ) {
		%{$tmp_results->{$_->{num_iid}}} = (%{$tmp_results->{$_->{num_iid}}}, %$_);
	    }

	    $results = [values %$tmp_results];
	}
    }

    my $data_page = Data::Page->new($total_results, $c->config->{page_size}, $p);
    my $page = Page->new(data_page => $data_page);
    $page->paging;

    $c->stash(results => $results, total_results => $total_results, template => 'search.tt', page => $page, facet => $facet);
}

__PACKAGE__->meta->make_immutable;

1;
