-- 1
SELECT 
    SUM(amount) AS total_revenue,
    AVG(amount) AS average_payment,
    MIN(amount) AS min_payment,
    MAX(amount) AS max_payment
FROM Payment;


SELECT 
    d.title AS diagnosis_title,
    COUNT(p.patient_id) AS patient_count
FROM Patient p
JOIN Diagnosis d ON p.diagnosis_id = d.diagnosis_id
GROUP BY d.title
ORDER BY patient_count DESC;


SELECT 
    pr.title AS procedure_title,
    AVG(s.duration) AS avg_duration_minutes,
    COUNT(s.session_id) AS times_performed
FROM Session s
JOIN Procedure pr ON s.procedure_id = pr.procedure_id
GROUP BY pr.title;


SELECT 
    t.name AS therapist_name,
    COUNT(s.session_id) AS sessions_count
FROM Session s
JOIN Therapist t ON s.therapist_id = t.therapist_id
GROUP BY t.name
HAVING COUNT(s.session_id) > 1;


--  2
SELECT 
    s.date,
    t.name AS therapist,
    p.name AS patient,
    proc.title AS procedure,
    s.status
FROM Session s
INNER JOIN Therapist t ON s.therapist_id = t.therapist_id
INNER JOIN Patient p ON s.patient_id = p.patient_id
INNER JOIN Procedure proc ON s.procedure_id = proc.procedure_id
WHERE s.status = 'Completed';


SELECT 
    p.name,
    p.phone,
    COALESCE(SUM(pay.amount), 0) AS total_paid
FROM Patient p
LEFT JOIN Session s ON p.patient_id = s.patient_id
LEFT JOIN Invoice i ON s.session_id = i.session_id
LEFT JOIN Payment pay ON i.invoice_id = pay.invoice_id
GROUP BY p.patient_id, p.name, p.phone
ORDER BY total_paid DESC;


SELECT 
    t.name AS therapist,
    proc.title AS potential_procedure,
    proc.cost
FROM Therapist t
CROSS JOIN Procedure proc;


--3
SELECT 
    s.session_id,
    s.date,
    pr.title,
    pr.cost
FROM Session s
JOIN Procedure pr ON s.procedure_id = pr.procedure_id
WHERE pr.cost > (SELECT AVG(cost) FROM Procedure);


SELECT 
    p.name,
    p.birth_date,
    (p.birth_date - (SELECT MIN(birth_date) FROM Patient)) AS days_younger_than_oldest
FROM Patient p;


SELECT name, phone 
FROM Patient
WHERE patient_id NOT IN (SELECT patient_id FROM Medical_Record);


--4
SELECT 
    t.name AS therapist_name,
    t.specialization,
    COUNT(s.session_id) AS total_sessions,
    SUM(i.amount) AS total_invoiced_amount
FROM Therapist t
JOIN Session s ON t.therapist_id = s.therapist_id
JOIN Invoice i ON s.session_id = i.session_id
GROUP BY t.therapist_id, t.name, t.specialization
ORDER BY total_invoiced_amount DESC;
