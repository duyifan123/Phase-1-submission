create or replace trigger  ASSIGN_MEDAL
before insert or update
on SCOREBOARD
for each row
begin
    if :new.position=1 then :new.medal_id:=1;
    elsif :new.position=2 then :new.medal_id:=2;
    elsif :new.position=3 then :new.medal_id:=3;
    elsif :new.position>3 then  :new.medal_id:= null;
    end if;
end;
/


create or replace trigger ATHLETE_DISMISAL
after delete
on PARTICIPANT
for each row
declare
    team_num number;
begin
    select team_id into team_num from TEAM_MEMBER where participant_id=:old.participant_id;
    delete  from TEAM where team_id=team_num;
    delete from TEAM_MEMBER where participant_id=:old.participant_id;
    delete from SCOREBOARD where participant_id=:old.participant_id;
    update EVENT_PARTICIPATION set status='n' where team_id=team_num;
end;
/


create or replace trigger ENFORCE_CAPACITY
before update or insert
on EVENT
for each row
declare
    num number;
    cap number;
    Exceeded exception;
begin
    select count(venue_id) into num from EVENT where venue_id=:new.venue_id;
    select capacity into cap from VENUE where venue_id=:new.venue_id;
    if num>=cap then raise Exceeded;
    end if;
    exception
    when Exceeded then dbms_output.put_line('Exceeded!');
end;
/
commit;