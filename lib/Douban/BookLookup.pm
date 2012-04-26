package Douban::BookLookup;
use strict;
use warnings;
use base qw(Douban);

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

sub get {
    my $self = shift;
    my $ean  = shift;
    
    my $url = "http://api.douban.com/book/subject/isbn/$ean?alt=json";
    my $ref = $self->ref($url);

    return $self->finalize($ref);
}

sub finalize {
    my $self = shift;
    my $ref  = shift;
    
    my $info;

    $info->{rating}->{average}  = $ref->{'gd:rating'}->{'@average'};
    $info->{rating}->{num_rate} = $ref->{'gd:rating'}->{'@numRaters'};
    
    foreach (@{$ref->{'db:tag'}}) {
	push @{$info->{tag}->{tag_name}}, $_->{'@name'};
    }
    
    foreach ( @{$ref->{'db:attribute'}} ) {
	#push @{$info->{attr}}, { attr_value => $_->{'$t'}, attr_name => $_->{'@name'} };
	$info->{attr}->{$_->{'@name'}} = $_->{'$t'};
    }
    
    foreach ( @{$ref->{author}} ) {
	push @{$info->{author}}, $_->{name}->{'$t'};
    }

    $info->{summary} = $ref->{summary}->{'$t'};

    $info->{title} = $ref->{title}->{'$t'};    

    ( $info->{douban_id} ) = $ref->{id}->{'$t'} =~ m{subject/(\d+)};

    foreach ( @{$ref->{link}} ) {
	if ( $_->{'@rel'} eq "image" ) {
	    ( $info->{image_url} = $_->{'@href'} ) =~ s/spic/mpic/;
	}
    }

    return $info;
}

1;
