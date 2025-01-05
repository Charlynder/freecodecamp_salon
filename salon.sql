drop database salon;

create database salon;

alter database salon owner to freecodecamp;

\c salon;

create table customers (
  customer_id serial primary key,
  name varchar(50),
  phone varchar(50) unique
);

create table services (
  service_id serial primary key,
  name varchar(50)
);

create table appointments (
  appointment_id serial primary key,
  customer_id int references customers(customer_id),
  service_id int references services(service_id),
  "time" varchar(50)
);

insert into services (service_id, name) values 
(1, 'Cut'),
(2, 'Color'),
(3, 'Perm'),
(4, 'Style'),
(5, 'Trim');
