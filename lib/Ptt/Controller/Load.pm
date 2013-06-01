package Ptt::Controller::Load;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use utf8;
use Data::Page;
use Page;
use Debug;
use Date::Calc;
use URI::Escape;

sub load : Chained("/") : PathPart("load") : Args(0) {
    my ( $self, $c ) = @_;
    my $q    = $c->req->params->{q};
    my $qh = $c->model('Analysis::Query')->parse_q($q);

    my $next_url;
    if ( $qh->{ean} ) {
	$next_url = "/compare?q=$qh->{ean}";
    } else {
	$next_url = "/search?q=$qh->{k}";
    } 

    $c->stash(template => 'load.tt', no_wrapper => 1, next_url => $next_url);
}

__PACKAGE__->meta->make_immutable;

1;


