create or replace function TriggerAliasDateCorrect() 
	returns trigger As $$
Begin
 if (new.start_date < (select birth_date from person where new.person_id = Person.person_id ) )
  then return NULL;
 end if;
return new;
End;$$ language plpgsql;

create trigger TriggerAliasDateCorrect
	before insert or update on Alias 
	for each row
	execute procedure TriggerAliasDateCorrect();


create or replace function memberDateCorrect()
	returns trigger As $$
Declare
	birth date;
	death date;
	formation date;
	disbandment date;
Begin
	birth := (select Person.birth_date from Person where Person.person_id = new.person_id);
	death := (select Person.death_date from Person where Person.person_id = new.person_id);
	formation := (select formation_date from Band where Band.band_id = new.band_id);
	disbandment := (select disbandment_date from Band where Band.band_id = new.band_id);
  	if birth>=disbandment or death<formation then
  		return null;
  	end if;
  	if new.join_date not between birth and death
  			or new.join_date not between formation and disbandment
  			or new.leave_date not between birth and death
  			or new.leave_date not between formation and disbandment then
  		return null;
	end if;
	return new;
End;
$$
language plpgsql;

create trigger TriggerMemberDatesCorrect
	before insert or update on Member
	 for each row
	execute procedure memberDateCorrect();
	


