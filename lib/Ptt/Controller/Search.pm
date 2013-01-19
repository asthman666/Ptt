package Ptt::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Data::Page;
use Page;
use Debug;

sub search : Chained("/") : PathPart("search") : Args(0) {
    my ( $self, $c ) = @_;

    my $q    = $c->req->params->{q};
    my $sort = $c->req->params->{sort} || "price";

    debug("param q: $q");

    my $qh = $c->model('Analysis::Query')->parse_q($q);

    my $p = $c->req->params->{p} || 1;
    $qh->{p} = $p;

    my $data = $c->model("API::Search")->search($qh, $sort)->recv;

    my $total_results = $data->{response}->{numFound};
    my $results = $data->{response}->{docs};

    my %site_seen;
    if ( $results ) {
	foreach my $item ( @$results ) {
	    if ( $item->{price} ) {
		$item->{price} = sprintf("%.2f", $item->{price});
	    }
	    $site_seen{$item->{site_id}}++;
	}
    }
     
    my $rs = $c->model("PttDB::Site")->search({}, { site_id => { -in => [keys %site_seen] } } );
    while ( my $site =  $rs->next ) {
	$site_seen{$site->site_id} = $site->site_name;
    }


    my $data_page = Data::Page->new($total_results, $c->config->{page_size}, $p);
    my $page = Page->new(data_page => $data_page);
    $page->paging;

    $c->stash(results => $results, 
	      total_results => $total_results, 
	      page => $page, 
	      site_seen => \%site_seen,
	      template => 'search.tt', 
        );
}

__PACKAGE__->meta->make_immutable;

1;

