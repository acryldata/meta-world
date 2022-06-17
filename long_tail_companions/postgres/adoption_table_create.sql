create schema if not exists adoption;

drop table if exists adoption.pets cascade;

create table adoption.pets
(
pk bigint primary key not null
, profile_id varchar
, status varchar
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table adoption.pets is 'this table contains records of all adoption.pets that have been considered for adoption regardless of outcome';
comment on column adoption.pets.pk is 'primary key of adoption.pets table';
comment on column adoption.pets.status is 'current status of pet';
comment on column adoption.pets.profile_id is 'external lookup ID to the pet_profile table';
comment on column adoption.pets.created_at is 'UTC timestamp when record was created';
comment on column adoption.pets.updated_at is 'UTC timestamp when record was last updated';

\copy adoption.pets from 'data/pets.csv' delimiter ',' csv header;

drop table if exists adoption.humans cascade;

create table adoption.humans
(
pk bigint primary key not null
, profile_id varchar
, email varchar
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table adoption.humans is 'this table contains records of all adoption.humans that have ever pursued an adoption';

comment on column adoption.humans.pk is 'primary key of adoption.humans table';
comment on column adoption.humans.profile_id is 'external lookup ID to the human_profile table';
comment on column adoption.humans.email is 'email address currently associated with this human';
comment on column adoption.humans.created_at is 'UTC timestamp when record was created';
comment on column adoption.humans.updated_at is 'UTC timestamp when record was last updated';

\copy adoption.humans from 'data/humans.csv' delimiter ',' csv header;

drop table if exists adoption.adoptions cascade;

create table adoption.adoptions 
(
pk bigint primary key not null
, pet_fk  bigint not null
, human_fk bigint not null
, status varchar not null
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table adoption.adoptions is 'this table contains records of all attempted adoption.adoptions regardless of outcome';

comment on column adoption.adoptions.pk is 'primary key of adoption.adoptions table';
comment on column adoption.adoptions.pet_fk is 'foreign key of the adoption.pets table';
comment on column adoption.adoptions.human_fk is 'foreign key of the adoption.humans table';
comment on column adoption.adoptions.status is 'latest status of adoption';
comment on column adoption.adoptions.created_at is 'UTC timestamp when record was created';
comment on column adoption.adoptions.updated_at is 'UTC timestamp when record was last updated';

-- add in pk/fk constraints

alter table adoption.adoptions add foreign key (pet_fk) references adoption.pets(pk);
alter table adoption.adoptions add foreign key (human_fk) references adoption.humans(pk);

\copy adoption.adoptions from 'data/adoptions.csv' delimiter ',' csv header;