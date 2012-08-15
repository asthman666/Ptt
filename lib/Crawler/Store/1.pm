package Crawler::Store::1;
use base qw(Crawler::Store);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    return $self;
}

sub parse {
    my $self = shift;
    my $body = shift;
    return unless $body;

    #print $body, "\n";

    my %h;
    if ( $body =~ m{<b class="priceLarge">￥\s*([\d.,]+)} ) {
	$h{price} = $1;
    }

    if ( $body =~ m{目前无货} || $body =~ m{缺货登记} ) {
	$h{availability} = "out of stock";
    } else {
	$h{availability} = "in stock";
    }

    return [\%h];
}

1;
