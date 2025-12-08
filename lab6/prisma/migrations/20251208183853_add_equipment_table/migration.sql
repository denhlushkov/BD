/*
  Warnings:

  - Added the required column `equipment_id` to the `session` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "session" ADD COLUMN     "equipment_id" INTEGER NOT NULL;

-- CreateTable
CREATE TABLE "equipment" (
    "equipment_id" SERIAL NOT NULL,
    "name" VARCHAR(100) NOT NULL,
    "manufacturer" TEXT,
    "last_maintenance" TIMESTAMP(3),
    "location" TEXT,

    CONSTRAINT "equipment_pkey" PRIMARY KEY ("equipment_id")
);

-- AddForeignKey
ALTER TABLE "session" ADD CONSTRAINT "session_equipment_id_fkey" FOREIGN KEY ("equipment_id") REFERENCES "equipment"("equipment_id") ON DELETE NO ACTION ON UPDATE NO ACTION;
