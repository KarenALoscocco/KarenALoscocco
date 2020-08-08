SELECT distinct begin_year, end_year, year, period, value, tdata_text, earn_text, earn_code, series_title, series_id 
FROM joined_data_1_AllData where earn_code = 01 #`year` = 2020 and 
and series_id = 'LES1252881500    ';
########################


SELECT distinct #begin_year, end_year, year, period, value, tdata_text, earn_text, earn_code, series_title, series_id 
#series_title, series_id
*
FROM joined_data_1_AllData 
#left join state_mapping on joined_data_1_AllData.fips_text = state_mapping.State
where 
#education_code in (11,19,25,37,46,48) #and ages_code = 28 and cert_code = 02
series_title not like '%Standard error of%'
and series_title not like '%Percent of %'
#and series_title like '%Median usual weekly earnings (second quartile),%'
#and series_title like '%Median weekly earnings%'
#and fips_code != 00
#and occupation_code != 0000
and indy_code != 0000
#and cert_code in  (00,01,02)
###################
;
select indy_text, earn_text, max(avgval)
from (
SELECT indy_text, earn_text, avg(value) avgval
FROM joined_data_1_AllData 
where 
series_title not like '%Standard error of%'
and series_title not like '%Percent of %'
and indy_code != 0000
group by indy_text, earn_text
) a 
group by indy_text, earn_text
having max(avgval) = a.avgval
;






#and occupation_code = 0000
#and indy_code = 0000
#fips_code,fips_text, state,region, division 

-- and (series_title like '%Native born%'
-- OR series_title like '%Foreign born%')
#and series_title like '% Men%'
#and series_title not like '%25 years and over, Men%'
#and series_title not like '%25 years and over, Women%'
#and education_code != 00
-- #and series_title like '%Employed full time%'
-- and earn_code = 11

-- and ages_code in (10,31,38,42,49,65)

## look at earn code 11 - hourly rate employees
## look at earn code 01
select distinct fips_code, fips_text from joined_data_1_AllData 
where series_id = 'LES1254466800    ';

select distinct fips_code,fips_text, state,region, division 
from joined_data_1_AllData
left join state_mapping on joined_data_1_AllData.fips_text = state_mapping.State

SELECT distinct begin_year, end_year, year, value FROM joined_data_0_current where `year` = 2020;


select distinct education_text, education_code from joined_data_1_AllData