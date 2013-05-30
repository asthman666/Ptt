#!/usr/bin/perl
use strict;
use warnings;
use FindBin qw/$Bin/;
use lib "$Bin/../lib";
use Getopt::Long;
use Ptt;
use Debug;
use Data::Dumper;
use utf8;
use Amazon;
use XML::Simple;
use LWP::UserAgent;
use HTML::TreeBuilder;

my $ptt = Ptt->new;

my $product = $ptt->model('Product');

my $amazon = Amazon->new(
    access_key => $ptt->config->{aws_access_key},
    secret_key => $ptt->config->{aws_secret_key},
    associate_tag => $ptt->config->{aws_associate_tag}, 
);


my $ua = LWP::UserAgent->new();
$ua->agent('Mozilla/5.0 (Windows NT 5.1; rv:21.0) Gecko/20100101 Firefox/21.0');
$ua->default_header('Accept-Encoding' => 'gzip,deflate');

my %asin_seen;
my $display_order = 0;
foreach ( 1..5 ) {
    my $web_url = "http://www.amazon.cn/gp/bestsellers/books/?pg=$_";
    debug("process $web_url");
    my $resp = $ua->get($web_url);

    my $count;
    if ( $resp->is_success ) {
        if ( my $content = $resp->decoded_content ) {
            my $tree = HTML::TreeBuilder->new_from_content($content);
            foreach ( $tree->look_down('class', 'asinReviewsSummary') ) {
                my $asin = $_->attr("name");
                $asin_seen{$asin} = $display_order++;
		$count++;
            }
            $tree->delete;
        }
    } else {
        debug("web_url $web_url, status_line: " . $resp->status_line);
    }
    debug("get asin from $web_url, num $count");
    sleep 1;
}

#debug Dumper \%asin_seen;
debug("find asin num: " . scalar(keys %asin_seen));

my @tmp_asins;
foreach my $asin ( sort {$asin_seen{$a} <=> $asin_seen{$b}} keys %asin_seen ) {
    push @tmp_asins, $asin;
    if ( @tmp_asins == 10 ) {
        parse_and_save(@tmp_asins);
        @tmp_asins = ();
    }
}

if (@tmp_asins) {
    parse_and_save(@tmp_asins);
    @tmp_asins = ();
}

sub parse_and_save {
    my $request = {
        Operation => 'ItemLookup',
        ItemId => join(',',@_),
        IdType => 'ASIN',
        ResponseGroup => 'ItemAttributes,Images',
    };
    my $url = $amazon->url($request);
    debug $url;

    my $resp = $ua->get($url);
    my $content = $resp->decoded_content;
    my $items = eval{ XMLin($content, ForceArray => ['Item', 'Author', 'EAN'])->{Items}->{Item} };

    foreach my $amazon_h ( @$items ) {
        #debug Dumper $amazon_h;
        my $h;
        $h->{asin} = $amazon_h->{ASIN};
        $h->{image_url} = $amazon_h->{ImageSets}->{ImageSet}->{MediumImage}->{URL};
        foreach my $key ( keys %{$amazon_h->{ItemAttributes}} ) {
            $h->{lc($key)} = $amazon_h->{ItemAttributes}->{$key};
        }

        #debug Dumper $h;
        $product->add($h);
    }
}

