package Ptt::Model::Redis;
use strict;
use warnings;
use base 'Catalyst::Model::Redis';

__PACKAGE__->config(
    host => "localhost",
    port => "6379",
    utf8 => "1",
);

1;

=head1 NAME

Ptt::Model::Redis - Redis Catalyst model

=head1 DESCRIPTION

Redis Catalyst model component. See L<Catalyst::Model::Redis>

