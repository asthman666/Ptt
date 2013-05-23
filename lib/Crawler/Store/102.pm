package Crawler::Store::102;
use base qw(Crawler::Store);
use HTML::TreeBuilder;
use Debug;
use Time::HiRes qw(time);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    $self->_init();
    return $self;
}

sub _init {
    my $self = shift;
    ($self->{site_id}) = __PACKAGE__ =~ m{Store::(\d+)};
}

sub parse {
    my $self = shift;
    my $url  = shift;
    my $content = shift;
    return unless $content;

    if ( $url =~ m{keyword=} ) {
        # need to find url
	my $time = time;
        my $tree = HTML::TreeBuilder->new_from_content($content);
        if ( my $div = $tree->look_down('id', 'plist') ) {
            my $item_url = $div->look_down('class', 'p-name')->look_down(_tag => 'a')->attr('href');
            $self->add_url({site_id => $self->{site_id}, url => $item_url});
        }
	$tree->delete;
	debug("find url cost: " . (time - $time));
    } elsif ( $url =~ m{(\d+)\.html} ) {
        # need to find item info
        my $time = time;
        my %h;

        $h{sku} = $1;
        $h{url} = $url;

        if ( $content =~ m{<h1>(.+?)<} ) {
            $h{title} = $1;
        }

        my $price_url = "http://jprice.jd.com/price/np" . $h{sku} . "-TRANSACTION-J.html";
        my $resp = $self->{ua}->get($price_url);
        my $content = $resp->content;
        if ( $content =~ m{jdPrice":{(.*?)}}i ){
            if( $1 =~ m{amount":(.*?),}i ){
                $h{price} = $1;
            }
        }

        $h{site_id} = $self->{site_id};
        $h{id} = $h{sku} . "-" . $h{site_id};
        
        $self->add_item(\%h);
        debug("parse item cost: " . (time - $time));
    }
}

1;


