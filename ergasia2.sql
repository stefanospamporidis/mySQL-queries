use flights;

/*1o erwtima swsto*/ 

select count(*) as flights from flights
where flights.id in(
select flights_has_passengers.flights_id from flights_has_passengers
inner join passengers on passengers.id=flights_has_passengers.passengers_id
inner join flights on flights_has_passengers.flights_id=flights.id
inner join routes on routes.id=flights.routes_id
inner join airports on routes.source_id=airports.id
where airports.city='Athens'
group by flights_has_passengers.flights_id
having (count(passengers.id)>=5 and count(passengers.id)<=7)
)

/*2o erwtima swsto*/

select airplanes.manufacturer,airplanes.model,count(*) as count from airplanes
inner join airlines_has_airplanes on airlines_has_airplanes.airplanes_id=airplanes.id
inner join airlines on airlines_has_airplanes.airlines_id=airlines.id
inner join flights on airplanes.id=flights.airplanes_id
inner join routes on flights.routes_id=routes.id
inner join airports as a1 on a1.id=routes.source_id
inner join airports as a2 on a2.id=routes.destination_id
where a1.city='Athens' and a2.city='London' and airlines.name='Olympic Airways' and (flights.date between '2011-02-01' and '2014-07-17')
group by airplanes.manufacturer,airplanes.model
order by count desc
limit 1

/*3o erwtima swsto*/

select passengers.name,passengers.surname,count(flights.date) as times from passengers
inner join flights_has_passengers on flights_has_passengers.passengers_id=passengers.id
inner join flights on flights_has_passengers.flights_id=flights.id
inner join routes on flights.routes_id=routes.id
inner join airports on airports.id=routes.source_id
where airports.name='Athens El. Venizelos' and flights.date between '2014-01-01' and '2015-01-01'
group by passengers.id
having count(flights.date)>4
order by passengers.name
	
	
/*4o erwtima swsto*/

select passengers.name,passengers.surname from passengers
inner join flights_has_passengers on flights_has_passengers.passengers_id=passengers.id
inner join flights on flights_has_passengers.flights_id=flights.id
inner join routes on routes.id=flights.routes_id
inner join airlines on routes.airlines_id=airlines.id
group by passengers.name,passengers.surname
having count(case when airlines.name<>'British Airways' then 1 end)=0
order by passengers.name,passengers.surname

/*5o erwtima swsto*/

select 'yes' as answer from airlines
inner join routes on airlines.id=routes.airlines_id
inner join airports as a1 on a1.id=routes.source_id
inner join airports as a2 on a2.id=routes.destination_id
where a1.name='London Gatwick' or a2.name='London Gatwick'
group by airlines.id
having count(airlines.id)>=5

/*6o erwtima swsto*/

select airlines.id,airlines.name,count(distinct(airplanes.id))as planes,count(distinct(routes.id)) as routes  from airlines
inner join airlines_has_airplanes on airlines_has_airplanes.airlines_id=airlines.id
inner join airplanes on airlines_has_airplanes.airplanes_id=airplanes.id
inner join routes on airlines.id=routes.airlines_id
group by airlines.id
having (count(distinct(routes.id))>5 and count(distinct(airplanes.id))>5)

/*7o erwtima swsto*/

select tbl.name,sum(tbl.visitors) from(
select airports.name,count(distinct(flights_has_passengers.passengers_id)) as visitors from flights
inner join routes on routes.id=flights.routes_id
inner join airlines on airlines.id=routes.airlines_id
inner join flights_has_passengers on flights_has_passengers.flights_id=flights.id
inner join airports on airports.id=routes.source_id
where airlines.name='Aegean Airlines' and flights.date between '2011-01-01' and '2015-01-01'
group by airports.name
UNION
select airports.name,count(distinct(flights_has_passengers.passengers_id)) as visitors from flights
inner join routes on routes.id=flights.routes_id
inner join airlines on airlines.id=routes.airlines_id
inner join flights_has_passengers on flights_has_passengers.flights_id=flights.id
inner join airports on airports.id=routes.destination_id
where airlines.name='Aegean Airlines' and flights.date between '2011-01-01' and '2015-01-01'
group by airports.name
)as tbl
group by tbl.name
order by tbl.name

/*8o erwtima swsto */

select count(passengers.id) as Count from passengers
where passengers.id in 
(select flights_has_passengers.passengers_id from flights_has_passengers
inner join flights on flights_has_passengers.flights_id=flights.id
inner join routes on flights.routes_id=routes.id
inner join airports as a1 on routes.source_id=a1.id
inner join airports as a2 on routes.destination_id=a2.id
where a1.city='Athens'
group by flights_has_passengers.passengers_id
having count(*)>5)

/*9o erwtima swsto*/

select tbl.name,count(distinct(tbl.id)) as routes from(
select airports.name,airlines.id from airports
inner join routes on routes.source_id=airports.id
inner join airlines on airlines.id=routes.airlines_id
where airlines.active='Y'
UNION
select airports.name,airlines.id from airports
inner join routes on routes.destination_id=airports.id
inner join airlines on airlines.id=routes.airlines_id
where airlines.active='Y'
)as tbl
group by tbl.name
order by routes desc,tbl.name desc
limit 1

/*enallaktiki lusi 9*/

select tbl.name,count(distinct(tbl.id)) from(
select airports.name,airlines.id from airports
inner join routes on routes.source_id=airports.id
inner join airlines on airlines.id=routes.airlines_id
where airlines.active='Y'
UNION
select airports.name,airlines.id from airports
inner join routes on routes.destination_id=airports.id
inner join airlines on airlines.id=routes.airlines_id
where airlines.active='Y'
)as tbl
group by tbl.name
having count(distinct(tbl.id))>=ALL
(
select count(distinct(tbl.id)) from(
select airports.name,airlines.id from airports
inner join routes on routes.source_id=airports.id
inner join airlines on airlines.id=routes.airlines_id
where airlines.active='Y'
UNION
select airports.name,airlines.id from airports
inner join routes on routes.destination_id=airports.id
inner join airlines on airlines.id=routes.airlines_id
where airlines.active='Y'
)as tbl
group by tbl.name
)

	
/*10o erwtima swsto*/

select airlines.name from airlines
inner join routes on routes.airlines_id=airlines.id
inner join flights on flights.routes_id=routes.id
inner join flights_has_passengers on flights_has_passengers.flights_id=flights.id
inner join passengers on flights_has_passengers.passengers_id=passengers.id
where passengers.year_of_birth>1994
group by airlines.id
having count(passengers.id)>=ALL
	(select count(passengers.id) from airlines
	inner join routes on routes.airlines_id=airlines.id
	inner join flights on flights.routes_id=routes.id
	inner join flights_has_passengers on flights_has_passengers.flights_id=flights.id
	inner join passengers on flights_has_passengers.passengers_id=passengers.id
	where passengers.year_of_birth>1994
	group by airlines.id)
	
/*11o erwtima swsto*/

select airlines.id,count(*) as Count from airlines
inner join routes on airlines.id=routes.airlines_id
inner join flights on flights.routes_id=routes.id
where flights.airplanes_id in
(select airplanes.id from airplanes
where airplanes.manufacturer='Boeing')
group by airlines.id


/*12o erwtima swsto*/

select airlines.name,count(distinct(passengers.id)) as passengers from airlines
inner join routes on routes.airlines_id=airlines.id
inner join flights on flights.routes_id=routes.id
inner join flights_has_passengers on flights_has_passengers.flights_id=flights.id
inner join passengers on flights_has_passengers.passengers_id=passengers.id
inner join airports as a1 on a1.id=routes.source_id
inner join airports as a2 on a2.id=routes.destination_id
where a1.city='London' or a2.city='London'
group by airlines.id
order by count(distinct(passengers.id)),airlines.country
limit 5