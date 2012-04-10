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
    my $cid = $c->req->params->{cid};

    my ($results, $total_results, $facet, %cd_cid);

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

	$c->log->debug("items search begin");

	($results, $total_results, $facet) = $items_search->get(
	    'q' => $q,
	    'p' => $p,
	    'page_size' => $c->config->{page_size},
	    'fields' => join(",", qw(num_iid title nick pic_url cid price delist_time post_fee score volume detail_url)),
	    'cid' => $cid,
	    );
	
	$c->log->debug("items search done");

	$self->facet($c, $facet);

	if ( $cid ) {
	    %cd_cid = $c->model("PttDB::Cid")->find($cid)->get_columns;
	    $cd_cid{rlink} = $c->req->uri_with({ cid => undef });
	}

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

    $c->stash(results => $results, 
	      total_results => $total_results, 
	      cd_cid => \%cd_cid,
	      template => 'search.tt', 
	      page => $page, 
	      facet => $facet);
}

sub facet {
    my ( $self, $c, $facet ) = @_;
    return unless $facet;

    my @cids = map {$_->{category_id}} @$facet;

    my $rs = $c->model('PttDB::Cid')->search({cid => {-in => \@cids}});

    my %cid_name_map;
    while ( my $cc = $rs->next ) {
	$cid_name_map{$cc->cid} = $cc->name;	
    }

    for ( my $i = @$facet - 1; $i >= 0; $i-- ) {
	if ( $cid_name_map{$facet->[$i]->{category_id}} ) {
	    $facet->[$i]->{name} = $cid_name_map{$facet->[$i]->{category_id}};
	    if ( $c->req->params->{cid} && $c->req->params->{cid} == $facet->[$i]->{category_id} ) {
		splice(@$facet, $i, 1);
	    }
	} else {
	    # add note: need to check the category_id if in our cid table
	    splice(@$facet, $i, 1);
	}
    }

    @$facet = sort {$b->{count} <=> $a->{count}} @$facet;
}

__PACKAGE__->meta->make_immutable;

1;
