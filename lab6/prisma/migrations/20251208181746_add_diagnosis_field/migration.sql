-- CreateTable
CREATE TABLE "diagnosis" (
    "diagnosis_id" SERIAL NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "description" TEXT,
    "severity_level" VARCHAR(50),
    "restore_time" DATE NOT NULL, -- Додав поле

    CONSTRAINT "diagnosis_pkey" PRIMARY KEY ("diagnosis_id")
);

-- CreateTable
CREATE TABLE "invoice" (
    "invoice_id" SERIAL NOT NULL,
    "session_id" INTEGER NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "issue_date" DATE NOT NULL DEFAULT CURRENT_DATE,

    CONSTRAINT "invoice_pkey" PRIMARY KEY ("invoice_id")
);

-- CreateTable
CREATE TABLE "medical_record" (
    "medical_rec_id" SERIAL NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "notes" TEXT,
    "documents" TEXT,

    CONSTRAINT "medical_record_pkey" PRIMARY KEY ("medical_rec_id")
);

-- CreateTable
CREATE TABLE "patient" (
    "patient_id" SERIAL NOT NULL,
    "diagnosis_id" INTEGER,
    "name" VARCHAR(100) NOT NULL,
    "birth_date" DATE NOT NULL,
    "phone" VARCHAR(20) NOT NULL,

    CONSTRAINT "patient_pkey" PRIMARY KEY ("patient_id")
);

-- CreateTable
CREATE TABLE "payment" (
    "payment_id" SERIAL NOT NULL,
    "invoice_id" INTEGER NOT NULL,
    "payment_date" DATE NOT NULL DEFAULT CURRENT_DATE,
    "method" VARCHAR(50),

    CONSTRAINT "payment_pkey" PRIMARY KEY ("payment_id")
);

-- CreateTable
CREATE TABLE "procedure" (
    "procedure_id" SERIAL NOT NULL,
    "title" VARCHAR(150) NOT NULL,
    "cost" DECIMAL(10,2) NOT NULL,
    "duration" INTEGER NOT NULL,

    CONSTRAINT "procedure_pkey" PRIMARY KEY ("procedure_id")
);

-- CreateTable
CREATE TABLE "schedule" (
    "schedule_id" SERIAL NOT NULL,
    "date" DATE NOT NULL,
    "start_time" TIME(6) NOT NULL,
    "end_time" TIME(6) NOT NULL,
    "is_available" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "schedule_pkey" PRIMARY KEY ("schedule_id")
);

-- CreateTable
CREATE TABLE "session" (
    "session_id" SERIAL NOT NULL,
    "procedure_id" INTEGER NOT NULL,
    "patient_id" INTEGER NOT NULL,
    "therapist_id" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "duration" INTEGER NOT NULL,
    "status" VARCHAR(20) NOT NULL,
    "room_number" VARCHAR(10),

    CONSTRAINT "session_pkey" PRIMARY KEY ("session_id")
);

-- CreateTable
CREATE TABLE "therapist" (
    "therapist_id" SERIAL NOT NULL,
    "schedule_id" INTEGER,
    "name" VARCHAR(100) NOT NULL,
    "specialization" VARCHAR(100),
    "phone" VARCHAR(20),
    "photo" TEXT,

    CONSTRAINT "therapist_pkey" PRIMARY KEY ("therapist_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "diagnosis_title_key" ON "diagnosis"("title");

-- CreateIndex
CREATE UNIQUE INDEX "invoice_session_id_key" ON "invoice"("session_id");

-- CreateIndex
CREATE UNIQUE INDEX "medical_record_patient_id_key" ON "medical_record"("patient_id");

-- CreateIndex
CREATE UNIQUE INDEX "patient_phone_key" ON "patient"("phone");

-- CreateIndex
CREATE UNIQUE INDEX "procedure_title_key" ON "procedure"("title");

-- CreateIndex
CREATE UNIQUE INDEX "therapist_phone_key" ON "therapist"("phone");

-- AddForeignKey
ALTER TABLE "invoice" ADD CONSTRAINT "invoice_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "session"("session_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "medical_record" ADD CONSTRAINT "medical_record_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patient"("patient_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "patient" ADD CONSTRAINT "patient_diagnosis_id_fkey" FOREIGN KEY ("diagnosis_id") REFERENCES "diagnosis"("diagnosis_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "payment" ADD CONSTRAINT "payment_invoice_id_fkey" FOREIGN KEY ("invoice_id") REFERENCES "invoice"("invoice_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_patient_id_fkey" FOREIGN KEY ("patient_id") REFERENCES "patient"("patient_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_procedure_id_fkey" FOREIGN KEY ("procedure_id") REFERENCES "procedure"("procedure_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_therapist_id_fkey" FOREIGN KEY ("therapist_id") REFERENCES "therapist"("therapist_id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "therapist" ADD CONSTRAINT "therapist_schedule_id_fkey" FOREIGN KEY ("schedule_id") REFERENCES "schedule"("schedule_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
