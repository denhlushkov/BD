INSERT INTO Diagnosis (diagnosis_id, title, description, severity_level) VALUES
(1, 'Post-Stroke Recovery', 'Motor skill rehab required', 'Severe'),
(2, 'Chronic Back Pain', 'Requires manual therapy', 'Moderate'),
(3, 'Sports Injury (ACL)', 'Post-operative physiotherapy', 'Mild');

INSERT INTO Procedure (procedure_id, title, cost, duration) VALUES
(1, 'Physiotherapy Session', 850.00, 60),
(2, 'Manual Therapy (Deep)', 1200.00, 45),
(3, 'Initial Consultation', 500.00, 30),
(4, 'Dry Needling', 700.00, 30);

INSERT INTO Schedule (schedule_id, date, start_time, end_time, is_available) VALUES
(1, '2025-11-15', '09:00:00', '17:00:00', TRUE),
(2, '2025-11-16', '10:00:00', '14:00:00', TRUE),
(3, '2025-11-15', '13:00:00', '18:00:00', TRUE);

INSERT INTO Therapist (therapist_id, schedule_id, name, specialization, phone) VALUES
(1, 1, 'Olena Kovalchuk', 'Physiotherapist', '098-111-2233'),
(2, 3, 'Dmytro Ivanenko', 'Manual Therapist', '067-444-5566');

INSERT INTO Patient (patient_id, diagnosis_id, name, birth_date, phone) VALUES
(1, 1, 'Vasyl Petrenko', '1985-05-10', '050-777-8899'),
(2, 2, 'Maria Semenova', '1992-02-28', '063-123-4567'),
(3, NULL, 'Ihor Boiko', '2001-11-01', '097-999-0011');

INSERT INTO Session (session_id, patient_id, procedure_id, therapist_id, date, duration, status, room_number) VALUES
(1, 1, 1, 1, '2025-11-15', 60, 'Completed', 'A1'),
(2, 2, 2, 2, '2025-11-15', 45, 'Completed', 'B2'),
(3, 3, 3, 1, '2025-11-16', 30, 'Scheduled', 'A1');

INSERT INTO Medical_Record (medical_rec_id, patient_id, notes) VALUES
(1, 1, 'Patient successfully completed the first stage of rehabilitation.'),
(2, 2, 'Pain reduction after manual therapy.');

INSERT INTO Invoice (invoice_id, session_id, amount) VALUES
(1, 1, 850.00),
(2, 2, 1200.00),
(3, 3, 500.00);

INSERT INTO Payment (payment_id, invoice_id, amount, method) VALUES
(1, 2, 1200.00, 'Card'),
(2, 1, 400.00, 'Cash');
