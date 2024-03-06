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
    pg_attribute.attrelid         AS table_id,
    pg_attribute.attnum           AS number,
    pg_attribute.attname          AS name, 
    pg_attribute.atttypid         AS type_id,
    (NOT pg_attribute.attnotnull) AS is_nullable
  FROM pg_attribute;

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

-- TODO: t = constraint trigger
-- TODO: x = exclusion constraint

-- SELECT * FROM meta_namespace;
-- SELECT * FROM meta_table;
-- SELECT * FROM meta_table_column;
-- SELECT * FROM meta_constraint_check;
-- SELECT * FROM meta_constraint_foreign_key;
-- SELECT * FROM meta_constraint_primary_key;
-- SELECT * FROM meta_constraint_unique;
