drop function getCompositionsByBand  (bandName varchar(80));
drop function getCompositionsAuthoredByPerson  (person_name varchar(80));
drop function getMembersOfBand  (bandName varchar(80), since date, until date);
drop function getAlbumsByBand  (bandName varchar(80), since date, until date);
drop function getPersonalInfo  (personName varchar(80), bandName varchar(80));
drop function getPersonalHistory  (personName varchar(80), bandName varchar(80));
drop function getBandLabels (bandName varchar(80), since date, until date);
drop function getLabelAncestors  (labelName varchar(80));
drop function getCompositionsOnAlbum  (bandName varchar, albumName varchar);
drop function addSingle  (compName varchar, released date, rec_from date, rec_to date, labelName varchar, studio varchar, length int, styleName varchar, copies int, variadic bands varchar[]);
drop function addCompositionsToAlbum  (bandName varchar, albumName varchar, variadic compositions varchar[]);
drop function addPeopleToBand  (bandName varchar, variadic people varchar[]);
drop function addPerformance  (album varchar, length int, country varchar, address varchar, day date, attendants int, variadic bands varchar[]);
drop function addPerformance  (album_id int, length int, country varchar, address varchar, day date, attendants int, variadic bands varchar[]);
drop function addFakeAlbum  (variadic compositions varchar[]);
