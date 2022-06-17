drop table if exists pets cascade;

create table pets
(
pk bigint primary key not null
, profile_id varchar
, status varchar
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table pets is 'this table contains records of all pets that have been considered for adoption regardless of outcome';
comment on column pets.pk is 'primary key of pets table';
comment on column pets.status is 'current status of pet';
comment on column pets.profile_id is 'external lookup ID to the pet_profile table';
comment on column pets.created_at is 'UTC timestamp when record was created';
comment on column pets.updated_at is 'UTC timestamp when record was last updated';

\copy pets from 'adoption/postgres/sample_data/pets.csv' delimiter ',' csv header;

drop table if exists humans cascade;

create table humans
(
pk bigint primary key not null
, profile_id varchar
, email varchar
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table humans is 'this table contains records of all humans that have ever pursued an adoption';

comment on column humans.pk is 'primary key of humans table';
comment on column humans.profile_id is 'external lookup ID to the human_profile table';
comment on column humans.email is 'email address currently associated with this human';
comment on column humans.created_at is 'UTC timestamp when record was created';
comment on column humans.updated_at is 'UTC timestamp when record was last updated';

\copy humans from 'adoption/postgres/sample_data/humans.csv' delimiter ',' csv header;

drop table if exists adoptions cascade;

create table adoptions 
(
pk bigint primary key not null
, pet_fk  bigint not null
, human_fk bigint not null
, status varchar not null
, created_at timestamp not null
, updated_at timestamp not null
)
;

comment on table adoptions is 'this table contains records of all attempted adoptions regardless of outcome';

comment on column adoptions.pk is 'primary key of adoptions table';
comment on column adoptions.pet_fk is 'foreign key of the pets table';
comment on column adoptions.human_fk is 'foreign key of the humans table';
comment on column adoptions.status is 'latest status of adoption';
comment on column adoptions.created_at is 'UTC timestamp when record was created';
comment on column adoptions.updated_at is 'UTC timestamp when record was last updated';

-- add in pk/fk constraints

alter table adoptions add foreign key (pet_fk) references pets(pk);
alter table adoptions add foreign key (human_fk) references humans(pk);

\copy adoptions from 'adoption/postgres/sample_data/adoptions.csv' delimiter ',' csv header;