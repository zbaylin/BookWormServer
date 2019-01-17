CREATE TABLE "books" (
  "id" INTEGER NOT NULL PRIMARY KEY, 
  "isbn" VARCHAR(255) NOT NULL,
  "title" VARCHAR(255) NOT NULL, 
  "author" VARCHAR(255) NOT NULL, 
  "publisher" VARCHAR(255) NOT NULL, 
  "summary" TEXT NOT NULL, 
  "publication_date" TEXT NOT NULL,
  "rating" REAL NOT NULL
);

CREATE table "students" (
  "id" INTEGER NOT NULL PRIMARY KEY,
  "firstname" TEXT NOT NULL,
  "lastname" TEXT NOT NULL,
  "email" TEXT UNIQUE NOT NULL,
  "password" TEXT NOT NULL
);

CREATE TABLE "issuances" (
  "id" INTEGER NOT NULL PRIMARY KEY,
  "book_id" INTEGER NOT NULL,
  "student_id" INTEGER NOT NULL,
  "redeemed" INTEGER NOT NULL,
  "url" TEXT,
  "created_at" TEXT NOT NULL,
  "updated_at" TEXT NOT NULL,
  "redemption_key" TEXT NOT NULL,
    FOREIGN KEY ("book_id") REFERENCES books(id),
    FOREIGN KEY ("student_id") REFERENCES students(id)
);