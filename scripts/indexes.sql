create index index_band_name on band (name);
create index index_person_name on person (name);
create index index_alias on alias (alias);
create index index_composition_name on composition (name);
create index index_album_name on album (name);
create index index_style_name on style (name);
create index index_member_id on member_role(member_id);
-- Один индекс или два - вот в чём вопрос?
create index index_member_person_id on member(person_id);
create index index_member_band_id on member(band_id);
