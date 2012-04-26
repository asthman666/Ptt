package Douban;
use strict;
use warnings;
use URI::Escape;
use LWP::UserAgent;
use JSON;
use Debug;

sub new {
    my $class = shift;
    my $self = {
	@_
    };
    bless $self, $class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    $self->{ua} = LWP::UserAgent->new();
}

sub ref {
    my $self = shift;
    my $url  = shift;
    my $res = $self->{ua}->get($url);
    my $content = $res->content;
    my $ref = decode_json $content;
    return $ref;
}


1;
