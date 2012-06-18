use utf8;
package Ptt::Schema::Result::Item;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Ptt::Schema::Result::Item

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<item>

=cut

__PACKAGE__->table("item");

=head1 ACCESSORS

=head2 id

  data_type: 'char'
  default_value: (empty string)
  is_nullable: 0
  size: 22

=head2 title

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 image_url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 255

=head2 url

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 1024

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "char", default_value => "", is_nullable => 0, size => 22 },
  "title",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "image_url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 255 },
  "url",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 1024 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07024 @ 2012-06-18 22:05:22
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+nX+qusddaDFyhVcCyrFBA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
