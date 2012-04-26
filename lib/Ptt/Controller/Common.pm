package Ptt::Controller::Common;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Douban::BookLookup;

sub ean : Chained("/") : PathPart Args(1) {
    my ( $self, $c, $ean ) =@_;
    return unless $ean;

    my $d = Douban::BookLookup->new();
    my $info = $d->get($ean);

    $c->stash(info => $info, template => "info.tt", no_wrapper => 1);

}

1;
