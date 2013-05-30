use utf8;
package Ptt::Schema::Result::Product;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::Product

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<product>

=cut

__PACKAGE__->table("product");

=head1 ACCESSORS

=head2 product_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
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

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 image_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 1024

=head2 asin

  data_type: 'char'
  is_nullable: 1
  size: 10

=head2 other_unique

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "product_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
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
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "image_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 1024 },
  "asin",
  { data_type => "char", is_nullable => 1, size => 10 },
  "other_unique",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</product_id>

=back

=cut

__PACKAGE__->set_primary_key("product_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<asin>

=over 4

=item * L</asin>

=back

=cut

__PACKAGE__->add_unique_constraint("asin", ["asin"]);

=head2 C<other_unique>

=over 4

=item * L</other_unique>

=back

=cut

__PACKAGE__->add_unique_constraint("other_unique", ["other_unique"]);


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2013-05-30 20:05:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Yo6Gr0lj3+AdJb4BsGDnkg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
