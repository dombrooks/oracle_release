create or replace PACKAGE utl_log_plus_pkg
AS
  --
  TYPE r_log_message IS RECORD
  (log_type                 dom_log.log_type%TYPE,
   start_time               dom_log.start_time%TYPE,
   module                   dom_log.module%TYPE,
   action                   dom_log.action%TYPE,
   log_message              dom_log.log_message%TYPE,
   error_message            dom_log.error_message%TYPE);
  --
  PROCEDURE p_start_module (
    i_module                   IN     VARCHAR2,
    i_action                   IN     VARCHAR2, 
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_init                     IN     BOOLEAN DEFAULT FALSE
  );
  --
  PROCEDURE p_stop_module (
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_full_stop                IN     BOOLEAN DEFAULT FALSE
  );
  --
  PROCEDURE p_set_message (
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_error                    IN     BOOLEAN  DEFAULT FALSE
  );
  --
  PROCEDURE p_start_action (
    i_action                   IN     VARCHAR2,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  );
  --
  PROCEDURE p_stop_and_start_action (
    i_next_action              IN     VARCHAR2,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  );
  --
  PROCEDURE p_stop_action (
    i_action                   IN     VARCHAR2 DEFAULT NULL,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  );
  --
  PROCEDURE p_log_and_stop (
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_error                    IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_full_stop                IN     BOOLEAN DEFAULT FALSE
  );
  --
  PROCEDURE p_set_client_info (
    i_client_info              IN     VARCHAR2,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  );
  --
END utl_log_plus_pkg;
/
