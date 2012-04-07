package Ptt::Controller::Search;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Taobao::Taobaoke::ItemsGet;
use Taobao::Taobaoke::ItemsConvert;
use Data::Page;
use Page;

sub search : Chained("/") : PathPart("search") : Args(0) {
    my ( $self, $c ) = @_;

    my $q = $c->req->params->{q};
    my $p = $c->req->params->{p} || 1;  # page

    my ($results, $total_results);

    if ( $q =~ /id=(\d+)/ ) {
	my $tk_items_convert = Taobao::Taobaoke::ItemsConvert->new(
	    app_key    => $c->config->{app_key},
	    secret_key => $c->config->{secret_key},
	    nick       => $c->config->{nick},
	    );
	($results, $total_results) = $tk_items_convert->get($1);	
    } else {
	my $tk_items_get = Taobao::Taobaoke::ItemsGet->new(
	    app_key    => $c->config->{app_key},
	    secret_key => $c->config->{secret_key},
	    nick       => $c->config->{nick},
	    page_size  => $c->config->{page_size},
	    );
	($results, $total_results) = $tk_items_get->get($q, $p);	
    }

    my $data_page = Data::Page->new($total_results, $c->config->{page_size}, $p);
    my $page = Page->new(data_page => $data_page);
    $page->paging;

    $c->stash(results => $results, total_results => $total_results, template => 'search.tt', page => $page);
}

__PACKAGE__->meta->make_immutable;

1;
