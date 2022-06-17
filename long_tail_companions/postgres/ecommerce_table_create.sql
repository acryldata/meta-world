create schema if not exists ecommerce;

drop table if exists ecommerce.users cascade;

create table ecommerce.users
(
pk bigint primary key not null
, email varchar
, created_at timestamp
, updated_at timestamp
)
;

comment on table ecommerce.users is 'this table contains records of all users that have ever made a purchase on the ecommerce site';

comment on column ecommerce.users.pk is 'primary key of users table' ;
comment on column ecommerce.users.email is 'email address currently associated with the user';
comment on column ecommerce.users.created_at is 'UTC timestamp when record was created';
comment on column ecommerce.users.updated_at is 'UTC timestamp when record was last updated';

\copy ecommerce.users from 'data/users.csv' delimiter ',' csv header;

drop table if exists ecommerce.items cascade;

create table ecommerce.items 
(
pk bigint primary key not null
, name varchar not null
, type varchar not null
, price decimal not null
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table ecommerce.items is 'this table contains a record for each item that is for sale in the LTC online store';

comment on column ecommerce.items.pk is 'primary key of items table';
comment on column ecommerce.items.name is 'common name of item for sale';
comment on column ecommerce.items.type is 'type of item for sale';
comment on column ecommerce.items.price is 'price of item in USD';
comment on column ecommerce.items.created_at is 'UTC timestamp when record was created';
comment on column ecommerce.items.updated_at is 'UTC timestamp when record was last updated';

\copy ecommerce.items from 'data/items.csv' delimiter ',' csv header;


drop table if exists ecommerce.purchases cascade;

create table ecommerce.purchases
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

comment on table ecommerce.purchases is 'this table contains a record for each purchase at the LTC online store';

comment on column ecommerce.purchases.pk is 'primary key of purchases table';
comment on column ecommerce.purchases.user_fk is 'foreign key of the users table';
comment on column ecommerce.purchases.status is 'latest status of the purchase';
comment on column ecommerce.purchases.purchase_amount is 'total purchase amount in USD, excluding taxes';
comment on column ecommerce.purchases.tax_amount is 'total tax amount in USD';
comment on column ecommerce.purchases.total_amount is 'total transaction amount in USD';
comment on column ecommerce.purchases.created_at is 'UTC timestamp when record was created';
comment on column ecommerce.purchases.updated_at is 'UTC timestamp when record was last updated';

\copy ecommerce.purchases from 'data/purchases.csv' delimiter ',' csv header;

drop table if exists ecommerce.purchase_items cascade;

create table ecommerce.purchase_items
(
pk bigint primary key not null
, purchase_fk bigint not null
, item_fk bigint not null
, quantity bigint not null
)
;

comment on table ecommerce.purchase_items is 'this table contains a record for each item included in a purchase from the LTC online store';

comment on column ecommerce.purchase_items.pk is 'primary key of purchase items table';
comment on column ecommerce.purchase_items.purchase_fk is 'foreign key of the purchaeses table';
comment on column ecommerce.purchase_items.item_fk is 'foreign key of the items table';
comment on column ecommerce.purchase_items.quantity is 'number of items purchased';

\copy ecommerce.purchase_items from 'data/purchase_items.csv' delimiter ',' csv header;

-- add in pk/fk constraints

alter table ecommerce.purchases add foreign key (user_fk) references ecommerce.users(pk);
alter table ecommerce.purchase_items add foreign key (purchase_fk) references ecommerce.purchases(pk);
alter table ecommerce.purchase_items add foreign key (item_fk) references ecommerce.items(pk);