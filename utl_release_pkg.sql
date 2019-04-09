CREATE OR REPLACE PACKAGE BODY utl_release_pkg 
AS
  PROCEDURE p_log (
     i_log_message             IN     VARCHAR2
  )
  AS
  BEGIN
     --
     DBMS_OUTPUT.PUT_LINE(i_log_message);
     --
  END p_log;  
  --
  PROCEDURE p_execute (
    i_command_to_execute       IN     CLOB
  )
  AS
  BEGIN
     --
     p_log('Command to execute:'|| DBMS_LOB.SUBSTR(i_command_to_execute,200,1));
     --
     EXECUTE IMMEDIATE i_command_to_execute;
     --
  EXCEPTION
       WHEN others THEN
            p_log('Error executing:');
            p_log(i_command_to_execute);
            RAISE;
  END p_execute;  
  --
  PROCEDURE p_execute_if (
    i_command_to_execute       IN     CLOB,
    i_evaluate_condition       IN     BOOLEAN
  )
  AS
  BEGIN
     --
     p_log('Command to execute:'|| DBMS_LOB.SUBSTR(i_command_to_execute,200,1));
     p_log('Evaluation: '||CASE WHEN i_evaluate_condition THEN 'true' WHEN NOT i_evaluate_condition THEN 'false' END);
     IF i_evaluate_condition
     THEN
         --
         EXECUTE IMMEDIATE i_command_to_execute;
         --
     END IF;
     --
  EXCEPTION
       WHEN others THEN
            p_log('Error executing:');
            p_log(i_command_to_execute);
            RAISE;
  END p_execute_if;  
  --
  FUNCTION f_column_exists (
    i_table_name               IN     VARCHAR2,
    i_column_name              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_tab_columns
        WHERE  table_name  = UPPER(i_table_name)
        AND    column_name = UPPER(i_column_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_column_exists;
  --
  FUNCTION f_table_exists (
    i_table_name               IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_tables
        WHERE  table_name  = UPPER(i_table_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_table_exists;
  --
  FUNCTION f_table_segment_exists (
    i_table_name               IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_segments
        WHERE  segment_name  = UPPER(i_table_name)
        AND    ROWNUM        = 1;
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_table_segment_exists;
  --
  FUNCTION f_table_partitioned (
    i_table_name               IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_part_tables
        WHERE  table_name  = UPPER(i_table_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_table_partitioned;
  --
  FUNCTION f_type_exists (
    i_type_name               IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_types
        WHERE  type_name  = UPPER(i_type_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_type_exists;
  --
  FUNCTION f_function_exists (
    i_function_name               IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_procedures
        WHERE  object_name  = UPPER(i_function_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_function_exists;
  --
  FUNCTION f_index_exists (
    i_index_name               IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_indexes
        WHERE index_name  = UPPER(i_index_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_index_exists;
  --
  FUNCTION f_object_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_objects
        WHERE  object_name  = UPPER(i_object_name)
        AND    ROWNUM <= 1;
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_object_exists;
  --
  FUNCTION f_object_exists (
    i_object_name              IN     VARCHAR2,
    i_object_type              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_objects
        WHERE  object_name  = UPPER(i_object_name)
        AND    object_type  = UPPER(i_object_type)
        AND    ROWNUM <= 1;
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_object_exists;
  --
  FUNCTION f_view_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
  BEGIN
     --
     RETURN f_object_exists(i_object_name, 'VIEW');
     --
  END f_view_exists;
  --
  FUNCTION f_package_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
  BEGIN
     --
     RETURN f_object_exists(i_object_name, 'PACKAGE');
     --
  END f_package_exists;
  --
  FUNCTION f_constraint_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_exists BOOLEAN := FALSE;
    l_dummy  PLS_INTEGER;
    --
  BEGIN
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_constraints
        WHERE  constraint_name  = UPPER(i_object_name);
        --
        l_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_exists := FALSE;
     END;
     --
     RETURN l_exists;
     --
  END f_constraint_exists;
  --
  FUNCTION f_column_nullable (
    i_table_name               IN     VARCHAR2,
    i_column_name              IN     VARCHAR2
  ) RETURN BOOLEAN
  AS
    --
    l_nullable           VARCHAR2(1);
    l_dummy              PLS_INTEGER;
    l_constraint_exists  BOOLEAN := FALSE;
    --
  BEGIN
     --
     SELECT nullable
     INTO   l_nullable
     FROM   user_tab_columns 
     WHERE  table_name   = UPPER(i_table_name)
     AND    column_name  = UPPER(i_column_name);
     --
     BEGIN
        --
        SELECT 1
        INTO   l_dummy
        FROM   user_constraints uc
        JOIN   user_cons_columns ucc 
        ON    (ucc.constraint_name = uc.constraint_name)
        WHERE uc.table_name        = UPPER(i_table_name) 
        AND   uc.constraint_type   = 'C'
        AND   ucc.column_name      = UPPER(i_column_name);
        --
        l_constraint_exists := TRUE;
        --
     EXCEPTION
          WHEN no_data_found THEN
               l_constraint_exists := FALSE;
     END;
     --
     RETURN ((l_nullable = 'Y') AND NOT l_constraint_exists);
     --
  END f_column_nullable;
  --
  FUNCTION f_get_oracle_version
  RETURN NUMBER
  AS
  BEGIN
     --
     RETURN dbms_db_version.version;
     --
  END;
  --
  FUNCTION f_get_oracle_release
  RETURN NUMBER
  AS
  BEGIN
     --
     RETURN dbms_db_version.release;
     --
  END;
  --
  FUNCTION f_get_override_tablespace (
    i_context                  IN     VARCHAR2
  )
  RETURN VARCHAR2
  AS
    --
    l_tablespace VARCHAR2(30);
    --
  BEGIN
     --
     BEGIN
        SELECT text_value
        INTO   l_tablespace
        FROM   my_parameters
        WHERE  name              = 'OVERRIDE_TABLESPACE_'||i_context;
        --        
     EXCEPTION
          WHEN no_data_found THEN
               NULL;
     END;
     --
     RETURN l_tablespace;
     --
  END f_get_override_tablespace;
  --
  FUNCTION f_get_tablespace (
    i_context                  IN     VARCHAR2
  )
  RETURN VARCHAR2
  AS
  BEGIN
     --
     RETURN COALESCE(f_get_override_tablespace(i_context), USER||'_'||i_context);
     --
  END f_get_tablespace;
  --
  FUNCTION f_get_data_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'DAT';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END f_get_data_tablespace;
  --
  FUNCTION f_get_idx_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'IDX';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END f_get_idx_tablespace;
  --
  FUNCTION f_get_fact_data_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'FACT_DAT';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END;
  --
  FUNCTION f_get_fact_idx_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'FACT_IDX';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END;
  --
  FUNCTION f_get_stg_data_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'STG_DAT';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END;
  --
  FUNCTION f_get_stg_idx_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'STG_IDX';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END;
  --
  FUNCTION f_get_hist_data_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'HIST_DAT';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END;
  --
  FUNCTION f_get_hist_idx_tablespace
  RETURN VARCHAR2
  AS
    --
    l_context VARCHAR2(20) := 'HIST_IDX';
    --
  BEGIN
     --
     RETURN f_get_tablespace(l_context);
     --
  END;
  --
  PROCEDURE p_validate_state (
    i_evaluate_condition       IN     BOOLEAN,
    i_expected_condition       IN     VARCHAR2
  )
  AS
  BEGIN
     --
     IF NOT i_evaluate_condition 
     THEN
         --
         RAISE_APPLICATION_ERROR(-20000,'Expected release condition not met: '||i_expected_condition);
         --
     END IF;
     --
  END p_validate_state;
  --
END utl_release_pkg;
/
