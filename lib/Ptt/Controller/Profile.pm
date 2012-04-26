package Ptt::Controller::Profile;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base : Chained("/") : PathPart("profile") : CaptureArgs(0) {
    my ( $self, $c ) = @_;
    unless ( $c->user_exists() ) {
	$c->res->redirect($c->uri_for($c->controller('User')->action_for('login')));
	$c->detach();
	return;
    }
}

sub profile : Chained("base") : PathPart("") : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => "profile.tt");
}

sub list : Chained("base") : PathPart("list") : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(template => "list.tt");
}

sub book : Chained("base") : PathPart("book") : Args(0) {
    my ( $self, $c ) = @_;
    $c->stash(template => "profile_book.tt");
}

1;
