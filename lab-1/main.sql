

SELECT 
  meta_table.name                       AS table_name,
  meta_table_column.name                AS column_name,
  meta_table_column.is_nullable         AS is_nullable,
  meta_display_contraint_single.name    AS contraint_name,
  meta_display_contraint_single.clause  AS contraint_clause
FROM meta_table
JOIN meta_table_column 
  ON meta_table_column.table_id = meta_table.id
LEFT JOIN meta_display_contraint_single ON (
  meta_display_contraint_single.constrained_table_id = meta_table.id AND
  meta_display_contraint_single.constrained_column_number = meta_table_column.number
)
WHERE meta_table.name LIKE 'person';

SELECT
  meta_table.name                         AS table_name,
  meta_display_contraint_multiple.name    AS contraint_name,
  meta_display_contraint_multiple.clause  AS contraint_clause
FROM meta_table
LEFT JOIN meta_display_contraint_multiple ON (
  meta_display_contraint_multiple.constrained_table_id = meta_table.id
)
WHERE meta_table.name LIKE 'person';
