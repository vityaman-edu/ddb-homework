DROP VIEW IF EXISTS meta_namespace CASCADE;
CREATE VIEW meta_namespace AS 
  SELECT 
    pg_namespace.oid     AS id,
    pg_namespace.nspname AS name
  FROM pg_namespace;

DROP VIEW IF EXISTS meta_table CASCADE;
CREATE VIEW meta_table AS 
  SELECT 
    pg_class.oid          AS id,
    pg_class.relname      AS name,
    pg_class.relnamespace AS namespace_id
  FROM pg_class;

DROP VIEW IF EXISTS meta_table_column CASCADE;
CREATE VIEW meta_table_column AS 
  SELECT 
    pg_attribute.attrelid              AS table_id,
    pg_attribute.attnum                AS number,
    pg_attribute.attname               AS name, 
    pg_attribute.atttypid              AS type_id,
    NULLIF(pg_attribute.atttypmod, -1) AS type_data,
    (NOT pg_attribute.attnotnull)      AS is_nullable
  FROM pg_attribute;

DROP VIEW IF EXISTS meta_comment CASCADE;
CREATE VIEW meta_comment AS 
  SELECT 
    pg_description.objoid       AS owner_id,
    pg_description.objsubid     AS child_id,
    pg_description.description  AS content
  FROM pg_description;

DROP VIEW IF EXISTS meta_type CASCADE;
CREATE VIEW meta_type AS 
  SELECT 
    pg_type.oid     AS id,
    pg_type.typname AS name
  FROM pg_type;

DROP VIEW IF EXISTS meta_operator CASCADE;
CREATE VIEW meta_operator AS
  SELECT
    pg_operator.oid       AS id,
    pg_operator.oprname   AS name
  FROM pg_operator;

DROP VIEW IF EXISTS meta_constraint_check CASCADE;
CREATE VIEW meta_constraint_check AS 
  SELECT 
    pg_constraint.oid                                            AS id,
    pg_constraint.conname                                        AS name,
    pg_constraint.connamespace                                   AS namespace_id,
    pg_constraint.conrelid                                       AS constrained_table_id,
    pg_constraint.conkey                                         AS constrained_column_numbers,
    pg_get_expr(pg_constraint.conbin, COALESCE(pg_class.oid, 0)) AS clause
  FROM pg_constraint
  LEFT JOIN pg_class ON pg_class.oid = pg_constraint.conrelid
  WHERE pg_constraint.contype = 'c';

DROP VIEW IF EXISTS meta_constraint_foreign_key CASCADE;
CREATE VIEW meta_constraint_foreign_key AS 
  SELECT 
    pg_constraint.oid          AS id,
    pg_constraint.conname      AS name,
    pg_constraint.connamespace AS namespace_id,
    pg_constraint.conrelid     AS constrained_table_id,
    pg_constraint.conkey       AS constrained_column_numbers,
    pg_constraint.confrelid    AS referenced_table_id,
    pg_constraint.confkey      AS referenced_column_numbers
  FROM pg_constraint
  WHERE pg_constraint.contype = 'f';

DROP VIEW IF EXISTS meta_constraint_primary_key CASCADE;
CREATE VIEW meta_constraint_primary_key AS 
  SELECT 
    pg_constraint.oid          AS id,
    pg_constraint.conname      AS name,
    pg_constraint.connamespace AS namespace_id,
    pg_constraint.conrelid     AS constrained_table_id,
    pg_constraint.conkey       AS constrained_column_numbers
  FROM pg_constraint
  WHERE pg_constraint.contype = 'p';

DROP VIEW IF EXISTS meta_constraint_unique CASCADE;
CREATE VIEW meta_constraint_unique AS 
  SELECT 
    pg_constraint.oid          AS id,
    pg_constraint.conname      AS name,
    pg_constraint.connamespace AS namespace_id,
    pg_constraint.conrelid     AS constrained_table_id,
    pg_constraint.conkey       AS constrained_column_numbers
  FROM pg_constraint
  WHERE pg_constraint.contype = 'u';

DROP VIEW IF EXISTS meta_constraint_exclusion CASCADE;
CREATE VIEW meta_constraint_exclusion AS 
  SELECT 
    pg_constraint.oid          AS id,
    pg_constraint.conname      AS name,
    pg_constraint.connamespace AS namespace_id,
    pg_constraint.conrelid     AS constrained_table_id,
    pg_constraint.conkey       AS constrained_column_numbers,
    pg_constraint.conexclop    AS per_column_operator_ids
  FROM pg_constraint
  WHERE pg_constraint.contype = 'x';
