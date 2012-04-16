use strict;
use warnings;

use Ptt;

use Plack::Builder;

my $app = Ptt->apply_default_middlewares(Ptt->psgi_app);

builder {
  enable "LighttpdScriptNameFix", script_name => "";
  $app;
};


