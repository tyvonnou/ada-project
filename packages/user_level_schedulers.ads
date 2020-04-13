with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with user_level_tasks;      use user_level_tasks;

package user_level_schedulers is

   max_user_level_task : constant Integer := 100;

   type task_status is (task_ready, task_pended);

   type tcb is record
      -- La tâche 
      the_task : user_level_task_ptr;
      -- La période d'exécution
      period   : Integer;
      -- Le nombre d'unités à exécuter pendant la période 
      capacity : Integer;
      -- La "date" avant laquelle executer
      -- "0" si non nécéssaire
      deadline : Integer;
      -- Le status de la tache 
      status   : task_status;
   end record;

   type tcb_type is array (1 .. max_user_level_task) of tcb;

   protected user_level_scheduler is
      procedure set_task_status (id : Integer; s : task_status);
      procedure set_tcb_deadline (id : Integer; deadline : Integer);
      function get_tcb (id : Integer) return tcb;
      procedure new_user_level_task
        (id         : in out Integer;
         period     : in Integer;
         capacity   : in Integer;
         deadline   : in Integer;
         subprogram : in run_subprogram);
      function get_number_of_task return Integer;
      function get_current_time return Integer;
      procedure next_time;
   private
      tcbs           : tcb_type;
      number_of_task : Integer := 0;
      current_time   : Integer := 0;
   end user_level_scheduler;

   -- Main user level scheduler entry points
   --
   procedure rate_monotonic_schedule (duration_in_time_unit : Integer);
   procedure edf_schedule (duration_in_time_unit : Integer);
   procedure abort_tasks;

end user_level_schedulers;
