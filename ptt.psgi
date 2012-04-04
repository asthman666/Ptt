use strict;
use warnings;

use Ptt;

my $app = Ptt->apply_default_middlewares(Ptt->psgi_app);
$app;

