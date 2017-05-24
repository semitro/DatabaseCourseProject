create or replace function getCompositionsByBand (bandName varchar(80))
	returns table(id integer,name varchar(80),creation_date date, Style varchar(80))
	language plpgsql
	stable
as $$
begin
	return Query 
	select distinct Composition.composition_id, Composition.name, Composition.creation_date, Style.name Style 
	from Composition left join Style using(style_id) join Composition_Album using(composition_id)
		join Album using(album_id) join Album_Band using(album_id) join Band using(band_id)
	where Album.is_fake=false and Band.name = bandName order by Composition.creation_date;
end
$$;

create or replace function getCompositionsAuthoredByPerson (person_name varchar(80))
	returns table(id integer, name varchar(80),creation_date date, style varchar(80), of_what varchar(80))
	language plpgsql
	stable
as $$
Begin
	return Query	
	select distinct Composition.composition_id, Composition.name, Composition.creation_date, Style.name, Author.of_what
	from Person join Author using(person_id) join Composition using(composition_id) left join Style using(style_id)
	where Person.name = person_name;
End 
$$;

create or replace function getMembersOfBand (bandName varchar(80), since date default null, until date default null)
	returns table(person_id int, name varchar(80), join_date date, leave_date date, role varchar(80))
	language SQL
	stable
as $$
	select Person.person_id, Person.name, Member.join_date, Member.leave_date, Role.name
	 from Band join Member using(band_id) join Person using(person_id)
	 	left join Member_Role using(member_id) left join Role using(role_id)
	 where Band.name=bandName
	 and (Member.join_date is null or until is null or Member.join_date<until)
	 and (Member.leave_date is null or since is null or Member.leave_date>since);
$$;

-- Даты ограничивают релиз альбома, не запись
create or replace function getAlbumsByBand (bandName varchar(80), since date default null, until date default null)
	returns table(id int, name varchar(80), is_single boolean, released date, label varchar(80), copies int,
		rec_from date, rec_to date, studios varchar(160), collab varchar)
	language SQL
	stable
as $$
	with Collab as (select album_id, string_agg(B2.name,', ') as collab
		from (Band as B1 join Album_Band as A1 using(band_id)) join (Band as B2 join Album_Band as A2 using(band_id)) using(album_id)
		where B1.band_id<>B2.band_id and B1.name=bandName group by album_id)
	select album_id, Album.name, Album.is_single, Album.release_date, Label.name, Album.copies_num,
	 	Album.record_start_date, Album.record_end_date, concat_ws(', ', Album.studio1, Album.studio2),
	 	Collab.collab
 	from Album left join Label using(label_id) join Album_Band using(album_id) join Band using(band_id) left join Collab using(album_id)
 	where Album.is_fake=false and Band.name=bandName
	 and (Album.release_date is null or since is null or Album.release_date>since)
	 and (Album.release_date is null or until is null or Album.release_date<until);
$$;

-- Отбор можно производить по имени человека, по имени группы или по тому и другому сразу,
-- или же можно вывести информацию по всем
create or replace function getPersonalInfo (personName varchar(80) default null, bandName varchar(80) default null)
	returns table(id int, name varchar(80), aliases varchar, sex char(1), date_of_birth date, 
		place_of_birth varchar, date_of_death date, place_of_death varchar)
	language SQL
	stable
as $$
	with Aliases as (select person_id, string_agg(alias, ',') as aliases from Alias group by person_id)
	select person_id, Person.name, Aliases.aliases, Person.sex, Person.birth_date, concat_ws(', ',P1.name,P1.addr,P1.country),
		Person.death_date, concat_ws(', ',P2.name,P2.addr,P2.country)
	from Person left join Place as P1 on birth_place=P1.place_id
		left join Place as P2 on death_place=P2.place_id left join Aliases using(person_id)
	where (personName is null or Person.name=personName) and (bandName is null or person_id in
		(select person_id from Member join Band using(band_id) where Band.name=bandName));
$$;

-- Отбор можно производить по имени человека, по имени группы или по тому и другому сразу,
-- или же можно вывести информацию по всем
create or replace function getPersonalHistory (personName varchar(80) default null, bandName varchar(80) default null)
	returns table (person_id int, name varchar(80), band varchar(80), member_from date, member_until date, role varchar(80),
		role_from date, role_until date)
	language SQL
	stable
as $$
	select person_id, Person.name, Band.name, Member.join_date, Member.leave_date, Role.name, Member_Role.start_date, Member_Role.end_date
	from Person left join Member using(person_id) join Band using(band_id)
		left join Member_Role using(member_id) join Role using(role_id)
	where (personName is null or Person.name = personName) and (bandName is null or person_id in
		(select person_id from Member join Band using(band_id) where Band.name = bandName));
$$;

create or replace function getBandLabels(bandName varchar(80), since date default null, until date default null)
	returns table (label varchar(80))
	language SQL
	stable
as $$
	select distinct(Label.name)
	from Band join Album_Band using(band_id) join Album using(album_id) join Label using(label_id)
	where Band.name=bandName;
$$;

create or replace function getLabelAncestors (labelName varchar(80))
	returns table (id int, label varchar(80))
	language SQL
	STABLE
as $$
	with recursive label_h(id,p) as (select label_id,parent from Label where name = labelName
		UNION select label_id,parent from Label,label_h where label_id=p)
	select label_id, name
	from Label join label_h on id=label_id;
$$;

--Функция для создания группы по именам людей
create or replace function createBandFromPeople(band_name varchar(80),formed date,disbanded date,variadic names varchar(80)[]) 
	returns varchar(10)
	language plpgsql
as $$
declare 
	i integer;
	bandID integer;
Begin
	insert into Band(band_name,formation_date,disband_date) values 
				  (band_name,formed,disbanded) returning band_id into bandID;

	while(i < array_length(names)) do
	begin
		insert into Member(person_id,band_id) values
		( select(Person_id from Person where name ilike names(i)),bandId);
		i := i + 1;
	end
End	
$$;

create or replace function getCompositionsInAlbum (bandName varchar, albumName varchar default null)
	returns table (album varchar, composition varchar, created date, length smallint, style varchar)
	language SQL
	stable
as $$
	select Album.name, Composition.name, Composition.creation_date, Composition.length, Style.name
		from Composition left join Style using(style_id) join Composition_Album using(composition_id)
			join Album using(album_id) join Album_Band using(album_id) join Band using(band_id)
		where Band.name=bandName and (albumName is null or Album.name=albumName);
$$;

create or replace function addSingle (compName varchar, released date, rec_from date, rec_to date, labelName varchar, studio varchar, length int, styleName varchar, copies int, variadic bands varchar[])
	returns void
	language plpgsql
	volatile
as $$
declare
	s_id int;
	l_id int;
	a_id integer;
	c_id integer;
	b varchar;
begin
	s_id := (select style_id from Style where name=styleName);
	if s_id is null then
		insert into Style values (default, styleName) returning style_id into s_id;
	end if;
	l_id := (select label_id from Label where name=labelName);
	if l_id is null then
		insert into Label values (default, labelName, null) returning label_id into s_id;
	end if;
	insert into Album (name, is_single, release_date, record_start_date, record_end_date,
		studio1, copies_num, label_id) values
		(compName, true, released, rec_from, rec_to, studio, copies, l_id) returning album_id into a_id;
	insert into Composition (name, creation_date, length, style_id) values
		(compName, rec_from, addSingle.length, s_id) returning composition_id into c_id;
	insert into Composition_Album (composition_id, album_id) values (c_id, a_id);
	foreach b in array bands loop
		insert into Album_Band (album_id, band_id) values
			(a_id, (select band_id from Band where name=b));
	end loop;
end
$$;

-- Добавляет последние композиции, создаёт если не находит
create or replace function addCompositionsToAlbum (bandName varchar, albumName varchar, variadic compositions varchar[])
	returns void
	language plpgsql
	volatile
as $$
declare
	a_id int;
	c_id int;
	com varchar;
begin
	if compositions is null or albumName is null then
		return;
	end if;
	if bandName is null then
		a_id := (select album_id from Album where name=albumName order by album_id desc limit 1);
	else
		a_id := (select album_id from Album join Album_Band using(album_id) join Band using(band_id)
			where Band.name=bandName and Album.name=albumName order by band_id desc, album_id desc limit 1);
	end if;
	foreach com in array compositions loop
		c_id := (select composition_id from Composition where name=com order by composition_id desc limit 1);
		if c_id is null then
			insert into Composition (name) values (com) returning composition_id into c_id;
		end if;
		insert into Composition_Album (composition_id, album_id) values (c_id, a_id);
	end loop;
			
end
$$;

-- Создаёт людей, если не находит
create or replace function addPeopleToBand (bandName varchar, variadic people varchar[])
	returns void
	language plpgsql
	volatile
as $$
declare
	b_id int;
	p_id int;
	p varchar;
begin
	if bandName is null or people is null then
		return;
	end if;
	b_id := (select band_id from Band where Band.name=bandName order by band_id desc limit 1);
	foreach p in array people loop
		p_id := (select person_id from Person where name=p order by person_id desc limit 1);
		if p_id is null then
			insert into Person (name) values (p) returning person_id into p_id;
		end if;
		insert into Member (person_id, band_id) values (p_id, b_id);
	end loop;
end
$$;

create or replace function addPerformance (album varchar, length int, country varchar, address varchar, day date, attendants int, variadic bands varchar[])
	returns int
	language plpgsql
	volatile
as $$
declare
	b varchar;
	con_id int;
	pl_id int;
	p_id int;
	a_id int;
	b_id int;
begin
	a_id := (select album_id from Album where name=addPerformance.album);
	if a_id is null then
		raise 'Album % doesn''t exist', album using hint='Add album before adding performance';
	end if;
	pl_id := (select place_id from Place where place.country=addPerformance.country and addr=address order by place_id desc limit 1);
	if pl_id is null then
		insert into Place (country,addr) values (addPerformance.country, address)
			returning place_id into pl_id;
	end if;
	insert into Concert (place_id, start_date, end_date, attendants_num) values
		(pl_id, day, day, attendants) returning concert_id into con_id;
	insert into Performance (concert_id, album_id, length) values (con_id, a_id, addPerformance.length)
		returning performance_id into p_id;
	foreach b in array bands loop
		b_id := (select band_id from Band where name=b);
		if b_id is null then
			continue;
		end if;
		insert into Performance_Band (performance_id, band_id) values (p_id, b_id);
	end loop;
	return p_id;
end
$$;

create or replace function addPerformance (album_id int, length int, country varchar, address varchar, day date, attendants int, variadic bands varchar[])
	returns int
	language plpgsql
	volatile
as $$
declare
	b varchar;
	con_id int;
	pl_id int;
	p_id int;
	b_id int;
begin
	if album_id is null then
		raise 'album_id must not be null';
	end if;
	pl_id := (select place_id from Place where place.country=addPerformance.country and addr=address order by place_id desc limit 1);
	if pl_id is null then
		insert into Place (country,addr) values (addPerformance.country, address)
			returning place_id into pl_id;
	end if;
	insert into Concert (place_id, start_date, end_date, attendants_num) values
		(pl_id, day, day, attendants) returning concert_id into con_id;
	insert into Performance (concert_id, album_id, length) values (con_id, album_id, addPerformance.length)
		returning performance_id into p_id;
	foreach b in array bands loop
		b_id := (select band_id from Band where name=b);
		if b_id is null then
			continue;
		end if;
		insert into Performance_Band (performance_id, band_id) values (p_id, b_id);
	end loop;
	return p_id;
end
$$;

create or replace function addFakeAlbum (variadic compositions varchar[])
	returns int
	language plpgsql
	volatile
as $$
declare
	a_id int;
	c varchar;
	c_id int;
begin
	insert into Album (album_id) values (default) returning album_id into a_id;
	foreach c in array compositions loop
		c_id := (select composition_id from Composition where name=c);
		if c_id is null then
			insert into Composition (name) values (c) returning composition_id into c_id;
		end if;
		insert into Composition_Album (composition_id, album_id) values (c_id, a_id);
	end loop;
	return a_id;
end
$$;

-- Создание альбома, удобно для совместных
create or replace function createAlbum(albumName varchar, variadic bandName varchar[])
	returns void
	language plpgsql
as $$
declare
	b varchar;
	b_id integer;
	alb_id integer;
Begin
	if bandName is null or albumName is null then 
		return;
	end if;
	insert into Album(name,is_fake,is_single) values (albumName,'false','false') returning Album_id into alb_id;
	foreach b in array bandName loop
		b_id := (select band_id from Band where name = b order by band_id desc limit 1);
		if(b_id is not null) then
			insert into album_band(album_id,band_id) values(alb_id,b_id);
		end if;
	end loop;
End
$$;
