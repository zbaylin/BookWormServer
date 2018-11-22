CREATE TABLE "books" (
  "id" INTEGER NOT NULL PRIMARY KEY, 
  "isbn" VARCHAR(255) NOT NULL,
  "title" VARCHAR(255) NOT NULL, 
  "author" VARCHAR(255) NOT NULL, 
  "publisher" VARCHAR(255) NOT NULL, 
  "summary" TEXT NOT NULL, 
  "publication_date" TEXT NOT NULL
);