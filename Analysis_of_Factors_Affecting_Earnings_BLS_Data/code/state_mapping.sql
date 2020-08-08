Insert into state_mapping Values 
('Northeast', 'New England','Connecticut');
Insert into state_mapping Values
('Northeast','New England','Maine');
Insert into state_mapping Values
('Northeast','New England','Massachusetts');
Insert into state_mapping Values
('Northeast','New England','New Hampshire');
Insert into state_mapping Values
('Northeast','New England','Rhode Island');
Insert into state_mapping Values
('Northeast','New England','Vermont');
Insert into state_mapping Values
('Northeast','Middle Atlantic','New Jersey');
Insert into state_mapping Values
('Northeast','Middle Atlantic','New York');
Insert into state_mapping Values
('Northeast','Middle Atlantic','Pennsylvania');
Insert into state_mapping Values
('South','South Atlantic','Delaware');
Insert into state_mapping Values
('South','South Atlantic','District of Columbia');
Insert into state_mapping Values
('South','South Atlantic','Florida');
Insert into state_mapping Values
('South','South Atlantic','Georgia');
Insert into state_mapping Values
('South','South Atlantic','Maryland');
Insert into state_mapping Values
('South','South Atlantic','North Carolina');
Insert into state_mapping Values
('South','South Atlantic','South Carolina');
Insert into state_mapping Values
('South','South Atlantic','Virginia');
Insert into state_mapping Values
('South','South Atlantic','West Virginia');
Insert into state_mapping Values
('South','East South Central','Alabama');
Insert into state_mapping Values
('South','East South Central','Kentucky');
Insert into state_mapping Values
('South','East South Central','Mississippi');
Insert into state_mapping Values
('South','East South Central','Tennessee');
Insert into state_mapping Values
('South','West South Central','Arkansas');
Insert into state_mapping Values
('South','West South Central','Louisiana');
Insert into state_mapping Values
('South','West South Central','Oklahoma');
Insert into state_mapping Values
('South','West South Central','Texas');
Insert into state_mapping Values
('Midwest','East North Central','Illinois');
Insert into state_mapping Values
('Midwest','East North Central','Indiana');
Insert into state_mapping Values
('Midwest','East North Central','Michigan');
Insert into state_mapping Values
('Midwest','East North Central','Ohio');
Insert into state_mapping Values
('Midwest','East North Central','Wisconsin');
Insert into state_mapping Values
('Midwest','West North Central','Iowa');
Insert into state_mapping Values
('Midwest','West North Central','Kansas');
Insert into state_mapping Values
('Midwest','West North Central','Minnesota');
Insert into state_mapping Values
('Midwest','West North Central','Missouri');
Insert into state_mapping Values
('Midwest','West North Central','Nebraska');




Insert into state_mapping Values
('Midwest','West North Central','North Dakota'
);
Insert into state_mapping Values
('Midwest','West North Central','South Dakota'
);
Insert into state_mapping Values
('West','Mountain','Arizona'
);
Insert into state_mapping Values
('West','Mountain','Colorado'
);
Insert into state_mapping Values
('West','Mountain','Idaho'
);
Insert into state_mapping Values
('West','Mountain','Montana'
);
Insert into state_mapping Values
('West','Mountain','Nevada'
);
Insert into state_mapping Values
('West','Mountain','New Mexico'
);
Insert into state_mapping Values
('West','Mountain','Utah'
);
Insert into state_mapping Values
('West','Mountain','Wyoming'
);
Insert into state_mapping Values
('West','Pacific','Alaska'
);
Insert into state_mapping Values
('West','Pacific','California'
);
Insert into state_mapping Values
('West','Pacific','Hawaii'
);
Insert into state_mapping Values
('West','Pacific','Oregon'
);
Insert into state_mapping Values
('West','Pacific','Washington');

select * from state_mapping

#drop table state_mapping
CREATE TABLE `state_mapping` (
   `Division` varchar(45) DEFAULT NULL,
   `Region` varchar(45) DEFAULT NULL,
   `State` varchar(45) NOT NULL ,
  PRIMARY KEY (`State`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
