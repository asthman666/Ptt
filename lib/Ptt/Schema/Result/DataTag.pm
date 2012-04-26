use utf8;
package Ptt::Schema::Result::DataTag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::DataTag

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<data_tag>

=cut

__PACKAGE__->table("data_tag");

=head1 ACCESSORS

=head2 douban_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 tag_name

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "douban_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "tag_name",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
);


# Created by DBIx::Class::Schema::Loader v0.07015 @ 2012-04-25 21:14:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YTTwxY9Cvqo7+6ZdmYPkSA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
