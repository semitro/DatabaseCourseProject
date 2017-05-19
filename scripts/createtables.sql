create table Place( 
        place_id serial primary key, 
        country varchar(80), 
        addr varchar(200) not null, 
        name varchar(80), 
                unique(country, addr) 
); 

create table Person( 
        person_id serial primary key, 
        name varchar(80), 
        birth_date date, 
        birth_place int references Place(place_id) on update cascade, 
        death_date date, 
        death_place int references Place(place_id) on update cascade, 
        sex char(1), 
                constraint person_dates check(death_date > birth_date), 
                constraint sex check(sex in ('f','m')) 
); 

create table Alias( 
        alias_id serial primary key, 
        person_id int not null references Person(person_id) 
                on update cascade on delete cascade, 
        alias varchar(80) not null, 
        start_date date, 
        end_date date, 
                constraint alias_dates check(end_date >= start_date) 
); 

create table Band( 
        band_id serial primary key, 
        name varchar(80) not null, 
        formation_date date, 
        formation_place int references Place(place_id) on update cascade, 
        disband_date date, 
                constraint band_dates check(disband_date >= formation_date) 
); 

create table Member( 
        person_id int not null references Person(person_id) on update cascade, 
        band_id int not null references Band(band_id) on update cascade, 
        join_date date, 
        leave_date date, 
        primary key(person_id, band_id), 
                constraint member_dates check(leave_date >= join_date) 
); 

create table Role( 
        role_id serial primary key, 
        name varchar(80) not null unique 
); 

create table Member_Role( 
        member_role_id serial primary key, 
        person_id int not null, 
        band_id int not null, 
        foreign key(person_id,band_id) references Member(person_id, band_id) 
                on update cascade on delete cascade, 
        role_id int references Role(role_id), 
        start_date date, 
        end_date date, 
                constraint member_role_dates check(end_date >= start_date) 
); 

create table Style( 
        style_id serial primary key, 
        name varchar(80) not null unique 
); 

create table Composition( 
        composition_id serial primary key, 
        name varchar(80) not null, 
        creation_date date, 
        length smallint, 
        style_id int references Style(style_id) on update cascade, 
                constraint comp_length check(length > 0) 
); 

create table Author( 
        composition_id int not null references Composition(composition_id) on update cascade, 
        person_id int not null references Person(person_id) on update cascade, 
        primary key (composition_id, person_id), 
        of_what varchar(80) 
); 

create table Label( 
        label_id serial primary key, 
        parent int references Label(label_id) on update cascade, 
        name varchar(80) not null 
); 

create table Album( 
        album_id serial primary key, 
        name varchar(80), 
        is_fake boolean default FALSE not null, 
        is_single boolean default FALSE not null, 
        release_date date, 
        record_start_date date, 
        record_end_date date, 
        label_id int references Label(label_id) on update cascade, 
        copies_num int, 
        studio1 varchar(80), 
        studio2 varchar(80), 
                constraint album_dates check(record_end_date >= record_start_date), 
                constraint album_release_date check(release_date >= record_end_date), 
                constraint album_copies check(copies_num > 0) 
); 

create table Album_Band( 
        album_id int not null references Album(album_id) on update cascade, 
        band_id int not null references Band(band_id) on update cascade, 
        primary key (album_id, band_id) 
); 

create table Composition_Album( 
        composition_id int not null references Composition(composition_id) on update cascade, 
        album_id int not null references Album(album_id) on update cascade, 
        primary key(composition_id, album_id) 
); 

create table Concert( 
        concert_id serial primary key, 
        place_id int references Place(place_id) on update cascade, 
        start_date date, 
        end_date date, 
        attendants_num int, 
                constraint concert_dates check(end_date >= start_date), 
                constraint concert_attends_num check(attendants_num > 0) 
); 

create table Tour( 
        tour_id serial primary key, 
        name varchar(80), 
        start_date date, 
        end_date date, 
                constraint tour_dates check(end_date >= start_date) 
); 

create table Tour_Band( 
        tour_id int not null references Tour(tour_id) on update cascade, 
        band_id int not null references Band(band_id) on update cascade, 
        primary key (tour_id, band_id) 
); 

create table Performance( 
        performance_id serial primary key, 
        concert_id int not null references Concert(concert_id) on update cascade, 
        tour_id int references Tour(tour_id) on update cascade, 
        album_id int not null references Album(album_id) on update cascade, 
        length smallint, 
                constraint performanct_length check(length >= 0) 
); 

create table Performance_Band( 
        performance_id int not null references Performance(performance_id) on update cascade, 
        band_id int not null references Band(band_id) on update cascade, 
        primary key (performance_id, band_id) 
); 
