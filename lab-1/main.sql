DROP VIEW IF EXISTS main_table_column_constraint CASCADE;
CREATE VIEW main_table_column_constraint AS
  SELECT
    meta_namespace.name                   AS schema_name,
    meta_table.name                       AS table_name,
    meta_table_column.name                AS column_name,
    meta_display_contraint_single.name    AS contraint_name,
    meta_display_contraint_single.clause  AS contraint_clause
  FROM meta_table
  JOIN meta_namespace ON meta_table.namespace_id = meta_namespace.id
  JOIN meta_table_column 
    ON meta_table_column.table_id = meta_table.id
  LEFT JOIN meta_display_contraint_single ON (
    meta_display_contraint_single.constrained_table_id = meta_table.id AND
    meta_display_contraint_single.constrained_column_number = meta_table_column.number
  );

DROP VIEW IF EXISTS main_table_constraint CASCADE;
CREATE VIEW main_table_constraint AS
  SELECT
    meta_namespace.name                     AS schema_name,
    meta_table.name                         AS table_name,
    meta_display_contraint_multiple.name    AS constraint_name,
    meta_display_contraint_multiple.clause  AS constraint_clause
  FROM meta_table
  JOIN meta_namespace ON meta_table.namespace_id = meta_namespace.id
  LEFT JOIN meta_display_contraint_multiple ON (
    meta_display_contraint_multiple.constrained_table_id = meta_table.id
  );

DROP PROCEDURE IF EXISTS main_table_print_pretty;
CREATE PROCEDURE main_table_print_pretty (
  table_schema  text,
  table_name    text
) AS $$
DECLARE 
  col        record;
  col_constr record;

  C1W  integer;
  C2W  integer;
  C31W integer;
  C32W integer;
  REM  integer;
BEGIN
  C1W := 2;
  C2W := 12;
  C31W := 8;
  C32W := 64 + 8;
  REM := 11;

  ----- HEADER -----
  RAISE INFO 
    '%', 
    rpad(
      '|--- Table "' || table_schema || '.' || table_name || '" Information ', 
      C1W + C2W + C31W + C32W + REM, 
      '-'
    ) || '|';

  RAISE INFO 
    '| % | % | % |',
    rpad('N', C1W, ' '),
    rpad('Name', C2W, ' '),
    rpad('Attributes', C31W + C32W + 2, ' ');

  RAISE INFO 
    '%', 
    rpad('|', C1W + C2W + C31W + C32W + REM, '-') || '|';


  ----- ROWS -----
  FOR col IN 
    SELECT 
      meta_table_column.number      AS column_number,
      meta_table_column.name        AS column_name,
      meta_type.name                AS type_name,
      meta_table_column.is_nullable AS is_nullable,
      meta_table.id                 AS table_id
    FROM meta_table
    JOIN meta_namespace ON meta_namespace.id = meta_table.namespace_id
    JOIN meta_table_column ON meta_table.id = meta_table_column.table_id
    JOIN meta_type ON meta_type.id = meta_table_column.type_id
    WHERE meta_namespace.name = main_table_print_pretty.table_schema
      AND meta_table.name = main_table_print_pretty.table_name
      AND meta_table_column.number > 0
  LOOP
    RAISE INFO
      '| % | % | % |',
      rpad(col.column_number::text, C1W, ' '),
      rpad(col.column_name, C2W, ' '),
      (rpad('Type', C31W, ' ') || ': ' || rpad(col.type_name, C32W, ' '));
    RAISE INFO
      '| % | % | % |',
      rpad('', C1W, ' '),
      rpad('', C2W, ' '),
      rpad('Null', C31W, ' ') || ': ' || rpad((
        CASE WHEN col.is_nullable THEN 'NULLABLE' ELSE 'NOT NULL' END 
      ), C32W, ' ');
    
    FOR col_constr IN
      SELECT * 
      FROM meta_comment
      WHERE meta_comment.owner_id = col.table_id
        AND meta_comment.child_id = col.column_number
    LOOP
      IF NOT col_constr IS NULL THEN
        RAISE INFO
          '| % | % | % |',
          rpad('', C1W, ' '),
          rpad('', C2W, ' '),
          rpad('Comment', C31W, ' ') || ': ' || rpad(
            col_constr.content, C32W, ' ');
      END IF;
    END LOOP;
    FOR col_constr IN 
      SELECT
        contraint_name   AS name,
        contraint_clause AS clause
      FROM main_table_column_constraint
      WHERE 
        main_table_column_constraint.schema_name = main_table_print_pretty.table_schema AND
        main_table_column_constraint.table_name = main_table_print_pretty.table_name AND
        main_table_column_constraint.column_name = col.column_name
    LOOP
      IF NOT col_constr.name IS NULL THEN
        RAISE INFO 
          '| % | % | % |',
          rpad('', C1W, ' '),
          rpad('', C2W, ' '),
          (
            rpad('Constr', C31W, ' ') || ': ' || rpad(
              (col_constr.name || ' ' || col_constr.clause), C32W, ' '
            )
          );
      END IF;
    END LOOP;
   END LOOP;

  FOR col IN 
    SELECT
      main_table_constraint.constraint_name    AS constraint_name,
      main_table_constraint.constraint_clause  AS constraint_clause
    FROM main_table_constraint
    WHERE
      main_table_constraint.schema_name = main_table_print_pretty.table_schema AND
      main_table_constraint.table_name = main_table_print_pretty.table_name
  LOOP
    RAISE INFO 
      '| % |',
      (rpad('Constr', C31W, ' ') || ': ' ||
      (col.constraint_name || ' ' || col.constraint_clause))
      ;
  END LOOP;
END;
$$ language plpgsql;

drop procedure IF EXISTS solution;
create or replace procedure solution(
  table_name text
) as $$
declare
  table_schema text;
begin
  select information_schema.tables.table_schema into table_schema
  from information_schema.tables
  where information_schema.tables.table_name = solution.table_name
  limit 1;

  call main_table_print_pretty(table_schema, table_name);
end;
$$ language plpgsql;

call solution('person');
