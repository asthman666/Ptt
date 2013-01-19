package Debug;
use strict;
use POSIX qw(strftime);
use Exporter;
use vars qw/$VERSION @ISA @EXPORT $DEBUG_FH/;

$VERSION = 1.00;
@ISA = qw/Exporter/;
@EXPORT = qw/&debug/;

$DEBUG_FH ||= *STDERR;
$|++;

binmode($DEBUG_FH, ":encoding(utf8)");

sub debug {
    my $msg = shift;

    my @subinfo = caller(1);

    if ( $msg ) {
        my $time = strftime("%F %T", localtime());
        my $out_str = "[$time]: $$ " . $subinfo[3] . ": $msg\n";
        print $DEBUG_FH $out_str;
    }
}

1;
