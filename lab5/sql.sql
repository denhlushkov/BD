ALTER TABLE medical_record 
DROP COLUMN IF EXISTS patient_id CASCADE;

ALTER TABLE patient 
ADD COLUMN IF NOT EXISTS medical_rec_id INTEGER;

ALTER TABLE patient 
ADD CONSTRAINT fk_patient_med_rec 
FOREIGN KEY (medical_rec_id) REFERENCES medical_record(medical_rec_id);

ALTER TABLE patient 
ADD CONSTRAINT uq_patient_med_rec UNIQUE (medical_rec_id);

ALTER TABLE medical_record 
DROP COLUMN IF EXISTS documents CASCADE;

ALTER TABLE medical_record 
ADD COLUMN IF NOT EXISTS photo TEXT;

ALTER TABLE payment 
DROP COLUMN IF EXISTS amount CASCADE;

UPDATE patient
SET medical_rec_id = 1 
WHERE name = 'Андрій Мельник';

UPDATE patient
SET medical_rec_id = 2  
WHERE name = 'Вікторія Іванова';

UPDATE patient
SET medical_rec_id = 3 
WHERE name = 'Сергій Вовк';

UPDATE patient
SET medical_rec_id = 4
WHERE name = 'Наталія Гришко';
