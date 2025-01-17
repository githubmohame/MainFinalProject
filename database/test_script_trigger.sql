-- create function mynew_udf returns int SONAME 'lib45.so';
use test_db;
create function run_script returns string soname "libf3.so";

delimiter //

create   trigger  Syncing_typesense_insert_farm
after insert on digital_livestock_farm for each row
begin
declare f bool;
 
 select  (count(*)<=0) into f  from  digital_livestock_farm where id=new.id and new.farm_name;
 if(f=1)then
 SET @INC = (select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farms/bash_script_farm.sh  ','"',  new.id   ,'"',' ','"', new.farm_name,'"'  ,' ','insert'))  ) ;
end if;
 end  //; 


-- drop trigger Syncing_typesense_insert;
ALTER DATABASE test_db CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci;



show triggers;

-- drop trigger Syncing_typesense_update;




delimiter //

create   trigger  Syncing_typesense_update_farm
after update on digital_livestock_farm for each row
begin
declare result  text ;
 SET @INC = (select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farms/bash_script_farm.sh   ','"',new.id,'"',' ','"', new.farm_name,'"'  ,' ','update')) ) ;
end   //;



delimiter //

create  trigger  Syncing_typesense_delete_farm
after delete on digital_livestock_farm for each row
begin
  SET @INC = (select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farms/bash_script_farm.sh  ','"',old.id,'"',' ','"', old.farm_name,'"'  ,' ','delete')) ) ;
end  //;






-- #######################################################

delimiter //

create trigger  Syncing_typesense_update_farmer_group
after update on digital_livestock_user_groups for each row
begin
declare flage bool;
declare flage2 bool;
declare result longtext ;
declare v1 varchar(120) default '';
declare v2 varchar(120)default'';
declare v3 varchar(120)default'';
select  name='farmer' into flage2 from test_db.auth_group  where id=new.group_id;
select  name='farmer' into flage from test_db.auth_group  where id=old.group_id;

if(flage2 and new.user_id!=old.user_id)then

select ssn,fname,lname into v1,v2,v3 from test_db.digital_livestock_user u1 where u1.ssn=old.user_id;
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farm/bash_script_farm.sh   ','"',v1,'"',' ','"', v2,' ',v3,'"'  ,' ','delete'))  into result ;
select ssn,fname,lname into v1,v2,v3 from test_db.digital_livestock_user u1 where u1.ssn=new.user_id;
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farmer/bash_script_farmer.sh   ','"',v1,'"',' ','"', v2,' ',v3,'"'  ,' ','insert')) into result ;

 
elseif(flage2 and new.group_id!=old.group_id) then

select ssn,fname,lname into v1,v2,v3 from test_db.digital_livestock_user u1 where u1.ssn=new.user_id;
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farmer/bash_script_farmer.sh   ','"',v1,'"',' ','"', v2,' ',v3,'"'  ,' ','update')) into result ;

elseif(flage and new.group_id!=old.group_id)then

select ssn,fname,lname into v1,v2,v3 from test_db.digital_livestock_user u1 where u1.ssn=old.user_id;
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farmer/bash_script_farmer.sh   ','"',v1,'"',' ','"', v2,' ',v3,'"'  ,' ','delete'))  into result ;
end if;
 

end   //;



delimiter //

create  trigger  Syncing_typesense_delete_farmer_group
after delete on digital_livestock_user_groups for each row
begin
declare result longtext ;
declare flage bool;
declare v1 varchar(120) default '';
declare v2 varchar(120)default'';
declare v3 varchar(120)default'';
select  name='farmer' into flage from test_db.auth_group  where id=old.group_id;
if(flage  ) then

select ssn,fname,lname into v1,v2,v3 from test_db.digital_livestock_user u1 where u1.ssn=old.user_id;
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farmer/bash_script_farmer.sh   ','"',v1,'"',' ','"', v2,' ',v3,'"'  ,' ','delete'))  into result ;
end if;
end  //;




delimiter //

create trigger  Syncing_typesense_insert_farmer_group
after insert on digital_livestock_user_groups for each row
begin
declare result longtext ;
declare flage bool;
declare v1 varchar(120) default '';
declare v2 varchar(120)default'';
declare v3 varchar(120)default'';
select  name='farmer' into flage from test_db.auth_group  where id=new.group_id;

if(flage  ) then
select ssn,fname,lname into v1,v2,v3 from test_db.digital_livestock_user u1 where u1.ssn=new.user_id;
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farmer/bash_script_farmer.sh  ','"',v1,'"',' ','"', v2,' ',v3,'"'  ,' ','insert')) into result ;
end if;
end  //; 


delimiter //

create trigger  Syncing_typesense_update_farmer
after update on digital_livestock_user for each row
begin
declare result longtext ;
declare flage bool  default false;
select auth_g.name ="farmer" into flage from test_db.auth_group auth_g join test_db.digital_livestock_user_groups us_g on(us_g.group_id=auth_g.id)  where us_g.user_id=new.ssn and auth_g.name ="farmer" ;
if(flage)then
select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farmer/bash_script_farmer.sh   ','"',new.ssn,'"',' ','"', new.fname,' ',new.lname,'"'  ,' ','update')) into result ;
end if;
end   //;

delimiter //


-- drop trigger Syncing_typesense_delete;


select concat('Drop Trigger ' , trigger_name ,' ;')
from information_schema.triggers where trigger_schema='test_db';


-- ########################################################

Drop Trigger Syncing_typesense_update_farmer ;
Drop Trigger Syncing_typesense_insert_farmer ;
Drop Trigger Syncing_typesense_insert_farm ;
Drop Trigger Syncing_typesense_update_farm ;
Drop Trigger Syncing_typesense_delete_farm ;
Drop Trigger Syncing_typesense_update_farmer_group ;
Drop Trigger Syncing_typesense_delete_farmer_group ;
Drop Trigger Syncing_typesense_insert_farmer_group;
 DROP TRIGGER city_insert;
DROP TRIGGER city_update;
# Concat('DROP TRIGGER ', Trigger_Name, ';')
DROP TRIGGER village_insert;
DROP TRIGGER village_update;
DROP TRIGGER update_user_fockeltpoint;
DROP TRIGGER user_group_insert; 
DROP TRIGGER user_group_update;
drop trigger user_insert;


select   run_script(concat('sh /home/mohamed/IdeaProjects/MainFinalProject/database/farms/bash_script_farm.sh  ','"','jjuuio','"',' ','"', 'uuiiiii','"'  ,' ','insert'))   ;
 select (count(*)<=0)  from  digital_livestock_farm where id='778900'    ;
 
 use test_db;
 
 
 
 
 
 SHOW TRIGGERS;   
 
 
 
 
 
 SELECT Concat('DROP TRIGGER ', Trigger_Name, ';') FROM  information_schema.TRIGGERS WHERE TRIGGER_SCHEMA = 'test_db';
 
 
 
 
delimiter //

 create trigger user_group_insert after insert on test_db.digital_livestock_user_groups
 for each row 
 begin
 declare flage bool;
  declare flage2 bool;

 select count(*)>0 into flage from test_db.auth_group group1 where group1.id=new.group_id and group1.name="fockeltpoint";
 select location_id is null into flage2 from test_db.digital_livestock_user where new.user_id=ssn;
 if(flage and flage2)
 then 
 signal sqlstate '45000'  SET MESSAGE_TEXT = 'fockeltpoint should have location' ;
 end if;
 -- join test_db.digital_livestock_user_groups usegroup on(group1.id=usegroup.id ) where group1.name="fockeltpoint" and usegroup.user_id=new.;
 
 end//;
 delimiter //;



delimiter //

 create trigger user_group_update after update on test_db.digital_livestock_user_groups
 for each row 
 begin
 declare flage bool;
  declare flage2 bool;

 select count(*)>0 into flage from test_db.auth_group group1 where group1.id=new.group_id and group1.name="fockeltpoint";
 select location_id is null into flage2 from test_db.digital_livestock_user where new.user_id=ssn;
 if(flage and flage2)
 then 
 signal sqlstate '45000'  SET MESSAGE_TEXT = 'fockeltpoint should have location' ;
 end if;
 -- join test_db.digital_livestock_user_groups usegroup on(group1.id=usegroup.id ) where group1.name="fockeltpoint" and usegroup.user_id=new.;
 
 end//;
 delimiter //;




delimiter //
create trigger user_insert after update  on test_db.digital_livestock_user
for each row
begin
 declare flage bool;
select count(*)>0 into flage from test_db.auth_group gro join test_db.digital_livestock_user_groups usgro on(gro.id=usgro.group_id) where   gro.name="fockeltpoint" 
and usgro.user_id=new.ssn;
if(new.location_id is null and flage)
then
 signal sqlstate '45000'  SET MESSAGE_TEXT = 'fockeltpoint should have location' ;
end if;
end //;
delimiter //;

 
 
 alter table test_db.digital_livestock_city add unique key( name,governorate_id);
 
 
 alter table test_db.digital_livestock_village add unique key( name,city_id);
 
 
 alter table test_db.digital_livestock_governorate add unique key(name);


 