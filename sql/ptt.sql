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