-- Показывает работу индексов Band.name, Member.band_id
explain select * from Band natural join Member natural join Person where Band.name = 'Radiohead';
-- Показывает работу индекса Person.name
 explain select * from getPersonalInfo('Kurt Donald Cobain');
-- Показывает работу индеков Alias.alias, Person.id in Member
explain select Band.name, Alias.alias from Alias natural join Person join Member using(person_id) join Band using(band_id) where alias = 'Mad Dog';

-- Запрос показывает, название каких \iкомпозиций стиля Древнерусский Drum & Bass 
-- Совпадает с названием какого-либо альбома из базы данных
-- Показывает работу индексов Style.name, Album.name
explain select Album.name from Album, (select Composition.name from Style join Composition using(style_id) where style.name = 'древнерусский drum&bass') as comp where Album.name = comp.name ;

