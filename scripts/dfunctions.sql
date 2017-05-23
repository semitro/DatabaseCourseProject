drop function getAllCompositionsBy  (bandName varchar(80));
drop function getAllCompositionsWrittenBy  (person_name varchar(80));
drop function getBandMembers  (bandName varchar(80), since date, until date);
drop function getBandAlbums  (bandName varchar(80), since date, until date);
drop function getPersonalInfo  (personName varchar(80), bandName varchar(80));
drop function getPersonalHistory  (personName varchar(80), bandName varchar(80));
drop function getBandLabels (bandName varchar(80), since date, until date);
drop function getLabelAncestors  (labelName varchar(80));
drop function getCompositionsOnAlbum  (bandName varchar, albumName varchar);
drop function addSingle  (compName varchar, released date, rec_from date, rec_to date,;