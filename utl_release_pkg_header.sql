CREATE OR REPLACE PACKAGE utl_release_pkg AUTHID CURRENT_USER
AS
  --
  PROCEDURE p_execute (
    i_command_to_execute       IN     CLOB
  );
  --
  PROCEDURE p_execute_if (
    i_command_to_execute       IN     CLOB,
    i_evaluate_condition       IN     BOOLEAN
  );
  --
  FUNCTION f_column_exists (
    i_table_name               IN     VARCHAR2,
    i_column_name              IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_table_exists (
    i_table_name               IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_table_segment_exists (
    i_table_name               IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_table_partitioned (
    i_table_name               IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_type_exists (
    i_type_name                IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_function_exists (
    i_function_name            IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_index_exists (
    i_index_name               IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_object_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_column_nullable (
    i_table_name               IN     VARCHAR2,
    i_column_name              IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_view_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_package_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_constraint_exists (
    i_object_name              IN     VARCHAR2
  ) RETURN BOOLEAN;
  --
  FUNCTION f_get_oracle_version
  RETURN NUMBER;
  --
  FUNCTION f_get_oracle_release
  RETURN NUMBER;
  --
  FUNCTION f_get_data_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_idx_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_fact_data_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_fact_idx_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_stg_data_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_stg_idx_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_hist_idx_tablespace
  RETURN VARCHAR2;
  --
  FUNCTION f_get_hist_data_tablespace
  RETURN VARCHAR2;
  --
  PROCEDURE p_validate_state (
    i_evaluate_condition       IN     BOOLEAN,
    i_expected_condition       IN     VARCHAR2
  );
  --
END utl_release_pkg;
/
