drop function IF EXISTS table_column_pretty;
create function table_column_pretty(
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
        ('Constr: ' || constraint_name || ' '), e'\n'
      ) as constr,
      ('Comment: ' || comment) as comment
    from table_column(table_schema, table_name)
    group by number, name, type, comment, is_nullable
  ) as qqq
  order by number;
$$ language sql;