create or replace function TriggerAliasDateCorrect() 
	returns trigger As '
Begin
 if (new.start_date < (select birth_date from person where new.person_id = Person.person_id ) )
  then return NULL;
 end if;
return new;
End;' language plpgsql;

create trigger TriggerAliasDateCorrect
	before insert or update on Alias 
	for each row
	execute procedure TriggerAliasDateCorrect();


create or replace function memberDateCorrect()
	returns trigger As'
Begin
  if( 
	(select Person.birth_date from Person where Person.person_id = new.person_id) 
	> 
	(select disband_date from Band where Band.band_id = new.band_id)
  ) then return null;
end if;
return new;
End;'
language plpgsql;

create trigger TriggerMemberDatesCorrect
	before insert or update on Member
	 for each row
	execute procedure memberDateCorrect();
	


