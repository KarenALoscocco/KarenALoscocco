select count(*) from data_0_current;


select * from series s
left join data_0_current c on s.series_id = c.series_id
where s.index = 893;


-- left join earn e on s.earn_code = e.earn_code
-- left join education ed on s.education_code = ed.education_code
-- where #s.series_id = 'LES1252881500    ' # and 
-- e.earn_code = 01
#left join industry i on s.industry_code = i.industry_code
#left join period p on c.period = p.period
#where c.year = 2019
;

select *from series s
left join data_0_current c on s.series_id = c.series_id
where s.education_code = 00 
and c.year = 2012;

sexs_code in (1,2);

lower(series_title) like '%high school%';


select * from cert;

#earn_code = 01
#

ALTER TABLE `bls_earnings`.`series` CONVERT TO CHARACTER SET UTF8MB3;

select * from ages; #ages_code in (08,20,30,36,37,39,41,44,48,57,66,72)
select * from born; # born_code in (01,02)
select * from cert; #cert_code in (01,02)
select * from class; #class_code = 16 ????
select * from earn; #earn_code in (00,11)
select * from education; #education_code in (11,19,25,37,46,48)
select * from fips; #fips_code in (81,82,83,84,85,86,87,88,89)
select * from indy; #indy_code = 0000
select * from lfst; #lfst_code = 25
select * from occupation; #occupation_code = 0000
select * from orig; #orig_code = 00
select * from pcts; #pcts_code = 00
select * from race; #race_code in (01,03,04)
select * from seasonal; #searsonal_code = 'S'
select * from sexs; #sexs_code in (1,2)
select * from tdata; #blank maybe #00
select * from unin; #unin_code in (1,2,3)



select distinct s.fips_code from series s
left join data_0_current c on s.series_id = c.series_id
where 
s.fips_code in (81,82,83,84,85,86,87,88,89)
and s.earn_code in (00,11)
and s.education_code in (11,19,25,37,46,48)
and s.seasonal = 'S'
and s.ages_code in (08,20,30,36,37,39,41,44,48,57,66,72)
and s.born_code in (01,02)
and s.cert_code in (01,02)
and s.class_code = 16 
and s.indy_code = 0000
and s.lfst_code = 25
and s.occupation_code = 0000
and s.orig_code = 00
and s.pcts_code = 00
and s.race_code in (01,03,04)
and s.sexs_code in (1,2)
and s.unin_code in (1,2,3);

