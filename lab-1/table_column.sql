drop function IF EXISTS table_column;
create function table_column(
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
    pg_constraint.conname as constraint_name,
    coalesce(information_schema.check_constraints.check_clause, '') as check_clause
  from information_schema.columns     
  left join information_schema.constraint_column_usage on (
    constraint_column_usage.table_schema = table_column.table_schema and 
    constraint_column_usage.table_name = table_column.table_name and 
    constraint_column_usage.column_name = information_schema.columns.column_name
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
      )
    ) and
    pg_attribute.attname = information_schema.columns.column_name
  )
  left join pg_description on (
    pg_description.objoid = pg_attribute.attrelid and 
    pg_description.objsubid = pg_attribute.attnum
  )
  left join pg_constraint on (
    array_position(pg_constraint.conkey, pg_attribute.attnum) is not null
  )
  left join information_schema.check_constraints on (
    check_constraints.constraint_schema = constraint_column_usage.constraint_schema and
    check_constraints.constraint_name = constraint_column_usage.constraint_name
  )
  where (
    information_schema.columns.table_schema = table_column.table_schema and
    information_schema.columns.table_name = table_column.table_name
  );
$$ language sql;
