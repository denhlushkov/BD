# Лабораторна робота №6: Міграції схем з Prisma ORM

## 1. Вступ
Метою цієї лабораторної роботи було налаштування Prisma ORM для існуючої бази даних PostgreSQL та виконання ряду міграцій для зміни структури схеми. Ми керували схемою для системи медичної клініки.

## 2. Виконані Міграції

Було виконано три послідовні міграції, що відображають необхідні зміни у структурі даних.

### Міграція 1: Додавання таблиці Обладнання (add_equipment_table)
**Мета**: Додати нову сутність Equipment для відстеження інвентарю, що використовується в сесіях.

**Зміни в schema.prisma:** Створено нову модель Equipment.

Фрагмент кода:
```prisma
model Equipment {
  equipment_id      Int      @id @default(autoincrement())
  name              String   @db.VarChar(100)
  manufacturer      String?
  last_maintenance  DateTime?
  sessions_used     SessionEquipment[]
}
```
**Результат (SQL):** Створено таблицю Equipment (обладнання).

### Міграція 2: Оптимізація таблиці Терапевтів (remove_therapist_photo)
**Мета:** Видалити поле photo з таблиці Therapist, оскільки зберігання бінарних даних або URL-адрес фотографій буде перенесено у зовнішнє сховище.

**Зміни в schema.prisma:** Рядок photo String? було видалено з моделі Therapist.

Фрагмент кода:
```prisma
model Therapist {
  therapist_id   Int      @id @default(autoincrement())
  // ...
  phone          String?
  // photo поле було видалено
}
```
**Результат (SQL):** `ALTER TABLE "Therapist" DROP COLUMN "photo";`

### Міграція 3: Оновлення таблиці Діагнозів (add_diagnosis_field)
**Мета:** Додати поле restore_time до таблиці Diagnosis для показу терміну реабілітації після хвороби.

**Зміни в schema.prisma:** Додано нове поле restore_time до моделі Diagnosis.

Фрагмент кода:
```prisma
model Diagnosis {
  diagnosis_id   Int      @id @default(autoincrement())
  title          String
  description    String?
  severity_level String
  "restore_time" DATE NOT NULL, -- Додав поле
}
```
**Результат (SQL):** `ALTER TABLE "Diagnosis" ADD COLUMN "restore_time" VARCHAR(10) UNIQUE;`

## 3. Перевірка роботи (Prisma Client)

Для перевірки роботи міграцій та нових зв'язків було використано скрипт на Node.js для вставки та вибірки даних.

**Приклад коду:**
```javascript
const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();

async function main() {

    // 1. Створення нового запису Patient
    const newPatient = await prisma.patient.create({
        data: {
            name: 'Олеся Коваль',
            phone: '099-555-4433',
            birth_date: new Date('1998-03-20'),
            diagnosis_id: 1,
        }
    });

    console.log(`Створено Пацієнта: ${newPatient.name} (ID: ${newPatient.patient_id})`);

    // 2. Створення нового запису Session
    const newSession = await prisma.session.create({
        data: {
            patient_id: newPatient.patient_id,
            therapist_id: 1,
            procedure_id: 1,
            date: new Date('2026-01-20'),
            duration: 45,
            status: 'Scheduled',
            room_number: 'B3'
        }
    });

    console.log(`Створено Сесію: ID ${newSession.session_id} на ${newSession.date.toLocaleDateString()}`);

    const invoiceAmount = 500.00; 

    // 3. Створення нового рахунку, пов'язаного з сесією
    const newInvoice = await prisma.invoice.create({
        data: {
            session_id: newSession.session_id,
            amount: invoiceAmount,
            issue_date: new Date(),
            payment_status: 'Pending' 
        }
    });

    console.log(`Створено Рахунок ID ${newInvoice.invoice_id} на суму ${newInvoice.amount}`);

    // 4. Реєстрація оплати за рахунок
    const newPayment = await prisma.payment.create({
        data: {
            invoice_id: newInvoice.invoice_id,
            amount: invoiceAmount,
            method: 'Card', 
        }
    });

    console.log(`Зареєстровано Оплату ID ${newPayment.payment_id}. Сума: ${newPayment.amount}`);

    // 5. Зчитування пацієнта, включаючи їхні сесії, рахунки та оплати (для повної перевірки ланцюжка)
    const patientDetails = await prisma.patient.findMany({
        where: { patient_id: newPatient.patient_id },
        include: { 
            sessions: {
                include: { 
                    invoice: {
                        include: { payments: true }
                    }
                }
            } 
        }
    });
    
    const sessionDetails = patientDetails[0].sessions[0];

    console.log(`Знайдено пацієнта ${patientDetails[0].name}. Кількість сесій: ${patientDetails[0].sessions.length}`);
    console.log(`Деталі сесії: ${sessionDetails.status} у кімнаті ${sessionDetails.room_number}`);
    console.log(`Статус оплати: ${sessionDetails.invoice.payment_status} (Платежів: ${sessionDetails.invoice.payments.length})`);
    
}

// Виклик основної функції та обробка завершення
main()
    .catch(e => {
        console.error("Помилка виконання скрипту Prisma:", e.message); 
    })
    .finally(async () => {
        await prisma.$disconnect();
    });
```
## Висновок
У ході лабораторної роботи було успішно налаштовано Prisma ORM, проведено синхронізацію з існуючою базою даних та виконано 3 міграції для еволюції схеми. Було підтверджено, що нові таблиці та поля функціонують належним чином, а всі структурні зміни зафіксовані в історії міграцій, забезпечуючи надійний контроль версій.
