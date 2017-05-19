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
