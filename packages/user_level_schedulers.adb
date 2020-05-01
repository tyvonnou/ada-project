with Text_IO;                 use Text_IO;

package body user_level_schedulers is

   protected body user_level_scheduler is

      procedure new_user_level_task_periodic
        (id            : in out Integer;
         period        : in Positive;
         capacity      : in Positive;
         deadline      : in Positive;
         user_priority : in Natural;
         subprogram    : in run_subprogram)
      is
         a_tcb : tcb;  
      begin
         -- Check if the limit of task is reached 
         check_tasks_limit;

         -- Define variables
         number_of_task          := number_of_task + 1;
         a_tcb.the_task          := new user_level_task (number_of_task, subprogram);
         a_tcb.the_type          := task_periodic;
         a_tcb.status            := task_ready;
         a_tcb.start             := -1;
         a_tcb.period            := period;
         a_tcb.capacity          := capacity;
         a_tcb.executed_capacity := capacity;
         a_tcb.deadline          := deadline;
         a_tcb.awake_percent     := -1;
         a_tcb.criticality       := 1;
         a_tcb.dynamic_priority  := deadline - capacity;
         a_tcb.user_priority     := user_priority;
         tcbs (number_of_task)   := a_tcb;
         id                      := number_of_task;

      exception
         when Constraint_Error =>
            Put_line ("Max number of tasks reached ! (" & Integer'Image (max_user_level_task) & " )");
            raise;
         when others =>
            Put_line ("The program have met with a terrible fate !") ;
            raise;
      end new_user_level_task_periodic;

      procedure new_user_level_task_aperiodic
        (id         : in out Integer;
         start      : in Natural;
         capacity   : in Positive;
         deadline   : in Positive;
         subprogram : in run_subprogram)
      is
         a_tcb : tcb;
      begin

         -- Check if the limit of task is reached 
         check_tasks_limit;

         -- Define variables
         number_of_task          := number_of_task + 1;
         a_tcb.the_task          := new user_level_task (number_of_task, subprogram);
         a_tcb.the_type          := task_aperiodic;
         a_tcb.status            := task_pended;
         a_tcb.start             := start;
         a_tcb.period            := -1;
         a_tcb.capacity          := capacity;
         a_tcb.executed_capacity := capacity;
         a_tcb.deadline          := start + deadline;
         a_tcb.awake_percent     := -1;
         a_tcb.criticality       := 1;
         a_tcb.dynamic_priority  := -1;
         a_tcb.user_priority     := 0;
         tcbs (number_of_task)   := a_tcb;
         id                      := number_of_task;
      
      exception
         when Constraint_Error =>
            Put_line ("Max number of tasks reached ! (" & Integer'Image (max_user_level_task) & " )");
            raise;
         when others =>
            Put_line ("The program have met with a terrible fate !") ;
            raise;
      end new_user_level_task_aperiodic;

      procedure new_user_level_task_sporadic
        (id            : in out Integer;
         period        : in Positive;
         capacity      : in Positive;
         awake_percent : in Percent;
         subprogram    : in run_subprogram)
      is
         a_tcb : tcb;
      begin

         -- Check if the limit of task is reached 
         check_tasks_limit;

         -- Define variables
         number_of_task          := number_of_task + 1;
         a_tcb.the_task          := new user_level_task (number_of_task, subprogram);
         a_tcb.the_type          := task_sporadic;
         a_tcb.status            := task_ready;
         a_tcb.start             := 0;
         a_tcb.period            := period;
         a_tcb.capacity          := capacity;
         a_tcb.executed_capacity := capacity;
         a_tcb.deadline          := period;
         a_tcb.awake_percent     := awake_percent;
         a_tcb.criticality       := 1;
         a_tcb.dynamic_priority  := -1;
         a_tcb.user_priority     := 0;
         tcbs (number_of_task)   := a_tcb;
         id                      := number_of_task;
      
      exception
         when Constraint_Error =>
            Put_line ("Max number of tasks reached ! (" & Integer'Image (max_user_level_task) & " )");
            raise;
         when others =>
            Put_line ("The program have met with a terrible fate !") ;
            raise;
      end new_user_level_task_sporadic;

      function get_tcb (id : Integer) return tcb is
      begin
         return tcbs (id);
      end get_tcb;

      procedure set_task_status (id : Integer; s : task_status) is
      begin
         tcbs (id).status := s;
      end set_task_status;

      procedure set_task_start (id : Integer; start : Integer) is
      begin
         tcbs (id).start := start;
      end set_task_start;

      procedure set_task_executed_capacity (id : Integer; executed_capacity : Integer)  is
      begin
         tcbs (id).executed_capacity := executed_capacity;
      end set_task_executed_capacity;

      procedure set_task_deadline (id : Integer; deadline : Integer)  is
      begin
         tcbs (id).deadline := deadline;
      end set_task_deadline;

      procedure set_task_criticality (id : Integer; criticality : Integer)  is
      begin
         tcbs (id).criticality := criticality;
      end set_task_criticality;

      procedure set_task_dynamic_priority (id : Integer; dynamic_priority : Integer)  is
      begin
         tcbs (id).dynamic_priority := dynamic_priority;
      end set_task_dynamic_priority;


      function get_number_of_task return Integer is
      begin
         return number_of_task;
      end get_number_of_task;

      function get_current_time return Integer is
      begin
         return current_time;
      end get_current_time;

      procedure next_time is
      begin
         current_time := current_time + 1;
      end next_time;

      procedure check_tasks_limit is
      begin
         if (number_of_task + 1 > max_user_level_task) then
            raise Constraint_Error;
         end if;
      end check_tasks_limit;

   end user_level_scheduler;

   procedure abort_tasks is
      a_tcb : tcb;
   begin

      -- Check if the simulator has no tasks
      if (user_level_scheduler.get_number_of_task = 0) then
         raise Constraint_Error;
      end if;

      -- Loop on tcbs, and abort each tasks
      for i in 1 .. user_level_scheduler.get_number_of_task loop
         a_tcb := user_level_scheduler.get_tcb (i);
         abort a_tcb.the_task.all;
      end loop;
   end abort_tasks;

end user_level_schedulers;
