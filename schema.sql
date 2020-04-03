drop table  USER_ACCOUNT  cascade constraints;
drop table  USER_ROLE  cascade constraints;
drop table  OLYMPICS cascade constraints;
drop table  SPORT  cascade constraints;
drop table  PARTICIPANT  cascade constraints;
drop table  COUNTRY cascade constraints;
drop table  TEAM  cascade constraints;
drop table  TEAM_MEMBER  cascade constraints;
drop table  MEDAL  cascade constraints;
drop table  SCOREBOARD  cascade constraints;
drop table  VENUE cascade constraints;
drop table  EVENT  cascade constraints;
drop table  EVENT_PARTICIPATION cascade constraints;

create table  USER_ROLE (
role_id integer,
role_name varchar2(20),
constraint pk_USER_ROLE primary key(role_id)
                        );


create table  USER_ACCOUNT (
user_id  integer,
username  varchar2(20),
passkey  varchar2(20),
role_id  integer,
last_login  date,
constraint pk_USER_ACCOUNT primary key(user_id),
constraint fk_role_id_USER_ACCOUNT foreign key (role_id) references USER_ROLE(role_id)
                           );


create table  OLYMPICS (
olympic_id integer,
olympic_num varchar2(30) unique,---
host_city varchar2(30),
opening date,--
closing date,--
official_website varchar2(50),
constraint pk_OLYMPICS primary key(olympic_id)
                       );


create table  SPORT (
sport_id integer,
sport_name varchar2(30),
description varchar2(80),
dob date,
team_size integer check(team_size>0),
constraint pk_SPORT primary key(sport_id)
                    );


create table PARTICIPANT (
participant_id integer,
fname varchar2(30),
lname varchar2(30),
nationality varchar2(20),
birth_place varchar2(40),
dob date,
constraint pk_PARTICIPANT primary key(participant_id),
constraint fk_participant_id_PARTICIPANT foreign key (participant_id) references USER_ACCOUNT(user_id)
);


create table COUNTRY (
country_id integer,
country varchar2(20),
country_code varchar2(3),
constraint pk_COUNTRY primary key(country_id)
);


create table TEAM (
team_id integer,
olympics_id integer,
team_name varchar2(50),
country_id integer,
sport_id integer,
coach_id integer not null,
constraint pk_TEAM primary key(team_id),
constraint fk_olympics_id_TEAM foreign key (olympics_id) references OLYMPICS(olympic_id),
constraint fk_country_id_TEAM foreign key (country_id) references COUNTRY(country_id),
constraint fk_sport_id_TEAM foreign key (sport_id) references SPORT(sport_id),
constraint fk_coach_id_TEAM foreign key (coach_id) references USER_ACCOUNT(user_id)
                  );



create table TEAM_MEMBER (
team_id integer,
participant_id integer,
constraint pk_TEAM_MEMBER primary key(team_id,participant_id),
constraint fk_team_id_TEAM foreign key (team_id) references TEAM(team_id),---
constraint fk_participant_id_TEAM foreign key (participant_id) references PARTICIPANT(participant_id)
                         );


create table MEDAL (
medal_id integer,
medal_title varchar2(6) unique,
points integer,
constraint pk_MEDAL primary key(medal_id)
                   );


create table EVENT (
event_id integer,
sport_id integer,
venue_id integer,
gender integer,
event_time date,
constraint pk_EVENT primary key(event_id)
                   );


create table SCOREBOARD (
olympics_id integer,
event_id integer,
team_id integer,
participant_id integer,
position integer,
medal_id integer,
constraint pk_SCOREBOARD primary key(olympics_id,event_id,team_id,participant_id),
constraint fk_olympics_id_SCOREBOARD foreign key (olympics_id) references OLYMPICS(olympic_id),
constraint fk_event_id_SCOREBOARD foreign key (event_id) references EVENT(event_id),
constraint fk_team_id_SCOREBOARD foreign key (team_id) references TEAM(team_id),
constraint fk_participant_id_SCOREBOARD foreign key (participant_id) references PARTICIPANT(participant_id),
constraint fk_medal_id_SCOREBOARD foreign key (medal_id) references MEDAL(medal_id)
                        );


create table VENUE (
venue_id integer,
olympics_id integer,
venue_name varchar2(30),
capacity integer,
constraint pk_VENUE primary key(venue_id),
constraint fk_olympics_id_VENUE foreign key (olympics_id) references OLYMPICS(olympic_id)
                   );


create table EVENT_PARTICIPATION (
event_id integer,
team_id integer,
status char check(status='e' or status='n'),
constraint pk_EVENT_PARTICIPATION primary key(event_id,team_id),
constraint fk_eid_EVENT_PARTICIPATION foreign key (event_id) references EVENT(event_id),
constraint fk_team_id_EVENT_PARTICIPATION foreign key (team_id) references TEAM(team_id)
                                 );

commit;