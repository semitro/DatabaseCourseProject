create or replace function TriggerAliasDateCorrect() 
	returns trigger As '
Begin
 if (new.start_date < (select birth_date from Alias join person using(person_id)))
  then return NULL;
 end if;
End;' language plpgsql;

create trigger TriggerAliasDateCorrect
musicalgroups-# before insert or update on Alias
musicalgroups-# execute procedure TriggerAliasDateCorrect()

