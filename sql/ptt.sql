drop table if exists cid;

create table cid (
       cid           int unsigned default 0 not null,

       active        enum('y', 'n') default 'y' not null,
       dt_created    datetime default '0000-00-00 00:00:00' not null,
       dt_updated    datetime default '0000-00-00 00:00:00' not null,

       name          varchar(255) default '' not null,

       parent_cid    int unsigned default 0 not null,
       cid_tree      varchar(255) default '' not null,

       is_leaf       enum('y', 'n') default 'n' not null,
       level         smallint  default 0 not null,

       primary key(cid)
) engine=innodb;

drop table if exists user;

create table user (
       uid          int unsigned auto_increment,
       
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       status       enum('active', 'suspended') default 'active' not null,
       user_name    varchar(255)   default '' not null,
       password     char(72)       default '' not null,
       email        varchar(255)   default '' not null,       		    
       primary key (uid),
       unique key email (email),
       unique key user_name (user_name)
) engine=innodb;


drop table if exists best_item;

create table best_item (
       item_id      varchar(255)     default '' not null,

       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       title        varchar(255)     default '' not null,
       pic_url      varchar(255)     default '' not null,
       price        decimal(10,2)    default 0  not null,
       click_url    varchar(512)     default '' not null,       
       nick         varchar(255)     default '' not null,
       score        tinyint unsigned default 0  not null,
       volume       int unsigned     default 0  not null,

       root_cid     int unsigned     default 0  not null,
       cid          int unsigned     default 0  not null,

       freight_payer enum('buyer','seller') default 'buyer' not null,

       primary key (item_id)
) engine=innodb;

drop table if exists data;

create table data (
       douban_id   int unsigned default 0 not null,

       active      enum('y', 'n') default 'y' not null,       		   
       dt_created  datetime default '0000-00-00' not null,
       dt_updated  datetime default '0000-00-00' not null,       

       title       varchar(255) default '' not null,
       author      varchar(1024) default '' not null,
       summary     text    not null,
       image_url   varchar(255) default '' not null,

       primary key (douban_id)
) engine=innodb;

drop table if exists data_attr;

create table data_attr (
       douban_id   int unsigned default 0 not null,
       att_name    varchar(255) default '' not null,
       attr_value  varchar(255) default '' not null,
       display_order int unsigned default 0 not null,
       index douban_id (douban_id)
) engine=innodb;

drop table if exists data_tag;

create table data_tag (
       douban_id   int unsigned default 0 not null,
       tag_name    varchar(255) default '' not null,
       index douban_id (douban_id)
) engine=innodb;

drop table if exists data_rating;

create table data_rating (
       douban_id   int unsigned default 0 not null,
       average     decimal(10,1) default 0 not null,
       num_rate    smallint unsigned default 0 not null,
       index douban_id (douban_id)
) engine=innodb;


drop table if exists item;
create table item (
       id           char(22) binary default '' not null,

       active       enum('y', 'n') default 'y' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       title  	    varchar(255)    default '' not null,
       image_url    varchar(255)    default '' not null,
       url          varchar(1024)   default '' not null,

       store_id     int unsigned    default 0  not null,
       primary key (id)
) engine=innodb;

drop table if exists item_price;
create table item_price (
       id           char(22) binary default '' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       price        decimal(10,2) default 0 not null,
       index id (id)
) engine=innodb;

drop table if exists user_item;
create table user_item (
       uid          int unsigned    default 0 not null,
       id           char(22) binary default '' not null,

       active        enum('y', 'n') default 'y' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       primary key (uid,id)
) engine=innodb;

drop table if exists tag;
create table tag (
       tag_id     int unsigned  auto_increment,

       active       enum('y', 'n') default 'y' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       uid          int unsigned  default 0 not null,
       value        varchar(255)  default '' not null,

       primary key (tag_id),
       unique key (uid, value)
) engine=innodb;

drop table if exists tag_item;
create table tag_item (
       tag_id       int unsigned    default 0 not null,
       id           char(22) binary default '' not null,

       active       enum('y', 'n') default 'y' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       primary key (tag_id,id)
) engine=innodb;

drop table if exists store;
create table store (
       store_id     int unsigned auto_increment,

       active       enum('y', 'n') default 'y' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       store_name   varchar(255) default '' not null,
       domain       varchar(255) default '' not null,
       id_regex     varchar(128) default '' not null,
       url_format   varchar(1024) default '' not null,       		    

       primary key (store_id),
       unique key (domain)
) engine=innodb;

drop table if exists site;
create table site (
       site_id     int unsigned auto_increment,

       active       enum('y', 'n') default 'y' not null,
       dt_created   datetime default '0000-00-00 00:00:00' not null,
       dt_updated   datetime default '0000-00-00 00:00:00' not null,

       site_name    varchar(255) default '' not null,
       domain       varchar(255) default '' not null,
       track_url    varchar(1024) default '' not null,

       primary key (site_id),
       unique key (domain)
) engine=innodb;
