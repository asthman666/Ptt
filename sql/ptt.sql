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

