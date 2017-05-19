
insert into Role(name) values ('основатель'), ('вокалист'), ('бэк-вокалист'), ('автор песен'), ('гитарист'), ('басист'), ('ударник');

insert into Place(country, addr) values ('USA', 'Aberdeen,  Washington'), ('USA', 'Springfield,  Virginia'), ('USA', 'Compton,  California'), ('USA', 'Seattle,  Washington');

insert into Person(name, birth_date, birth_place, death_date,  death_place, sex) values  ('Dale Crover',  '1967-10-23', 1 , null, null, 'm'), ('Dave Grohl',  '1969-06-14', 2, null, null, 'm'), ('Krist Novoselic',  '1965-05-16', 3, null, null, 'm'), ('Kurt Donald Cobain',  '1967-02-20', 3, '1994-04-05', null, 'm');

insert into Alias (person_id,alias) values ((select person_id from Person where name='Dave Grohl'),'Dale Nixon');

insert into Band (name, formation_date, formation_place, disband_date) values ('Nirvana', '1987-01-01', (select place_id from Place where country='USA' and addr like 'Aberdeen%'), '1994-01-01');

insert into Member(person_id, band_id, join_date,leave_date) values (1,1,null,null), (2,1,null,null), (3,1,'1987-01-01',null), (4,1,null,null);

insert into Member_Role(member_id, role_id,start_date,end_date) values ((select member_id from Member join Person using(person_id) where name = 'Kurt Donald Cobain'),(select role_id from Role where name = 'гитарист'),(select formation_date from Band where name = 'Nirvana' ),(select disband_date from Band where name = 'Nirvana' )), 
((select member_id from Member join Person using(person_id) where name = 'Dave Grohl'),(select role_id from Role where name = 'ударник'),(select formation_date from Band where name = 'Nirvana' ),(select disband_date from Band where name = 'Nirvana' )),
((select member_id from Member join Person using(person_id) where name = 'Krist Novoselic'),(select role_id from Role where name = 'басист'),(select formation_date from Band where name = 'Nirvana' ),(select disband_date from Band where name = 'Nirvana' ));

Insert into Label(name,parent) values ('Warner Music Group',null),('Sub Pop',1);

Insert into Style(name) values ('grunge'),('alternative rock');

Insert into Composition(name,length,style_id) values ('Blew',752,1),('About a girl',217,2),('School',null,1),('Molly''s Lips',243,1),('Paper Cuts',190,1),('Scoff', 170,1),('Downer',208,1);
Insert into Author(composition_id,person_id,of_what) values (1,(select person_id from Person where name like 'Kurt%Cobain'),'lyric'), (2,(select person_id from Person where name like 'Kurt%Cobain'),'lyric'), (3,(select person_id from Person where name like 'Kurt%Cobain'),'lyric'), (4,(select person_id from Person where name like 'Kurt%Cobain'),'lyric'), (5,(select person_id from Person where name like 'Kurt%Cobain'),'lyric'), (6,(select person_id from Person where name like 'Kurt%Cobain'),'lyric');


insert into Album values (default,'Bleach',false, false, '1989-06-15', '1988-01-23', '1989-01-01', (select label_id from Label where name='Sub Pop'), 1900000, 'Reciprocal Recording', null), (default,'Sliver',false, true, '1990-09-01', '1990-04-01', '1990-07-01', (select label_id from Label where name='Sub Pop'), null, null, null);

Insert into Album_Band values ((select album_id from Album where name='Sliver'), (select band_id from Band where name='Nirvana')), ((select album_id from Album where name='Bleach'), (select band_id from Band where name='Nirvana'));

Insert into Composition_Album values(1,1),(2,1),(3,1),(4,1),(5,1),(6,1);
insert into Composition(name, creation_date, length, style_id) values ('Sliver', '1990-04-01', 136, (select style_id from Style where name='grunge'));

insert into Composition_Album values ((select composition_id from Composition where name='Sliver'), (select album_id from Album where name='Sliver'));

Insert into Tour(name,start_date,end_date) values ('Tortilla','1993-09-01','1995-10-15');

Insert into Concert(place_id,start_date,end_date) values (null,'1993-10-10','1993-10-10');
Insert into Performance(concert_id,tour_id,album_id,length) values (1,1,1,3600);

Insert into Person(name,sex) values ('”Нейромонах Феофан”','m'), ('“Никодим”','m');
Insert into Role(name) values ('балалаечник'),('диджей') ;
Insert into Place(country,addr) values ('Россия','Санкт-Петербург');
Insert into Band values (default,'Нейромонах Феофан','2009-01-01',(select place_id from Place where addr = 'Санкт-Петербург'),null);
Insert into Member values (default,(select person_id from Person where name='”Нейромонах Феофан”'),(select band_id from Band where name='Нейромонах Феофан'),'2009-01-01',null), (default,(select person_id from Person where name='“Никодим”'),(select band_id from Band where name='Нейромонах Феофан'),'2009-01-01',null);

Insert into Member_Role values(default, (select member_id from Member join Person using(person_id) where name='”Нейромонах Феофан”'), (select role_id from Role where name='основатель'),'2009-01-01',null),(default, (select member_id from Member join Person using(person_id) where name='”Нейромонах Феофан”'), (select role_id from Role where name='вокалист'),'2009-01-01',null),(default, (select member_id from Member join Person using(person_id) where name='”Нейромонах Феофан”'), (select role_id from Role where name='балалаечник'),'2009-01-01',null),(default, (select member_id from Member join Person using(person_id) where name='“Никодим”'), (select role_id from Role where name='диджей'),'2009-01-01',null);

Insert into Style(name) values('древнерусский drum&bass');
Insert into Composition(name,creation_date,length,style_id) values ('Ядрёность - образ жизни','2013-01-01',303, (select style_id from Style where name = 'древнерусский drum&bass')), ('Притоптать','2015-01-01',201,(select style_id from Style where name = 'древнерусский drum&bass')),('Холодно в лесу','2013-01-01',189,(select style_id from Style where name = 'древнерусский drum&bass'));
Insert into Author values((select composition_id from Composition where name ='Ядрёность - образ жизни'),(select person_id from Person where name like '%монах Феофан%')),((select composition_id from Composition where name = 'Притоптать'),(select person_id from Person where name like '%монах Феофан%'));
Insert into Album values (default, 'Притоптать',false,true,'2015-01-01',null,null,null,null,null,null), (default, 'Ядрёность это образ жизни', false,true,'2013-01-01',null,null,null,null,null,null);

Insert into Album_Band values ((select album_id from Album where name='Притоптать'), (select band_id from Band where name='Нейромонах Феофан')),((select album_id from Album where name='Ядрёность это образ жизни'), (select band_id from Band where name='Нейромонах Феофан'));
Insert into Composition_Album values ((select composition_id from Composition where name='Притоптать'), (select album_id from Album where name='Притоптать')),((select composition_id from Composition where name='Ядрёность - образ жизни'), (select album_id from Album where name='Ядрёность это образ жизни')),((select composition_id from Composition where name='Холодно в лесу'), (select album_id from Album where name='Ядрёность это образ жизни'));

Insert into Tour(name,start_date) values ('Ядрён Задор','2015-01-01');
Insert into Tour_Band    values ((select tour_id from Tour where name='Ядрён Задор'),(select band_id from Band where name='Нейромонах Феофан'));
Insert into Concert(place_id,start_date,end_date) values ((select place_id from Place where name = 'Санкт-Петербург'),'2016-06-17','2016-06-17'),((select place_id from Place where name = 'Санкт-Петербург'),'2016-11-21','2016-11-21');

--Радиоголовые

Insert into Place(country,addr) values ('England', 'Abingdon, Oxfordshire'),
			('England', 'Welingborough'), ('England', 'Oxford');

Insert into Person(name,birth_date,sex) values ('Philip James Selway','1967-05-23','m'),
	('Edward John O`Brien', '1968-04-15','m'), ('Colin Charles Greenwood','1969-06-26','m'),
	('Jonathan Richard Guy', '1971-11-5','m'), ('Thomas Edward Yorke','1970-08-02','m');

Insert into Alias (person_id,alias) values 
((select person_id from Person where name = 'Thomas Edward Yorke'),'Farm'),
((select person_id from Person where name = 'Thomas Edward Yorke'),'The White Chocolate'),
((select person_id from Person where name = 'Thomas Edward Yorke'),'Wildwood'),
((select person_id from Person where name = 'Philip James Selway'),'Mad Dog');

Insert into Band(name,formation_date,formation_place) values 
('Radiohead','1985-01-01', (select place_id from place where addr ='Abingdon, Oxfordshire' ));

insert into Member (person_id,band_id,join_date) values
	((select person_id from Person where name = 'Philip James Selway'),
	(select band_id from band where name = 'Radiohead'),
	(select formation_date from Band where name = 'Radiohead')),
		((select person_id from Person where name = 'Edward John O`Brien'),
	(select band_id from band where name = 'Radiohead'),
	(select formation_date from Band where name = 'Radiohead')),
		((select person_id from Person where name = 'Colin Charles Greenwood'),
	(select band_id from band where name = 'Radiohead'),
	(select formation_date from Band where name = 'Radiohead')),
		((select person_id from Person where name = 'Jonathan Richard Guy'),
	(select band_id from band where name = 'Radiohead'),
	(select formation_date from Band where name = 'Radiohead')),
		((select person_id from Person where name = 'Thomas Edward Yorke'),
	(select band_id from band where name = 'Radiohead'),
	(select formation_date from Band where name = 'Radiohead'));

Insert into Role(name) values ('пианист');

Insert into Member_Role(member_id,role_id,start_date) values 
	((select member_id from Member join Person using(person_id) where name = 'Thomas Edward Yorke'),
	 (select role_id from Role where name = 'вокалист'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Thomas Edward Yorke'),
	 (select role_id from Role where name = 'основатель'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Thomas Edward Yorke'),
	 (select role_id from Role where name = 'пианист'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Thomas Edward Yorke'),
	 (select role_id from Role where name = 'автор песен'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Jonathan Richard Guy'),
	 (select role_id from Role where name = 'автор песен'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Jonathan Richard Guy'),
	 (select role_id from Role where name = 'гитарист'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Colin Charles Greenwood'),
	 (select role_id from Role where name = 'басист'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Edward John O`Brien'),
	 (select role_id from Role where name = 'автор песен'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Edward John O`Brien'),
	 (select role_id from Role where name = 'бэк-вокалист'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Edward John O`Brien'),
	 (select role_id from Role where name = 'гитарист'),
	 (select formation_date from Band where name = 'Radiohead')),
	((select member_id from Member join Person using(person_id) where name = 'Philip James Selway'),
	 (select role_id from Role where name = 'ударник'),
	 (select formation_date from Band where name = 'Radiohead'));

Insert into Style(name) values ('art rock');

Insert into Composition(name,creation_date,length,style_id) values 
('Airbag','1994-01-01','220',(select style_id from Style where name = 'art rock')),
('Paranoid Android','1994-01-01','210',(select style_id from Style where name = 'alternative rock')),
('Let Down','1994-01-01','180',(select style_id from Style where name = 'art rock')),
('Karma Police','1994-01-01','195',(select style_id from Style where name = 'alternative rock')),
('Electioneering','1994-01-01','182',(select style_id from Style where name = 'alternative rock')),
('Lucky','1994-01-01','180',(select style_id from Style where name = 'art rock')),
('Fitter Happier','1994-01-01','180',(select style_id from Style where name = 'alternative rock')),
('Climbing Up the Walls','1994-01-01','180',(select style_id from Style where name = 'alternative rock')),
('Creep','1992-05-02','193',(select style_id from Style where name = 'alternative rock'));

Insert into Label(name,parent) values ('Capitol Music Group',null), ('Capitol Records', (select label_id from Label where name = 'Capitol Music Group'));
Insert into Album(name,is_single,is_fake,release_date,record_start_date,record_end_date,label_id,copies_num,studio1,studio2)
		values ('OK Computer',false,false,'1996-09-12','1996-06-01','1996-09-10',
		(select label_id from Label where name = 'Capitol Records' ),4500000,'Canned Applause','St Catherin`s Court');
Insert into Album_band(band_id,album_id) values ((select band_id from band where name = 'Radiohead'),(select album_id from Album where name = 'OK Computer'));

Insert into Composition_Album(composition_id,album_id) values 
	((select composition_id from Composition where name = 'Airbag'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Paranoid Android'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Let Down'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Karma Police'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Electioneering'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Lucky'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Fitter Happier'),(select album_id from Album where name = 'OK Computer')),
	((select composition_id from Composition where name = 'Climbing Up the Walls'),(select album_id from Album where name = 'OK Computer'));

Insert into Album (name,is_single,is_fake,release_date,record_start_date,record_end_date,label_id,copies_num,studio1,studio2)
		values ('Creep',true,false,'1992-05-30','1992-05-27','1992-05-29',(select label_id from Label where name = 'Capitol Records' ),null,'EMI A&R',null);
Insert into Album_band(band_id,album_id) values ((select band_id from band where name = 'Radiohead'),(select album_id from Album where name = 'Creep'));

Insert into Composition_Album(composition_id,album_id) values 
	((select composition_id from Composition where name = 'Creep'),(select album_id from Album where name = 'Creep'));

Insert into Author(composition_id,person_id,of_what) values
	((select composition_id from Composition where name = 'Creep'),
	(select person_id from Person where name = 'Colin Charles Greenwood'),'guitar distorion before the chorus'),
	((select composition_id from Composition where name = 'Creep'),
	(select person_id from Person where name = 'Thomas Edward Yorke'),'the music and the lyrics'),
	((select composition_id from Composition where name = 'Airbag'),
	(select person_id from Person where name = 'Thomas Edward Yorke'),'the music and the lyrics'),
	((select composition_id from Composition where name = 'Karma Police'),
	(select person_id from Person where name = 'Thomas Edward Yorke'),'the music and the lyrics'),
	((select composition_id from Composition where name = 'Let Down'),
	(select person_id from Person where name = 'Thomas Edward Yorke'),'the music and the lyrics'),
	((select composition_id from Composition where name = 'Paranoid Android'),
	(select person_id from Person where name = 'Thomas Edward Yorke'),'the music and the lyrics'),
	((select composition_id from Composition where name = 'Paranoid Android'),
	(select person_id from Person where name = 'Jonathan Richard Guy'),'lyrics'),
	((select composition_id from Composition where name = 'Lucky'),
	(select person_id from Person where name = 'Jonathan Richard Guy'),'lyrics'),
	((select composition_id from Composition where name = 'Fitter Happier'),
	(select person_id from Person where name = 'Jonathan Richard Guy'),'lyrics'),
	((select composition_id from Composition where name = 'Climbing Up the Walls'),
	(select person_id from Person where name = 'Jonathan Richard Guy'),'lyrics');


		
		







