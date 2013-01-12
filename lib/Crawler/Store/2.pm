package Crawler::Store::2;
use base qw(Crawler::Store);
use Image::OCR::Tesseract 'get_ocr';
use Debug;

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
	my $image_url = $1;
	$image_url =~ m{.+/(.+\.png)};
	my $image_file = $1;
	#print $image_file, "\n";

	my $time = time;
	$image_file = $time . "_" . $image_file;

	$self->{ua}->save($image_url, "/tmp/$image_file");
	#$ua->save($image_url, "/tmp/$image_file");

	my $text = get_ocr("/tmp/$image_file");
	$text =~ m{([\d.]+)};
	$h{price} = $1;

	debug("get price $h{price}");

	#unlink "/tmp/$image_file";
    }

    return [\%h];
}

1;
