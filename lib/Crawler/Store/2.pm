package Crawler::Store::2;
use base qw(Crawler::Store);
use Image::OCR::Tesseract 'get_ocr';
use UA;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    return $self;
}

sub parse {
    my $self = shift;
    my $body = shift;
    return unless $body;

    my %h;
    if ( $body =~ m{<h1>(.*?)<font} ) {
	$h{title} = $1;
    }

    if ( $body =~ m{var\s+img\s*=\s*"(.*?)"} ) {
	$h{image_url} = $1;
    }

    if ( $body =~ m{<strong class="price"><img.*?src ="(.*?)"/>} ) {
	my $resp = $self->{ua}->save($1, "/tmp/jd.png");
	my $text = get_ocr("/tmp/jd.png");
	$text =~ m{([\d.]+)};
	$h{price} = $1;
    }

    return [\%h];
}

1;
