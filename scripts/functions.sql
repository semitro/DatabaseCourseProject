create or replace function getAllCompositionsBy (bandName varchar(80))
	returns table(id integer,name varchar(80),creation_date Date, Style varchar(80))
as
$$
begin
	return Query 
	select distinct Composition.composition_id, Composition.name, Composition.creation_date, Style.name Style 
		from 
	Band join album_band using(band_id) join Album using(album_id) join Composition_album using(album_id)
		 join composition using(composition_id) join Style using(style_id) 
	where Band.name = bandName order by Composition.creation_date;
end
$$
language plpgsql;

create or replace function getAllCompositionsWrittenBy (person_name varchar(80))
	returns table(id integer, name varchar(80),creation_date Date, Style varchar(80), of_what varchar(80))
as $$
Begin
	return Query	
	select distinct Composition.composition_id, Composition.name, Composition.creation_date, Style.name, Author.of_what
		from
	Person join Author using(person_id) join Composition using(composition_id) join Style using(style_id)
	where Person.name = person_name;
End 
$$
language plpgsql;

create or replace function getBandMembers (bandName varchar(80), since date default null, until date default null)
	returns table(name varchar(80), join_date date, leave_date date, role varchar(80))
	language SQL STABLE
as $$
	select Person.name, Member.join_date, Member.leave_date, Role.name
	 from Band join Member using(band_id) join Person using(person_id) join Member_Role using(member_id) join Role using(role_id)
	 where Band.name=bandName
	 and (Member.join_date is null or until is null or Member.join_date<until)
	 and (Member.leave_date is null or since is null or Member.leave_date>since);
$$;

-- Даты ограничивают релиз альбома, не запись
create or replace function getBandAlbums (bandName varchar(80), since date default null, until date default null)
	returns table(name varchar(80), is_single boolean, released date, label varchar(80), copies int,
		rec_from date, rec_to date, studios varchar(160), collab varchar)
	language SQL STABLE
as $$
	with Collab as (select album_id, string_agg(B2.name,', ') as collab
		from (Band as B1 join Album_Band as A1 using(band_id)) join (Band as B2 join Album_Band as A2 using(band_id)) using(album_id)
		where B1.band_id<>B2.band_id and B1.name=bandName group by album_id)
	select Album.name, Album.is_single, Album.release_date, Label.name, Album.copies_num,
	 	Album.record_start_date, Album.record_end_date, concat_ws(', ', Album.studio1, Album.studio2),
	 	Collab.collab
 	from Album join Label using(label_id) join Album_Band using(album_id) join Band using(band_id) left join Collab using(album_id)
 	where Album.is_fake=false and Band.name=bandName
	 and (Album.release_date is null or since is null or Album.release_date>since)
	 and (Album.release_date is null or until is null or Album.release_date<until);
$$;

-- Имя можно не указывать, чтобы получить по всем
-- Дополнительно можно указать группу, если есть тёзки, чтобы сузить поиск
create or replace function getPersonalInfo (personName varchar(80) default null, bandName varchar(80) default null)
	returns table(name varchar(80), aliases varchar, sex char(1), date_of_birth date, 
		place_of_birth varchar, date_of_death date, place_of_death varchar)
	language SQL STABLE
as $$
	with Aliases as (select person_id, string_agg(alias, ',') as aliases from Alias group by person_id)
	select Person.name, Aliases.aliases, Person.sex, Person.birth_date, concat_ws(', ',P1.name,P1.addr,P1.country),
		Person.death_date, concat_ws(', ',P2.name,P2.addr,P2.country)
	from Person left join Place as P1 on birth_place=P1.place_id
		left join Place as P2 on death_place=P2.place_id left join Aliases using(person_id)
	where (personName is null or Person.name=personName) and (bandName is null or person_id in
		(select person_id from Member join Band using(band_id) where Band.name=bandName));
$$;
