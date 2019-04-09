create or replace PACKAGE BODY utl_log_plus_pkg
AS
  --
  TYPE t_action IS TABLE OF VARCHAR2(255);
  TYPE r_module_action IS RECORD
  (module VARCHAR2(255)
  ,action t_action);
  --
  TYPE t_module_action IS TABLE OF r_module_action;
  --
  --g_action        t_action;
  g_module         t_module_action := t_module_action();
  g_execution_id   utl_log.execution_id%TYPE;
  --
  PROCEDURE init (
    i_init                     IN     BOOLEAN DEFAULT TRUE
  )
  AS
  BEGIN
     --
     IF i_init
     THEN
         --
         g_module := t_module_action();
         g_execution_id := SYS_GUID;
         --
     END IF;
     --
  END init;
  --
  PROCEDURE flush
  AS
  BEGIN
     --
     g_module := t_module_action();
     g_execution_id := NULL;
     --
  END flush;
  --
  PROCEDURE insert_log (
    i_log_type                 IN     VARCHAR2,
    i_start_time               IN     TIMESTAMP,
    i_execution_id             IN     VARCHAR2,
    i_action                   IN     VARCHAR2,
    i_module                   IN     VARCHAR2,
    i_log_message              IN     VARCHAR2,
    i_error_message            IN     VARCHAR2
  )
  AS
  BEGIN
     --
     NULL;
     --
  END insert_log;
  --
  PROCEDURE p_add_module (
    i_module                   IN     VARCHAR2
  )
  AS
    --
    l_module_action r_module_action;
    --
  BEGIN
     --
     IF g_module.COUNT() < 100
     THEN
         --
         g_module.EXTEND();
         --
     END IF;
     --
     l_module_action.module := i_module;
     l_module_action.action := t_action();
     g_module(g_module.LAST) := l_module_action;
     --
  END p_add_module;
  --
  FUNCTION f_pop_module 
  RETURN VARCHAR2
  AS
    --
    l_module VARCHAR2(255);
    --
  BEGIN
     --
     BEGIN
        --
        IF g_module.COUNT > 0
        THEN
            --
            g_module.DELETE(g_module.LAST);
            --
            l_module := g_module(g_module.LAST).module;
            --
        END IF;
        --
     EXCEPTION 
          WHEN others THEN
              NULL;
     END;
     --
     RETURN l_module;
     --
  END f_pop_module;
  --
  FUNCTION f_get_top_module
  RETURN VARCHAR2
  AS
    --
    l_module VARCHAR2(255);
  BEGIN
     --
     BEGIN
        --
        l_module := g_module(g_module.LAST).module;
        --
     EXCEPTION
          WHEN others THEN
               NULL;
     END;
     --
     RETURN l_module;
     --
  END f_get_top_module;
  --
  FUNCTION f_get_top_action
  RETURN VARCHAR2
  AS
    --
    l_action VARCHAR2(255);
    --
  BEGIN
     --
     BEGIN
        --

        l_action := g_module(g_module.LAST).action(g_module(g_module.LAST).action.LAST);
        --
     EXCEPTION
          WHEN others THEN
               NULL;
     END;
     --
     RETURN l_action;
     --
  END f_get_top_action;
  --
  PROCEDURE p_add_action (
    i_action                   IN     VARCHAR2
  )
  AS
  BEGIN
     --
     IF g_module(g_module.LAST).action.COUNT() < 100
     THEN
         --
         g_module(g_module.LAST).action.EXTEND();
         --
     END IF;
     g_module(g_module.LAST).action(g_module(g_module.LAST).action.LAST) := i_action;
     --
  END p_add_action;
  --
  FUNCTION f_pop_action 
  RETURN VARCHAR2
  AS
    --
    l_action VARCHAR2(255);
    --
  BEGIN
     --
     BEGIN
        --
        IF g_module(g_module.LAST).action.COUNT > 0
        THEN
            --
            g_module(g_module.LAST).action.DELETE(g_module(g_module.LAST).action.LAST);
            --
            l_action := g_module(g_module.LAST).action(g_module(g_module.LAST).action.LAST);
            --
        END IF;
        --
     EXCEPTION 
          WHEN others THEN
              NULL;
     END;
     --
     RETURN l_action;
     --
  END f_pop_action;
  --
  PROCEDURE p_log (
    i_log                      IN     BOOLEAN,
    i_log_entry                IN     r_log_message,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  )
  AS
  BEGIN 
     --
     IF i_log --AND g_execution_id IS NOT NULL AND g_business_date IS NOT NULL
     THEN
         --
         insert_log
         (i_log_type       => i_log_entry.log_type,
          i_start_time     => i_log_entry.start_time,
          i_execution_id   => COALESCE(g_execution_id,SYS_GUID),
          i_action         => COALESCE(i_log_entry.action,'STANDALONE_MESSAGE'),
          i_module         => i_log_entry.action,
          i_log_message    => i_log_entry.log_message,
          i_error_message  => i_log_entry.error_message);
         --
     END IF;
     --
     IF i_dbms_output
     THEN
         --
         DBMS_OUTPUT.ENABLE;
         DBMS_OUTPUT.PUT_LINE(i_log_entry.module||'::'||i_log_entry.action||'::'||i_log_entry.log_message);
         --
     END IF;
     --
  END p_log;
  --  
  PROCEDURE p_start_module (
    i_module                   IN     VARCHAR2,
    i_action                   IN     VARCHAR2, 
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_init                     IN     BOOLEAN DEFAULT FALSE
  )
  AS
    --
    l_log_entry r_log_message;
    --
  BEGIN 
     --
     init(((i_init) OR (g_execution_id IS NULL)));
     --
     p_add_module(i_module);
     --
     dbms_application_info.set_module
     (module_name => i_module,
      action_name => i_action);
     --
     l_log_entry.log_type         := 'INFO';
     l_log_entry.start_time       := SYSTIMESTAMP;
     l_log_entry.module           := i_module;
     l_log_entry.action           := NULL;
     l_log_entry.log_message      := 'STARTED';
     --     
     p_log(i_log, l_log_entry, i_dbms_output);
     --
     p_start_action
     (i_action       => i_action,
      i_log          => i_log,
      i_dbms_output  => i_dbms_output);
     --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END p_start_module; 
  --
  PROCEDURE p_stop_module (
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_full_stop                IN     BOOLEAN DEFAULT FALSE
  )
  AS
    --
    l_module    VARCHAR2(255);
    l_action    VARCHAR2(255);
    l_log_entry r_log_message;
    --
  BEGIN 
     --
     l_action := f_get_top_action();
     l_module := f_get_top_module();
     --
     IF l_action IS NOT NULL
     THEN
          --
          l_log_entry.log_type         := 'INFO';
          l_log_entry.start_time       := SYSTIMESTAMP;
          l_log_entry.module           := l_module;
          l_log_entry.action           := l_action;
          l_log_entry.log_message      := 'ACTION COMPLETED';
          --
          p_log(i_log, l_log_entry, i_dbms_output);
          --
     END IF;
     --
     l_log_entry.log_type         := 'INFO';
     l_log_entry.start_time       := SYSTIMESTAMP;
     l_log_entry.module           := l_module;
     l_log_entry.action           := NULL;
     l_log_entry.log_message      := 'COMPLETED';
     p_log(i_log, l_log_entry, i_dbms_output);
     --
     IF i_full_stop
     THEN
         --
         flush();
         --
     ELSE
         --
         l_module := f_pop_module();
         l_action := f_get_top_action();
         --
     END IF;
     --
     dbms_application_info.set_module
     (module_name => l_module,
      action_name => l_action);
     --
     --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END p_stop_module;
  --
  PROCEDURE p_set_message (
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_error                    IN     BOOLEAN  DEFAULT FALSE
  )
  AS
    l_module    VARCHAR2(255);
    l_action    VARCHAR2(255);
    l_log_entry r_log_message;
    --
  BEGIN 
     --
     l_action := f_get_top_action();
     l_module := f_get_top_module();
     --
     l_log_entry.log_type         := CASE WHEN i_error THEN 'ERROR' ELSE 'INFO' END;
     l_log_entry.start_time       := SYSTIMESTAMP;
     l_log_entry.module           := l_module;
     l_log_entry.action           := l_action;
     l_log_entry.log_message      := i_message;
     l_log_entry.error_message    := CASE WHEN i_error THEN i_message END;
     --
     p_log(i_log, l_log_entry, i_dbms_output);
     --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END p_set_message;
  --
  PROCEDURE p_start_action (
    i_action                   IN     VARCHAR2,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  )
  AS
    --
    l_module    VARCHAR2(255);
    l_log_entry r_log_message;
    --
  BEGIN 
     --
     l_module := f_get_top_module();
     --
     dbms_application_info.set_action
     (action_name => i_action);
     --
     p_add_action(i_action);
     --
     l_log_entry.log_type         := 'INFO';
     l_log_entry.start_time       := SYSTIMESTAMP;
     l_log_entry.module           := l_module;
     l_log_entry.action           := i_action;
     l_log_entry.log_message      := 'ACTION STARTED';
     --
     p_log(i_log, l_log_entry, i_dbms_output);
     --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END p_start_action;
  --
  PROCEDURE p_stop_action (
    i_action                   IN     VARCHAR2 DEFAULT NULL,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  )
  AS
    --
    l_module    VARCHAR2(255);
    l_action    VARCHAR2(255);
    l_log_entry r_log_message;
    --
  BEGIN
     --
     l_action := f_get_top_action();
     l_module := f_get_top_module();
     --
     l_log_entry.log_type         := 'INFO';
     l_log_entry.start_time       := SYSTIMESTAMP;
     l_log_entry.module           := l_module;
     l_log_entry.action           := COALESCE(i_action,l_action);
     l_log_entry.log_message      := 'ACTION COMPLETED';
     --
     p_log(i_log, l_log_entry, i_dbms_output);
     --
     l_action := f_pop_action();
     DBMS_OUTPUT.PUT_LINE('Last action '||l_action);
     --
     dbms_application_info.set_action
     (action_name => l_action);
     --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END p_stop_action;
  --
  PROCEDURE p_stop_and_start_action (
    i_next_action              IN     VARCHAR2,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  )
  AS
  BEGIN
     --
     p_stop_action
     (i_log           => i_log,
      i_dbms_output   => i_dbms_output,
      i_message       => i_message);
     --
     p_start_action
     (i_action        => i_next_action,
      i_log           => i_log,
      i_dbms_output   => i_dbms_output,
      i_message       => i_message);
     --
  END p_stop_and_start_action;
  --
  PROCEDURE p_log_and_stop (
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_message                  IN     VARCHAR2 DEFAULT NULL,
    i_error                    IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE,
    i_full_stop                IN     BOOLEAN DEFAULT FALSE
  )
  AS
  BEGIN
      --
      p_set_message
      (i_message       => i_message, 
       i_error         => i_error,
       i_log           => i_log,
       i_dbms_output   => i_dbms_output);
      p_stop_module
      (i_log           => FALSE,
       i_full_stop     => i_full_stop);
      --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END;
  --
  PROCEDURE p_set_client_info (
    i_client_info              IN     VARCHAR2,
    i_log                      IN     BOOLEAN DEFAULT FALSE,
    i_dbms_output              IN     BOOLEAN DEFAULT FALSE
  )
  AS
    l_module    VARCHAR2(255);
    l_action    VARCHAR2(255);
    l_log_entry r_log_message;
    --
  BEGIN 
     --
     l_action := f_get_top_action();
     l_module := f_get_top_module();
     --
     l_log_entry.log_type         := 'INFO';
     l_log_entry.start_time       := SYSTIMESTAMP;
     l_log_entry.module           := l_module;
     l_log_entry.action           := l_action;
     l_log_entry.log_message      := i_client_info;
     --
     p_log(i_log, l_log_entry, i_dbms_output);
     --
     dbms_application_info.set_client_info
     (client_info => i_client_info);
     --
  EXCEPTION
       WHEN others THEN NULL;
       --
  END p_set_client_info;
  --
END utl_log_plus_pkg;
/
