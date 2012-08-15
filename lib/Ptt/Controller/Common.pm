package Ptt::Controller::Common;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

use Amazon;
use Digest::MD5 qw(md5_base64);
use Data::Dumper;
use Domain::PublicSuffix;
use URI;
use Crawler::StoreLoader;
use UA;

sub item : Chained("/") : PathPart Args(0) {
    my ( $self, $c ) =@_;

    unless ( $c->user_exists() ) {
	$c->res->redirect($c->uri_for($c->controller('User')->action_for('login')));
	$c->detach();
	return;
    }

    $c->stash(template => "info.tt", no_wrapper => 1);
    
    my $q = $c->req->params->{q};

    my $uri = URI->new($q);
    my $host = $uri->host;

    my $suffix = Domain::PublicSuffix->new( {'data_file' => $c->path_to('conf', 'effective_tld_names.dat')} );
    
    my $domain = $suffix->get_root_domain($host);

    my $store = $c->model('PttDB::Store')->search({domain => $domain})->single;
    my $store_id = $store->store_id;

    my ($sid, $id, $info, $url);

    my $id_regex = $store->id_regex;
    $q =~ m{$id_regex};
    $sid = $1;
    return unless $sid;
    
    my $url_format = $store->url_format;
    ($url = $url_format) =~ s{_ID_}{$sid};
    $id = md5_base64($url);
    $id =~ s{/}{-}g;
    $id =~ s{\+}{_}g;

    if ( $store_id == 1 ) {
	my $aws = Amazon->new(
	    access_key    => $c->config->{aws_access_key},
	    secret_key    => $c->config->{aws_secret_key},
	    associate_tag => $c->config->{aws_associate_tag},
	    );

	my $request = {
	    Operation => 'ItemLookup',
	    IdType => 'ASIN',
	    ItemId => $sid,
	    ResponseGroup => 'ItemAttributes,Offers,Images,Reviews',
	};
	
	my $ref = $aws->ref($request);
	return unless $ref;

	my $h = $ref->{Items}->[0]->{Item};
	return unless $h;

	$info->{title} = $h->{ItemAttributes}->{Title};
	$info->{image_url} = $h->{LargeImage}->{URL};
	$info->{price} = sprintf("%.2f", $h->{OfferSummary}->{LowestNewPrice}->{Amount}/100);
    } else {
	my $store_loader = Crawler::StoreLoader->new();
	
	$c->log->debug("get store_id $store_id");

	my $obj = $store_loader->get_object($store_id);

	
	$c->log->debug("get url format: $url");

	my $ua = UA->new;
	my $resp = $ua->get($q);
	my $body = $resp->decoded_content;
	
	my $results = $obj->parse($body);
	$info = $results->[0];
    }

    $c->model('PttDB::Item')->update_or_create(
	id        => $id,
	title     => $info->{title},
	image_url => $info->{image_url},
	dt_created => \"now()", #"
	dt_updated => \"now()", #"
	url       => $url,
	store_id  => $store_id,
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

    $c->stash(info => $info, id => $id);
}

sub tag : Chained("/") : PathPart Args(0) {
    my ( $self, $c ) =@_;

    unless ( $c->user_exists() ) {
	$c->detach();
	return;
    }

    my $tag = $c->req->params->{tag};
    my $id  = $c->req->params->{id};

    if ( $tag && $id ) {
	my $tag_object = $c->model("PttDB::Tag")->update_or_create({dt_created => \"now()",  #"
								    dt_updated => \"now()",  #"
								    value      => $tag,
								    uid        => $c->user->uid,
								   });

	$c->model("PttDB::TagItem")->update_or_create({tag_id => $tag_object->tag_id, id => $id, dt_created => \"now()", dt_updated => \"now()"});  #"

	$c->res->redirect($c->uri_for($c->controller('Profile')->action_for('list_result')));
	$c->detach();
    }

    $c->stash(template => "tag.tt", no_wrapper => 1);
}

1;
