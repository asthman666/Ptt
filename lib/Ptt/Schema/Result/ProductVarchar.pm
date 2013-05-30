use utf8;
package Ptt::Schema::Result::ProductVarchar;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::ProductVarchar

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<product_varchar>

=cut

__PACKAGE__->table("product_varchar");

=head1 ACCESSORS

=head2 product_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 property_id

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 dt_created

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 active

  data_type: 'enum'
  default_value: 'y'
  extra: {list => ["y","n"]}
  is_nullable: 0

=head2 dt_updated

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: '0000-00-00 00:00:00'
  is_nullable: 0

=head2 value

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 display_order

  data_type: 'tinyint'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "product_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "property_id",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "dt_created",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "active",
  {
    data_type => "enum",
    default_value => "y",
    extra => { list => ["y", "n"] },
    is_nullable => 0,
  },
  "dt_updated",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "0000-00-00 00:00:00",
    is_nullable => 0,
  },
  "value",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "display_order",
  {
    data_type => "tinyint",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</product_id>

=item * L</property_id>

=item * L</value>

=back

=cut

__PACKAGE__->set_primary_key("product_id", "property_id", "value");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2013-05-30 20:05:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:J6jZnSbhDzzUsIKeAU3fWw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
