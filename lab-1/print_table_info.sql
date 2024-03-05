drop procedure IF EXISTS print_table_info;
create or replace procedure print_table_info(
  table_schema text,
  table_name text
) as $$
declare
  col record;
  col_contr record;

  C1W integer;
  C2W integer;
  C31W integer;
  C32W integer;
  REM integer;
begin
  C1W := 2;
  C2W := 12;
  C31W := 8;
  C32W := 64 + 8;
  REM := 11;

  if not exists (
    select *
    from table_column(table_schema, table_name) 
    limit 1
  ) then 
    raise exception '%', ('Table "' || table_schema || '.' || table_name || '" was not found!');
  end if;

  raise info 
    '%', 
    rpad(
      '|--- Table "' || table_schema || '.' || table_name || '" Information ', 
      C1W + C2W + C31W + C32W + REM, 
      '-'
    ) || '|';
  raise info 
    '| % | % | % |',
    rpad('N', C1W, ' '),
    rpad('Name', C2W, ' '),
    rpad('Attributes', C31W + C32W + 2, ' ');
  raise info '%', rpad('|', C1W + C2W + C31W + C32W + REM, '-') || '|';
  for col in 
    select distinct number, name, type, comment
    from table_column(table_schema, table_name) 
    order by number
  loop
    raise info 
      '| % | % | % |',
      rpad(cast(col.number as text), C1W, ' '),
      rpad(col.name, C2W, ' '),
      (rpad('Type', C31W, ' ') || ': ' || rpad(col.type, C32W, ' '));
    for col_contr in 
      select 
        constraint_name as name, 
        check_clause as clause
      from table_column(table_schema, table_name) 
      where (
        table_column.number = col.number and 
        constraint_name is not null
      )
    loop
      raise info 
        '| % | % | % |',
        rpad('', C1W, ' '),
        rpad('', C2W, ' '),
        (
          rpad('Constr', C31W, ' ') || ': ' || rpad(
            (col_contr.name || ' ' || col_contr.clause), C32W, ' '
          )
        );
    end loop;
    if col.comment is not null then
      raise info 
        '| % | % | % |',
        rpad('', C1W, ' '),
        rpad('', C2W, ' '),
        (rpad('Comment', C31W, ' ') || ': ' || rpad(col.comment, C32W, ' '));
    end if;
    raise info '%', rpad('|', C1W + C2W + C31W + C32W + REM, '-') || '|';
  end loop;
end;
$$ language plpgsql;