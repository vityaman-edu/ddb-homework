select oid, datname from pg_database;
select pg_tablespace_databases(
    (select oid from pg_tablespace limit 1)
);
