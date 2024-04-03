DROP VIEW IF EXISTS meta_tablespace CASCADE;
CREATE VIEW meta_tablespace AS 
  SELECT 
    pg_tablespace.oid       AS id,
    pg_tablespace.spcname   AS name
  FROM pg_tablespace;

DROP VIEW IF EXISTS meta_object CASCADE;
CREATE VIEW meta_object AS
  SELECT
    pg_class.oid            AS id,
    pg_class.relname        AS name,
    (
      CASE WHEN pg_class.reltablespace = 0
      THEN (
        SELECT id FROM meta_tablespace 
        WHERE meta_tablespace.name = 'pg_default'
      )
      ELSE pg_class.reltablespace END 
    )                       AS tablespace_id
  FROM pg_class
  WHERE pg_class.relkind IN ('r', 'i', 'S', 'v');

DO $$
DECLARE
  tablespace  record;
  obejct      record;
BEGIN
  FOR tablespace IN 
    SELECT * FROM meta_tablespace
  LOOP
    RAISE INFO 'TABLESPACE %', tablespace.name;
    FOR obejct IN 
      SELECT * FROM meta_object 
      WHERE meta_object.tablespace_id = tablespace.id
    LOOP
      RAISE INFO '  TABLE %', obejct.name;
    END LOOP;
  END LOOP;  
END $$;
