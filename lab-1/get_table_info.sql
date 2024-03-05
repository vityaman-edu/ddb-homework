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

  call print_table_info(table_schema, table_name);
end;
$$ language plpgsql;

call solution('person');
