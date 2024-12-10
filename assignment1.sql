Create a file format for csv
=================================
 create or replace file format dev.file_format.csv_format
 type = 'csv'
 Field_Delimiter=','
 skip_header = 1 
 FIELD_OPTIONALLY_ENCLOSED_BY='"';

Create an external stage on s3 bucket
=======================================
create or replace stage dev.learning.ext_stage 
url= 's3://<bucket_name>/test/patient_records.csv'
file_format = dev.file_format.csv_format 
ENCRYPTION = (TYPE = 'AWS_SSE_KMS' KMS_KEY_ID = '<KMS KEY>');

select count(*) from @dev.learning.ext_stage;

 create or replace table dev.learning.patients(
  memberid int,
  name varchar(50),
  age varchar(4),
  medication varchar(50)
 );

copy into dev.tables.patients from @dev.learning.ext_stage;

select * from dev.tables.patients;
 
 --  create a materialized view
 CREATE MATERIALIZED VIEW dev.learning.avgAgeByMedication AS
 SELECT medication, AVG(age) AS
 AvgAge
 FROM dev.tables.patients
 GROUP BY medication;

 -- Query the materialized view:
select * from dev.learning.avgAgeByMedication;
