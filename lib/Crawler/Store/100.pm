package Crawler::Store::100;
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
    
    if ( $url =~ m{field-keywords} ) {
        # need to find url
	my $time = time;
        my $tree = HTML::TreeBuilder->new_from_content($content);
        if ( my $div = $tree->look_down(_tag => 'div', id => qr/result_\d+/) ) {
            if ( my $sku = $div->attr("name") ) {
                $self->add_url({site_id => $self->{site_id},url => "http://www.amazon.cn/dp/$sku"});
            }
        }
	$tree->delete;
	debug("find url cost: " . (time - $time));
    } elsif ( $url =~ m{/dp/(.+)} ) {
        # need to find item info
        my %h;

        $h{sku} = $1;
        $h{url} = $url;

	my $sku_tree = HTML::TreeBuilder->new_from_content($content);

	if ( $sku_tree->look_down('id', 'btAsinTitle') ) {
	    $h{title} = $sku_tree->look_down('id', 'btAsinTitle')->as_trimmed_text;
	}

	if ( $sku_tree->look_down('id', 'actualPriceValue') ){
	    my $price = $sku_tree->look_down('id', 'actualPriceValue')->look_down('class', 'priceLarge')->as_trimmed_text;
	    $h{price} = $price;
	} elsif ( $sku_tree->look_down('class', 'availGreen') && $sku_tree->look_down('class', 'availGreen')->as_trimmed_text =~ m{可以从这些卖家购买} ) {
	    # <div id="olpDivId">
	    if ( my $div = $sku_tree->look_down("id", "olpDivId") ) {
		if ( $div->look_down("class", "price") ) {
		    my $price = $div->look_down("class", "price")->as_trimmed_text;
		    $h{price} = $price;
		}
	    }
	}

	$sku_tree->delete;

        $h{site_id} = $self->{site_id};
        $h{id} = $h{sku} . "-" . $h{site_id};

        $h{price} =~ s{[^\d,.]}{}g;

        $self->add_item(\%h);
    }
}

1;

