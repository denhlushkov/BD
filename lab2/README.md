# Опис схеми бази даних 

Цей звіт описує реляційну схему PostgreSQL, створену на основі ER-діаграми для системи управління клінікою. Схема призначена для обліку пацієнтів, терапевтів, сеансів, медичних записів та фінансових операцій (рахунків та платежів).

Огляд таблиць та обмежень

### Діаграма ER:

<img width="827" height="965" alt="image" src="https://github.com/user-attachments/assets/36086942-55e6-4544-9a1d-2553633baec3" />

### Детальний опис кожної таблиці, її стовпців, ключів та ключових обмежень:

1.  **Schedule** (Розклад)
     * Опис: Зберігає робочі графіки терапевтів
     * Стовпці: schedule_id (PK, Serial), date (Date), start_time (Time), end_time (Time), is_available (Boolean).
     * Обмеження: CHECK (end_time > start_time) гарантує коректність часових проміжків.
2. **Diagnosis** (Діагноз)
     * Опис: Довідник діагнозів, які можуть бути призначені пацієнтам.
     * Стовпці: diagnosis_id (PK, Serial), title (Varchar, Not Null, Unique), description (Text), severity_level (Varchar).
       
3. **Procedure** (Процедура)
    * Опис: Довідник послуг/процедур, що надаються клінікою, з їх вартістю та тривалістю.
    * Стовпці: procedure_id (PK, Serial), title (Varchar, Not Null, Unique), cost (Numeric, Not Null), duration (Integer, Not Null).
    * Обмеження: CHECK (cost >= 0) запобігає від'ємній вартості.

4. **Therapist** (Терапевт)
    * Опис: Зберігає інформацію про співробітників (терапевтів).
    * Стовпці: therapist_id (PK, Serial), schedule_id (FK -> Schedule), name (Varchar, Not Null), specialization (Varchar), phone (Varchar, Unique), photo (Text).
    * Зв'язки: Посилається на Schedule для визначення робочого графіка.

5. **Patient** (Пацієнт)
    * Опис: Зберігає демографічну інформацію про пацієнтів.
    * Стовпці: patient_id (PK, Serial), diagnosis_id (FK -> Diagnosis), name (Varchar, Not Null), birth_date (Date, Not Null), phone (Varchar, Not Null, Unique).
    * Зв'язки: diagnosis_id виступає як посилання на поточний або основний діагноз пацієнта (може бути NULL).

6. **Medical_Record** (Медичний Запис)
    * Опис: Зберігає історію хвороби, нотатки та документи для кожного пацієнта.
    * Стовпці: medical_rec_id (PK, Serial), patient_id (FK -> Patient, Not Null, Unique), date (Date), notes (Text), documents (Text).
    * Ключове припущення (1-до-1): Обмеження UNIQUE на patient_id реалізує бізнес-правило "Пацієнт може мати лише одну медичну карту".

7. **Session** (Сеанс / Прийом)
    * Опис: Центральна таблиця, що пов'язує пацієнта, терапевта та процедуру в конкретний час.
    * Стовпці: session_id (PK, Serial), procedure_id (FK -> Procedure, Not Null), patient_id (FK -> Patient, Not Null), therapist_id (FK -> Therapist, Not Null), date (Date, Not Null), duration (Integer), status (Varchar, Not Null), room_number (Varchar).
    * Обмеження: CHECK на status дозволяє лише визначені значення ('Scheduled', 'Completed', 'Cancelled'), що забезпечує узгодженість даних.

8. **Invoice** (Рахунок)
    * Опис: Зберігає фінансову інформацію (суму) для кожного проведеного сеансу.
    * Стовпці: invoice_id (PK, Serial), session_id (FK -> Session, Not Null, Unique), amount (Numeric, Not Null), issue_date (Date, Not Null).
    * Ключове припущення (1-до-1): Обмеження UNIQUE на session_id реалізує бізнес-правило "За один прийом має бути винесений лише один рахунок".
    * Обмеження: CHECK (amount >= 0) для валідації суми.

9. **Payment** (Платіж)
    * Опис: Фіксує фактичні платежі, отримані за рахунками.
    * Стовпці: payment_id (PK, Serial), invoice_id (FK -> Invoice, Not Null), amount (Numeric, Not Null), payment_date (Date, Not Null), method (Varchar).
    * Ключове припущення (1-до-багатьох): Відсутність UNIQUE на invoice_id дозволяє реалізувати бізнес-правило "Для одного Рахунку може бути одна або декілька оплат".
    * Обмеження: CHECK (amount > 0) гарантує, що платіж не може бути нульовим або від'ємним.
