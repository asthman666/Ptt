package Ptt::Controller::API;
use Moose;
use Debug;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub api_init_q : Chained("/") : PathPart("api/init_q") : Args(0) {
    my ( $self, $c ) = @_;
    my $rand = \"rand()";  #"
    my $init_q = $c->model("PttDB::InitQ")->search(undef, {order_by => $rand, rows => 1})->single;
    my $q = $init_q->value;
    $c->stash->{current_view} = 'JSON';
    $c->stash(init_q => $q);
}

__PACKAGE__->meta->make_immutable;

1;
