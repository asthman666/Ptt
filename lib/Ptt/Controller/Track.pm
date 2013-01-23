package Ptt::Controller::Track;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use utf8;
use Debug;
use URI::Escape;

sub t : Chained("/") : PathPart("t") : Args(0) {
    my ( $self, $c ) = @_;

    my $to = $c->req->params->{to};

    if (my $site_id = $c->req->params->{site_id}) {
        if ( my $site = $c->model("PttDB::Site")->find($site_id) ) {
            if ( my $track_url = $site->track_url ) {
                if ( $track_url =~ m{_ETO_} ) {
                    $to = "$`" . uri_escape($to) . "$'";
                } elsif ( $track_url =~ m{_U_} ) {
		    $track_url =~ s{_U_}{$to};
		    $to = $track_url;
		}
            }
        }
    }

    if ( $c->res->redirect($to) ) {
        $c->detach();
        return;
    }
}

__PACKAGE__->meta->make_immutable;

1;


