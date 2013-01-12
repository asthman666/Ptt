package Ptt::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Data::Page;
use Page;

sub search : Chained("/") : PathPart("search") : Args(0) {
    my ( $self, $c ) = @_;

    my $q = $c->req->params->{q};

    my $p = $c->req->params->{p} || 1;

    my $data = $c->model("API::Search")->search($q)->recv;

    my $results = $data->{response}->{docs};
    my $total_results = $data->{response}->{numFound};
     
    my $data_page = Data::Page->new($total_results, $c->config->{page_size}, $p);
    my $page = Page->new(data_page => $data_page);
    $page->paging;

    $c->stash(results => $results, 
	      total_results => $total_results, 
	      page => $page, 
	      template => 'search.tt', 
        );
}

__PACKAGE__->meta->make_immutable;

1;

