package Ptt::Controller::Common;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Amazon;
use Digest::MD5 qw(md5_base64);
use Data::Dumper;

sub item : Chained("/") : PathPart Args(0) {
    my ( $self, $c ) =@_;

    unless ( $c->user_exists() ) {
	$c->res->redirect($c->uri_for($c->controller('User')->action_for('login')));
	$c->detach();
	return;
    }

    my $q = $c->req->params->{q};

    my $asin;
    if ( $q =~ m{(B0[\w+]{8})} ) {
	$asin = $1;
    }
    return unless $asin;

    my $aws = Amazon->new(
	access_key    => $c->config->{aws_access_key},
	secret_key    => $c->config->{aws_secret_key},
	associate_tag => $c->config->{aws_associate_tag},
	);

    my $request = {
	Operation => 'ItemLookup',
	IdType => 'ASIN',
	ItemId => $asin,
	ResponseGroup => 'ItemAttributes,Offers,Images,Reviews',
    };
    
    my $ref = $aws->ref($request);
    return unless $ref;

    my $h = $ref->{Items}->[0]->{Item};
    return unless $h;

    my $info;
    $info->{title} = $h->{ItemAttributes}->{Title};
    $info->{image_url} = $h->{LargeImage}->{URL};
    $info->{price} = sprintf("%.2f", $h->{OfferSummary}->{LowestNewPrice}->{Amount}/100);
    my $url = "http://www.amazon.cn/dp/$asin";
    my $id = md5_base64($url);
    $id =~ s{/}{-}g;
    $id =~ s{\+}{_}g;

    $c->model('PttDB::Item')->update_or_create(
	id        => $id,
	title     => $info->{title},
	image_url => $info->{image_url},
	dt_created => \"now()", #"
	dt_updated => \"now()", #"
	url       => $url,
	);

    $c->model('PttDB::ItemPrice')->create({
	id        => $id,
	price     => $info->{price},
	dt_created => \"now()", #"
	});

    $c->model('PttDB::UserItem')->update_or_create(
	id        => $id,
	uid       => $c->user->uid,
	dt_created => \"now()", #"
	dt_updated => \"now()", #"
	);

    $c->stash(info => $info, template => "info.tt", no_wrapper => 1);
}

1;
