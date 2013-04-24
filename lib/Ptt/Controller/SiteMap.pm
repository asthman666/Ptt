package Ptt::Controller::SiteMap;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use utf8;
use Debug;

sub sitemap : Chained("/") : PathPart("sitemap") : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(template => "sitemap.tt", no_wrapper => 1);
    my $page = $c->req->params->{page};
    my $rows = 100;
    my $results = [$c->model('PttDB::Model')->search({}, {page => $page, rows => $rows})];
    $c->stash(results => $results);
}

__PACKAGE__->meta->make_immutable;

1;

