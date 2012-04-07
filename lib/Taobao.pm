package Taobao;
use strict;
use warnings;
use URI::Escape;
use Digest::MD5 qw(md5_hex);
use POSIX;
use LWP::UserAgent;
use JSON;

sub new {
    my $class = shift;
    my $self = {
	app_key     => undef,
	secret_key  => undef,
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

sub sign {
    my $self = shift;
    my $params = shift;
    my $s;

    $s .= $self->{secret_key};
    foreach my $key ( sort keys %$params ) {
	$s .= $key . uri_unescape($params->{$key});
    }
    $s .= $self->{secret_key};

    return uc(md5_hex($s));
}

sub url {
    my $self = shift;
    my $api_params = shift;

    my %system_params = (
	app_key     => $self->{app_key},
	v           => '2.0',
	format      => 'json',
        sign_method => 'md5',
        timestamp   => strftime("%Y-%m-%d %H:%M:%S", localtime),
	);

    my %params = ( %system_params, %$api_params );
    $params{sign} = $self->sign(\%params);
    my @p;
    foreach ( sort keys %params ) {
	push @p, "$_=$params{$_}";
    }
    my $url = "http://gw.api.taobao.com/router/rest?" . join("&", @p);
    return $url;
}

sub ref {
    my $self = shift;
    my $api_params = shift;

    my $url = $self->url($api_params);
    my $res = $self->{ua}->get($url);
    my $content = $res->content;
    my $ref = decode_json $content;
    return $ref;
}

sub finalize {
    my $self = shift;
    my $results = shift;
    
    foreach ( @$results ) {
	$_->{pic_url} =~ s{\.jpg$}{.jpg_sum.jpg} if $_->{pic_url};
	$_->{commission_rate} = sprintf("%.2f", $_->{commission_rate}/100) . "%" if $_->{commission_rate};
    }
}

1;
