package Ptt::Model::ImmediateSearch;
use Moose;
extends 'Catalyst::Model';
use Data::Dumper;
use Debug;
use Coro;
use AnyEvent::HTTP;
use HTTP::Headers;
use HTTP::Message;
use HTML::TreeBuilder;
use Crawler::StoreLoader;
use Digest::MD5 qw(md5_hex)
use Time::HiRes qw(time);

has 'store_loader' => (is => 'rw', lazy_build => 1);

has 'headers' => (is => 'ro', isa => 'HashRef', 
		  default => sub { 
		      {
			  "user-agent" => "Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20100101 Firefox/17.0",
			  "Accept-Encoding" => "gzip, deflate",
			  'Accept-Language' => "zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3",
			  'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
		      } 
		  });

sub _build_store_loader {
    my $self = shift;
    return Crawler::StoreLoader->new();
}

sub search {
    my ( $self, $qh ) = @_;
    if ( $qh->{ean} ) {

	my $time = time;
	my $ean = $qh->{ean};

	my @site_url_generates = Ptt->model('PttDB::SiteUrlGenerate')->search({active => 'y'});

        my $sem = Coro::Semaphore->new(30);
	my @coros;
	my @urls;

	my %site_ids;
	foreach ( @site_url_generates ) {
	    my $key = $time."~".$ean."~".$_->site_id;
	    $key = md5_hex($key);
	    
	    Ptt->model('Redis')->execute('set', $key => 1);;
	    
	    my $url = $_->url;
	    $url =~ s{_KEYWORD_}{$qh->{ean}}g;
	    push @urls, $url;
	    $site_ids{$_->site_id}++;
	}

	while (1) {
	    while ( my $url = shift @urls ) {
		my $site_id = 102;

		push @coros,
		async {
		    my $guard = $sem->guard;

		    http_get $url,
		    headers => $self->headers,
		    Coro::rouse_cb;

		    my ($body, $hdr) = Coro::rouse_wait;
		    debug("$hdr->{Status} $hdr->{Reason} $hdr->{URL}");

		    my $header = HTTP::Headers->new('content-encoding' => 'gzip, deflate', 'content-type' => 'text/html');
		    my $mess = HTTP::Message->new( $header, $body );
		    if ( my $content = $mess->decoded_content() ) {
			my $sku_tree = HTML::TreeBuilder->new_from_content($content);
			if ( my $div = $sku_tree->look_down('id', 'plist') ) {
			    my $item_url = $div->look_down('class', 'p-name')->look_down(_tag => 'a')->attr('href');
			    push @urls, $item_url;
			}

			my $object = $self->store_loader->get_object($site_id);
			my $results = $object->parse($content);
			debug Dumper $results;
		    }
		    
		    

		    if ($hdr->{URL} =~ m{\d+\.html}) {
			delete $site_ids{102};
		    }
		}
	    }

	    $_->join foreach ( @coros );
	    
	    last unless keys %site_ids;
	}
    }
}

__PACKAGE__->meta->make_immutable;

1;
