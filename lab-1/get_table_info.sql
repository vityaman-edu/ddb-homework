create or replace function table_column(
  table_schema text,
  table_name text
) returns table (
  number integer,
  name text, 
  type text,
  is_nullable boolean,
  comment text,
  constraint_name text,
  check_clause text
) as $$
  select
    attnum as number,
    information_schema.columns.column_name as name,
    (
      data_type || (
        case 
          when character_maximum_length is not null then
            ' (' || cast(character_maximum_length as text) || ')'
          else 
            ''
        end 
      ) || (
        (
          case 
            when (
              numeric_precision is not null or 
              numeric_scale is not null
            ) then 
              ' ('
            else
              ''
          end
        ) || (
          case 
            when numeric_precision is not null then
              cast(numeric_precision as text)
            else
              ''
          end
        ) || (
          case 
            when numeric_scale is not null then
              ', ' || cast(numeric_scale as text)
            else
              ''
          end
        ) || (
          case 
            when (
              numeric_precision is not null or 
              numeric_scale is not null
            ) then 
              ')'
            else
              ''
          end
        )
      )
    ) as type,
    (
      information_schema.columns.is_nullable = 'YES'
    ) as is_nullable,
    pg_description.description as comment,
    information_schema.check_constraints.constraint_name as constraint_name,
    information_schema.check_constraints.check_clause as check_clause
  from information_schema.columns     
  left join information_schema.constraint_column_usage on (
    constraint_column_usage.table_schema = table_column.table_schema and 
    constraint_column_usage.table_name = table_column.table_name and 
    constraint_column_usage.column_name = information_schema.columns.column_name
  )
  left join information_schema.check_constraints on (
    check_constraints.constraint_schema = constraint_column_usage.constraint_schema and
    check_constraints.constraint_name = constraint_column_usage.constraint_name
  )
  left join pg_attribute on (
    pg_attribute.attrelid = (
      SELECT oid 
      FROM pg_class
      WHERE (
        pg_class.relname = table_column.table_name and
        pg_class.relnamespace = (
          select oid 
          from pg_namespace 
          where pg_namespace.nspname = table_column.table_schema
        )
      ) as q
    ) and
    pg_attribute.attname = information_schema.columns.column_name
  )
  left join pg_description on (
    pg_description.objoid = pg_attribute.attrelid and 
    pg_description.objsubid = pg_attribute.attnum
  )
  where (
    information_schema.columns.table_schema = table_column.table_schema and
    information_schema.columns.table_name = table_column.table_name
  );
$$ language sql;

create or replace function table_column_pretty(
  table_schema text,
  table_name text
) returns table (
  number integer,
  name text, 
  attributes text
) as $$
  select 
    number, 
    name,
    type || (
      case 
        when constr is not null then
          e'\n' || constr
        else 
          ''
      end
    ) || (
      case 
        when comment is not null then
          e'\n' || comment
        else 
          ''
      end
    ) as attributes
  from (
    select
      number,
      name,
      'Type: ' || cast(type as text) || ' ' || (
        case 
          when not is_nullable then 
            'NOT NULL'
          else 
            ''
        end
      ) as type,
      string_agg(
        ('Constr: ' || constraint_name || ' ' || check_clause), e'\n'
      ) as constr,
      ('Comment: ' || comment) as comment
    from table_column(table_schema, table_name)
    group by number, name, type, comment, is_nullable
  ) as q
  order by number;
$$ language sql;

create or replace function print_table_info(
  table_schema text,
  table_name text
) returns void as $$
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

select print_table_info('public', 'person');
