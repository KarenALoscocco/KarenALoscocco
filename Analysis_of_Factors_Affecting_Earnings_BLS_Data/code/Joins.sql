CREATE TABLE joined_data_0_current_states
SELECT 
`series`.`series_id`,
    `series`.`lfst_code`,
    `series`.`fips_code`,
    `series`.`series_title`,
    `series`.`tdata_code`,
    `series`.`pcts_code`,
    `series`.`earn_code`,
    `series`.`cert_code`,
    `series`.`class_code`,
    `series`.`unin_code`,
    `series`.`indy_code`,
    `series`.`occupation_code`,
    `series`.`education_code`,
    `series`.`ages_code`,
    `series`.`race_code`,
    `series`.`orig_code`,
    `series`.`sexs_code`,
    `series`.`born_code`,
    `series`.`seasonal`,
    `series`.`footnote_codes`,
    `series`.`begin_year`,
    `series`.`begin_period`,
    `series`.`end_year`,
    `series`.`end_period`,
    `data_0_current`.`year`,
    `data_0_current`.`period`,
    `data_0_current`.`value`,
    `ages`.`ages_text`,
    `born`.`born_text`,
    `cert`.`cert_text`,
    `class`.`class_text`,
    `earn`.`earn_text`,
    `education`.`education_text`,
    `fips`.`fips_text`,
    `state_mapping`.`state`,
    `state_mapping`.`region`, 
    `state_mapping`.`division`,
    `indy`.`indy_text`,
    `lfst`.`lfst_text`,
    `occupation`.`occupation_text`,
    `orig`.`orig_text`,
    `pcts`.`pcts_text`,
    `race`.`race_text`,
    `seasonal`.`seasonal_text`,
    `sexs`.`sexs_text`,
    `tdata`.`tdata_text`,
    `unin`.`unin_text`
FROM series 
LEFT JOIN data_0_current ON series.series_id = data_0_current.series_id
LEFT JOIN ages ON series.ages_code = ages.ages_code
LEFT JOIN born ON series.born_code = born.born_code
LEFT JOIN cert ON series.cert_code = cert.cert_code
LEFT JOIN class ON series.class_code = class.class_code
LEFT JOIN earn ON series.earn_code = earn.earn_code
LEFT JOIN education ON series.education_code = education.education_code
LEFT JOIN fips ON series.fips_code = fips.fips_code
LEFT JOIN indy ON series.indy_code = indy.indy_code
LEFT JOIN lfst ON series.lfst_code = lfst.lfst_code
LEFT JOIN occupation ON series.occupation_code = occupation.occupation_code
LEFT JOIN orig ON series.orig_code = orig.orig_code
LEFT JOIN pcts ON series.pcts_code = pcts.pcts_code
LEFT JOIN race ON series.race_code = race.race_code
LEFT JOIN seasonal ON series.seasonal = seasonal.seasonal_code
LEFT JOIN sexs ON series.sexs_code = sexs.sexs_code
LEFT JOIN tdata ON series.tdata_code = tdata.tdata_code
LEFT JOIN unin ON series.unin_code = unin.unin_code
LEFT JOIN state_mapping on fips.fips_text = state_mapping.State
;

select distinct fips_code,fips_text, state,region, division 
from joined_data_1_AllData
left join state_mapping on joined_data_1_AllData.fips_text = state_mapping.State
;

CREATE TABLE joined_data_1_AllData_states
select * 
from joined_data_1_AllData
left join state_mapping on joined_data_1_AllData.fips_text = state_mapping.State
;
# select * from joined_data_1_AllData;

-- alter table state_mapping
-- MODIFY COLUMN State text CHARACTER SET utf8;
