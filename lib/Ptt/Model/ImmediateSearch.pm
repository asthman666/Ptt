package Ptt::Model::ImmediateSearch;
use Moose;
extends 'Catalyst::Model';
use Data::Dumper;
use Debug;
use Coro;
use HTML::TreeBuilder;
use Crawler::StoreLoader;
use LWP::UserAgent;

has 'store_loader' => (is => 'rw', lazy_build => 1);

sub _build_store_loader {
    my $self = shift;
    return Crawler::StoreLoader->new();
}

sub search {
    my ( $self, $qh, $filter ) = @_;
    my @site_url_generates = Ptt->model('PttDB::SiteUrlGenerate')->search({active => 'y'});

    my $sem = Coro::Semaphore->new(30);
    my @coros;
    my @urls;

    my %site_id2charset;
    my %site_ids;
    foreach ( @site_url_generates ) {
	if ($filter->{site_id}) {
	    next if $_->site_id != $filter->{site_id};
	}
	my $u;
        (my $url = $_->url) =~ s{_KEYWORD_}{$qh->{ean}}g;
	$u->{url} = $url;
	$u->{site_id} = $_->site_id;
        push @urls, $u;
        $site_ids{$_->site_id}++;
	$site_id2charset{$_->site_id} = $_->charset;
    }

    my @results;
    while (1) {
        while ( my $u = shift @urls ) {
	    my $url = $u->{url};
	    my $site_id = $u->{site_id};
	    
            push @coros,
            async {
                my $guard = $sem->guard;

		my $lwp = LWP::UserAgent->new();
		$lwp->agent('Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20100101 Firefox/17.0');
		$lwp->default_header("Accept-Encoding" => "gzip, deflate");
		$lwp->default_header('Accept-Language' => "zh-cn,zh;q=0.8,en-us;q=0.5,en;q=0.3");
		$lwp->default_header('Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8');

		my $resp = $lwp->get($url);

		my $content;
		if ( my $charset = $site_id2charset{$site_id} ) {
		    $content = $resp->decoded_content(charset => $charset);
		} else {
		    $content = $resp->decoded_content();
		}

		debug("$url, " . $resp->status_line);

		#debug $content;

                #http_get $url,
                #headers => $self->headers,
                #Coro::rouse_cb;

                #my ($body, $hdr) = Coro::rouse_wait;
                #debug("$hdr->{Status} $hdr->{Reason} $hdr->{URL}");
		#debug Dumper $hdr;

                #my $header = HTTP::Headers->new('content-encoding' => $hdr->{'content-encoding'}, 'content-type' => 'text/html');
                #my $header = HTTP::Headers->new('content-type' => 'text/html');
                #my $mess = HTTP::Message->new( $header, $body );
		
		#my $content;
		#if ( my $charset = $site_id2charset{$site_id} ) {
		#    $content = $mess->decoded_content(charset => $charset);
		#} else {
		#    $content = $mess->decoded_content();
		#}
		
                my $object = $self->store_loader->get_object($site_id);
                $object->parse($url, $content);

                if ( !$object->{url} && !$object->{item} ) {
                    return {site_id => $site_id, property => 'bum'};
                }

                if ( $object->{url} && @{$object->{url}} ) {
                    push @urls, @{$object->clean_url};
                }

                if ( $object->{item} && @{$object->{item}} ) {
                    # need to return items
                    return @{$object->clean_item};
                }
            }
        }

        foreach ( @coros ) {
            if ( $_->join ) {
                push @results, $_->join;
            }
        }

        for ( my $i=$#results; $i>=0; $i-- ) {
            my $h = $results[$i];
            delete $site_ids{$h->{site_id}};
            if ( $h->{property} && $h->{property} eq 'bum' ) {
                splice(@results, $i, 1);
            }
        }
        
        last unless keys %site_ids;
    }
    
    #debug Dumper \@results;
    if ( $qh->{sort} eq 'price' ) {
	@results = sort { $a->{price} <=> $b->{price} || $a->{site_id} <=> $b->{site_id} } @results;
    }
    return \@results;
}

__PACKAGE__->meta->make_immutable;

1;


