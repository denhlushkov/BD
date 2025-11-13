CREATE TABLE IF NOT EXISTS Schedule (
    schedule_id SERIAL PRIMARY KEY,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT check_time CHECK (end_time > start_time)
);

CREATE TABLE IF NOT EXISTS Diagnosis (
    diagnosis_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL UNIQUE,
    description TEXT,
    severity_level VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Procedure (
    procedure_id SERIAL PRIMARY KEY,
    title VARCHAR(150) NOT NULL UNIQUE,
    cost NUMERIC(10, 2) NOT NULL CHECK (cost >= 0),
    duration INTEGER NOT NULL 
);

CREATE TABLE IF NOT EXISTS Therapist (
    therapist_id SERIAL PRIMARY KEY,
    schedule_id INTEGER REFERENCES Schedule(schedule_id),
    name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20) UNIQUE,
    photo TEXT 
);

CREATE TABLE IF NOT EXISTS Patient (
    patient_id SERIAL PRIMARY KEY,
    diagnosis_id INTEGER REFERENCES Diagnosis(diagnosis_id),
    name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Medical_Record (
    medical_rec_id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL UNIQUE REFERENCES Patient(patient_id),
    date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    documents TEXT 
);

CREATE TABLE IF NOT EXISTS Session (
    session_id SERIAL PRIMARY KEY,
    procedure_id INTEGER NOT NULL REFERENCES Procedure(procedure_id),
    patient_id INTEGER NOT NULL REFERENCES Patient(patient_id),
    therapist_id INTEGER NOT NULL REFERENCES Therapist(therapist_id),
    date DATE NOT NULL,
    duration INTEGER NOT NULL, 
    status VARCHAR(20) NOT NULL CHECK (status IN ('Scheduled', 'Completed', 'Cancelled')),
    room_number VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS Invoice (
    invoice_id SERIAL PRIMARY KEY,
    session_id INTEGER NOT NULL UNIQUE REFERENCES Session(session_id),
    amount NUMERIC(10, 2) NOT NULL CHECK (amount >= 0),
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE IF NOT EXISTS Payment (
    payment_id SERIAL PRIMARY KEY,
    invoice_id INTEGER NOT NULL REFERENCES Invoice(invoice_id),
    amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
    payment_date DATE NOT NULL DEFAULT CURRENT_DATE,
    method VARCHAR(50) CHECK (method IN ('Cash', 'Card', 'Bank Transfer'))
);