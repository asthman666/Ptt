package Ptt::Controller::User;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Digest::MD5 qw(md5_base64);

sub login : Chained("/") : PathPart : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => "login.tt");
    return unless keys %{$c->request->body_params};

    my ( $email, $password ) = ($c->req->params->{email}, $c->req->params->{password});

    if ( $c->authenticate( { email => $email,
                             password  => $password } ) ) {
	$c->res->redirect($c->uri_for($c->controller("Profile")->action_for("profile")));
	$c->detach;
	return;
    }
}

sub signup : Chained("/") : PathPart : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(template => "signup.tt");
    return unless keys %{$c->request->body_params};

    my $email     = $c->req->body_params->{email};
    my $user_name = $c->req->body_params->{user_name};
    my $password  = md5_base64($c->req->body_params->{password});

    return unless $email && $user_name && $password;

    if ( my $user = $c->model("PttDB::User")->find({user_name => $user_name}, {key => 'user_name'}) ) {
	return "user exists";
    }

    if ( my $user = $c->model("PttDB::User")->find({email => $email}, {key => 'email'}) ) {
	return "email exists";
    }

    $c->model("PttDB::User")->create(
	{
	    user_name => $user_name,
	    password  => $password,
	    email     => $email,
	    dt_created => \"now()",
	    dt_updated => \"now()",
	}
	);
}

sub logout : Chained("/") : PathPart : Args(0) {
    my ( $self, $c ) = @_;
    $c->logout;
}


1;
