create or replace function TriggerAliasDateCorrect() 
	returns trigger As '
Begin
 if(new.person_id is NULL) then
	return new;
end if;
 if (new.start_date < (select birth_date from person where new.person_id = Person.person_id ) )
  then return NULL;
 end if;
return new;
End;' language plpgsql;

create trigger TriggerAliasDateCorrect
before insert or update on Alias 
for each row
execute procedure TriggerAliasDateCorrect()

