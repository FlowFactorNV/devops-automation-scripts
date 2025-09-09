# 📘 PostgreSQL vs Oracle Commands Cheat Sheet

## 🔍 General Info

| Task            | PostgreSQL                    | Oracle                        |
|-----------------|-------------------------------|-------------------------------|
| Show version    | `SELECT version();`           | `SELECT * FROM v$version;`    |

---

## 📁 Database / Schema

| Task            | PostgreSQL                                  | Oracle                                              |
|-----------------|---------------------------------------------|-----------------------------------------------------|
| Create database | `CREATE DATABASE dbname;`                   | *N/A* (use `CREATE USER` + tablespace)              |
| List databases  | `\l` or `SELECT datname FROM pg_database;`  | `SELECT name FROM v$database;`                      |
| Use database    | `\c dbname`                                 | *Implicit after login*                              |
| Show schemas    | `\dn` or `SELECT schema_name FROM information_schema.schemata;` | `SELECT username FROM all_users;` |
| Create schema   | `CREATE SCHEMA myschema;`                   | `CREATE USER myschema IDENTIFIED BY password;`      |

---

## 👤 Users & Permissions

| Task                  | PostgreSQL                                      | Oracle                                   |
|-----------------------|-------------------------------------------------|------------------------------------------|
| Create user           | `CREATE USER user WITH PASSWORD 'pwd';`        | `CREATE USER user IDENTIFIED BY pwd;`    |
| Grant privileges      | `GRANT SELECT ON table TO user;`               | Same                                     |
| Grant all on DB       | `GRANT ALL PRIVILEGES ON DATABASE db TO user;` | `GRANT ALL PRIVILEGES TO user;`          |

---

## 📊 Tables

| Task          | PostgreSQL                                | Oracle                            |
|---------------|--------------------------------------------|-----------------------------------|
| Create table  | `CREATE TABLE t (...);`                    | Same                              |
| List tables   | `\dt` or `SELECT * FROM information_schema.tables;` | `SELECT table_name FROM user_tables;` |
| Describe table| `\d table`                                 | `DESC table`                      |
| Drop table    | `DROP TABLE t;`                            | Same                              |

---

## 🔄 Data Manipulation

| Task        | PostgreSQL                                | Oracle                         |
|-------------|--------------------------------------------|--------------------------------|
| Insert      | `INSERT INTO t VALUES (...);`              | Same                           |
| Update      | `UPDATE t SET ... WHERE ...;`              | Same                           |
| Delete      | `DELETE FROM t WHERE ...;`                 | Same                           |
| Upsert      | `INSERT ... ON CONFLICT ...`               | `MERGE INTO ...`               |

---

## 📈 Queries

| Task               | PostgreSQL                                       | Oracle                                                      |
|--------------------|--------------------------------------------------|-------------------------------------------------------------|
| Limit rows         | `SELECT * FROM t LIMIT 10;`                      | `SELECT * FROM t WHERE ROWNUM <= 10;`                       |
| Top-N with sort    | `ORDER BY col DESC LIMIT 5;`                     | `SELECT * FROM (SELECT * FROM t ORDER BY col DESC) WHERE ROWNUM <= 5;` |
| String concat      | `' || '` or `CONCAT()`                           | `' || '`                                                    |
| Current date       | `CURRENT_DATE` or `NOW()`                        | `SYSDATE`                                                   |
| Auto-increment     | `SERIAL` or `GENERATED AS IDENTITY`             | `SEQUENCE` + `TRIGGER`                                      |

---

## 🔧 DDL / Index / Constraints

| Task              | PostgreSQL                             | Oracle                           |
|-------------------|------------------------------------------|----------------------------------|
| Add column        | `ALTER TABLE t ADD col TYPE;`           | Same                             |
| Add primary key   | `ALTER TABLE t ADD PRIMARY KEY(col);`   | Same                             |
| Create index      | `CREATE INDEX idx ON t(col);`           | Same                             |
| Drop column       | `ALTER TABLE t DROP COLUMN col;`        | Same                             |

---

## 🛠️ Advanced Features

| Feature              | PostgreSQL                         | Oracle                              |
|----------------------|------------------------------------|-------------------------------------|
| JSON support         | Full (native `JSON`, `JSONB`)      | Partial (12c+ with `IS JSON`)       |
| Window functions     | ✅ Yes                              | ✅ Yes                               |
| CTE / WITH queries   | ✅ Yes                              | ✅ Yes                               |
| Materialized views   | `CREATE MATERIALIZED VIEW`         | Same                                |
| Recursive queries    | `WITH RECURSIVE`                   | Recursive WITH (12c+)               |
| Full-text search     | Built-in (`tsvector`)              | Oracle Text                         |
