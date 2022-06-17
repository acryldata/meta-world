create schema if not exists ecommerce;

drop table if exists users cascade;

create table users
(
pk bigint primary key not null
, email varchar
, created_at timestamp
, updated_at timestamp
)
;

comment on table users is 'this table contains records of all users that have ever made a purchase on the ecommerce site';

comment on column users.pk is 'primary key of users table' ;
comment on column users.email is 'email address currently associated with the user';
comment on column users.created_at is 'UTC timestamp when record was created';
comment on column users.updated_at is 'UTC timestamp when record was last updated';

\copy users from './ecommerce/postgres/sample_data/users.csv' delimiter ',' csv header;

drop table if exists items cascade;

create table items 
(
pk bigint primary key not null
, name varchar not null
, type varchar not null
, price decimal not null
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table items is 'this table contains a record for each item that is for sale in the LTC online store';

comment on column items.pk is 'primary key of items table';
comment on column items.name is 'common name of item for sale';
comment on column items.type is 'type of item for sale';
comment on column items.price is 'price of item in USD';
comment on column items.created_at is 'UTC timestamp when record was created';
comment on column items.updated_at is 'UTC timestamp when record was last updated';

\copy items from 'ecommerce/postgres/sample_data/items.csv' delimiter ',' csv header;


drop table if exists purchases cascade;

create table purchases
(
pk bigint primary key not null
, user_fk bigint not null
, status varchar not null
, purchase_amount decimal not null
, tax_amount decimal not null
, total_amount decimal not null
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table purchases is 'this table contains a record for each purchase at the LTC online store';

comment on column purchases.pk is 'primary key of purchases table';
comment on column purchases.user_fk is 'foreign key of the users table';
comment on column purchases.status is 'latest status of the purchase';
comment on column purchases.purchase_amount is 'total purchase amount in USD, excluding taxes';
comment on column purchases.tax_amount is 'total tax amount in USD';
comment on column purchases.total_amount is 'total transaction amount in USD';
comment on column purchases.created_at is 'UTC timestamp when record was created';
comment on column purchases.updated_at is 'UTC timestamp when record was last updated';

\copy purchases from 'ecommerce/postgres/sample_data/purchases.csv' delimiter ',' csv header;

drop table if exists purchase_items cascade;

create table purchase_items
(
pk bigint primary key not null
, purchase_fk bigint not null
, item_fk bigint not null
, quantity bigint not null
)
;

comment on table purchase_items is 'this table contains a record for each item included in a purchase from the LTC online store';

comment on column purchase_items.pk is 'primary key of purchase items table';
comment on column purchase_items.purchase_fk is 'foreign key of the purchaeses table';
comment on column purchase_items.item_fk is 'foreign key of the items table';
comment on column purchase_items.quantity is 'number of items purchased';

\copy purchase_items from 'ecommerce/postgres/sample_data/purchase_items.csv' delimiter ',' csv header;

-- add in pk/fk constraints

alter table purchases add foreign key (user_fk) references users(pk);
alter table purchase_items add foreign key (purchase_fk) references purchases(pk);
alter table purchase_items add foreign key (item_fk) references items(pk);