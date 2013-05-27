package Crawler::Store::120;
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
        if ( my $div = $tree->look_down(class => 'store_list') ) {
            if ( my $sku = $div->attr("productSaleId") ) {
                $self->add_url({site_id => $self->{site_id},url => "http://www.winxuan.com/product/$sku"});
            }
        }
	$tree->delete;
	debug("find url cost: " . (time - $time));
    } elsif ( $url =~ m{/product/(.+)} ) {
        # need to find item info
        my $time = time;
        my %h;

        $h{sku} = $1;
        $h{url} = $url;

	my $sku_tree = HTML::TreeBuilder->new_from_content($content);

	if ( my $h1 = $sku_tree->look_down(_tag => 'h1') ) {
	    $h{title} = $h1->as_trimmed_text;
	}

	if ( my $ul = $sku_tree->look_down(_tag => 'ul', class => 'price_info') ) {
            $h{price} = $ul->look_down(_tag => 'b', class => 'fb')->as_trimmed_text;
        }
	$sku_tree->delete;

        $h{site_id} = $self->{site_id};
        $h{id} = $h{sku} . "-" . $h{site_id};

        $h{price} =~ s{[^\d,.]}{}g;

        $self->add_item(\%h);
        debug("parse item cost: " . (time - $time));
    }
}

1;



