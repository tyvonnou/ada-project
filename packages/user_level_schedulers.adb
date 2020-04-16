with Text_IO; use Text_IO;

package body user_level_schedulers is

   protected body user_level_scheduler is

      procedure new_user_level_task_periodic
        (id         : in out Integer;
         period     : in Integer;
         capacity   : in Integer;
         deadline   : in Integer;
         subprogram : in run_subprogram)
      is
         a_tcb : tcb;
         CAPACITY_NULL_ERROR : exception;
         PERIOD_NULL_ERROR   : exception;     
      begin

         -- Check if the limit of task is reached 
         if (number_of_task + 1 > max_user_level_task) then
            raise Constraint_Error;
         end if;

         -- Check is the capacity is 0
         if (capacity = 0) then
            raise CAPACITY_NULL_ERROR with "Capacity incorrect !";
         end if;

         -- Check is the period is 0
         if (period = 0) then
            raise PERIOD_NULL_ERROR with "Capacity incorrect !";
         end if;

         number_of_task := number_of_task + 1;
         a_tcb.the_task := new user_level_task (number_of_task, subprogram);
         a_tcb.the_type := task_periodic;
         a_tcb.status   := task_ready;
         a_tcb.start    := -1;
         a_tcb.period   := period;
         a_tcb.capacity := capacity;
         a_tcb.deadline := deadline;
         a_tcb.minimum_delay := -1;
         tcbs (number_of_task) := a_tcb;
         id := number_of_task;

      exception
         when CAPACITY_NULL_ERROR => put_line("The capacity can not be equal to 0 !") ; 
         when PERIOD_NULL_ERROR => put_line("The period can not be equal to 0 !") ; 
         when others    => put_line("The program have met with a terrible fate !") ; 
      end new_user_level_task_periodic;

      procedure new_user_level_task_aperiodic
        (id         : in out Integer;
         start      : in Integer;
         capacity   : in Integer;
         deadline   : in Integer;
         subprogram : in run_subprogram)
      is
         a_tcb : tcb;
         CAPACITY_NULL_ERROR  : exception;
         START_NEGATIVE_ERROR : exception;
      begin

         -- Check if the limit of task is reached 
         if (number_of_task + 1 > max_user_level_task) then
            raise Constraint_Error;
         end if;

         -- Check is the capacity is 0
         if (capacity = 0) then
            raise CAPACITY_NULL_ERROR with "Capacity incorrect !";
         end if;

         -- Check is the start is negative
         if (start < 0) then
            raise START_NEGATIVE_ERROR with "Start incorrect !";
         end if;

         number_of_task := number_of_task + 1;
         a_tcb.the_task := new user_level_task (number_of_task, subprogram);
         a_tcb.the_type := task_aperiodic;
         a_tcb.status   := task_pended;
         a_tcb.start    := start;
         a_tcb.period   := -1;
         a_tcb.capacity := capacity;
         a_tcb.deadline := deadline;
         a_tcb.minimum_delay := -1;
         tcbs (number_of_task) := a_tcb;
         id := number_of_task;
      
      exception
         when CAPACITY_NULL_ERROR => put_line("The capacity can not be equal to 0 !") ;
         when START_NEGATIVE_ERROR => put_line("The start can not be negative !") ; 
         when others    => put_line("The program have met with a terrible fate !") ; 
      end new_user_level_task_aperiodic;

      procedure new_user_level_task_sporadic
        (id            : in out Integer;
         minimum_delay : in Integer;
         capacity      : in Integer;
         subprogram    : in run_subprogram)
      is
         CAPACITY_NULL_ERROR : exception;
         a_tcb : tcb;
      begin

         -- Check if the limit of task is reached 
         if (number_of_task + 1 > max_user_level_task) then
            raise Constraint_Error;
         end if;

         -- Check is the capacity is 0
         if (capacity = 0) then
            raise CAPACITY_NULL_ERROR with "Capacity incorrect !";
         end if;

         number_of_task := number_of_task + 1;
         a_tcb.the_task := new user_level_task (number_of_task, subprogram);
         a_tcb.the_type := task_sporadic;
         a_tcb.status   := task_ready;
         a_tcb.start    := 0;
         a_tcb.period   := -1;
         a_tcb.capacity := capacity;
         a_tcb.deadline := Integer'Last;
         a_tcb.minimum_delay := minimum_delay;
         tcbs (number_of_task) := a_tcb;
         id := number_of_task;
      
      exception
         when CAPACITY_NULL_ERROR => put_line("The capacity can not be equal to 0 !") ; 
         when others    => put_line("The program have met with a terrible fate !") ; 
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

      procedure set_task_deadline (id : Integer; deadline : Integer)  is
      begin
         tcbs (id).deadline := deadline;
      end set_task_deadline;


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

   end user_level_scheduler;

   
   procedure rate_monotonic_schedule (duration_in_time_unit : Integer) is
      a_tcb           : tcb;
      no_ready_task   : Boolean;
      elected_task    : tcb;
      smallest_period : Integer;
   begin

      -- Loop on tcbs, and select tasks which are ready and which have smallest periods
      --
      loop

        -- Find the next task to run
         no_ready_task   := True;
         smallest_period := Integer'Last;
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);
            if (a_tcb.status = task_ready) then
               no_ready_task := False;
               if a_tcb.period < smallest_period then
                  smallest_period := a_tcb.period;
                  elected_task    := a_tcb;
               end if;
            end if;
         end loop;

         -- Run the task if at least one has been elected
         if not no_ready_task then
            elected_task.the_task.wait_for_processor;
            elected_task.the_task.release_processor;
         else
            Put_Line ("No task to run at time " &
               Integer'Image (user_level_scheduler.get_current_time));
         end if;

         -- Go to the next unit of time
         user_level_scheduler.next_time;
         exit when user_level_scheduler.get_current_time > duration_in_time_unit;

         -- Check the scheduling and release tasks
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);

            -- Check for misses deadlines
            if user_level_scheduler.get_current_time = a_tcb.deadline
               and a_tcb.status = task_ready
            then
               Put_Line ("Task" & Integer'Image (i) & " misses its deadline at time " &
                  Integer'Image (user_level_scheduler.get_current_time));
               New_Line;
               Put_Line ("The simulation is not schedulable");
               return;
            end if;

            -- Release tasks
            if user_level_scheduler.get_current_time mod a_tcb.period = 0 then
               Put_Line ("Task" & Integer'Image (i) & " is released at time "
                  & Integer'Image (user_level_scheduler.get_current_time));
               user_level_scheduler.set_task_status (i, task_ready);
               user_level_scheduler.set_task_deadline (i, user_level_scheduler.get_current_time + a_tcb.deadline);
            end if;

         end loop;

      end loop;
      New_Line;
      Put_Line ("The simulation is schedulable");
   end rate_monotonic_schedule;

   procedure earliest_deadline_first_schedule (duration_in_time_unit : Integer) is
      a_tcb             : tcb;
      no_ready_task     : Boolean;
      elected_task      : tcb;
      smallest_deadline : Integer;
   begin

      -- Loop on tcbs, and select tasks which are ready and which have smallest deadlines
      --
      loop

         -- Find the next task to run
         no_ready_task   := True;
         smallest_deadline := Integer'Last;
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);
            if a_tcb.status = task_ready then
               no_ready_task := False;
               if a_tcb.deadline <= smallest_deadline then
                  smallest_deadline := a_tcb.deadline;
                  elected_task := a_tcb;
               end if;
            end if;
         end loop;

         -- Run the task
         if not no_ready_task then
            elected_task.the_task.wait_for_processor;
            elected_task.the_task.release_processor;
         else
            Put_Line ("No task to run at time " &
               Integer'Image (user_level_scheduler.get_current_time));
         end if;

         -- Go to the next unit of time
         user_level_scheduler.next_time;
         exit when user_level_scheduler.get_current_time > duration_in_time_unit;

         -- Check the scheduling and release tasks
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);

            -- Check for misses deadlines
            if user_level_scheduler.get_current_time = a_tcb.deadline
               and a_tcb.status = task_ready
            then
               Put_Line ("Task" & Integer'Image (i) & " misses its deadline at time " &
                  Integer'Image (user_level_scheduler.get_current_time));
               New_Line;
               Put_Line ("The simulation is not schedulable");
               return;
            end if;

            -- Release tasks
            if a_tcb.the_type = task_periodic then
               -- Release periodic tasks
               if user_level_scheduler.get_current_time mod a_tcb.period = 0 then
                  Put_Line ("Task" & Integer'Image (i) & " is released at time "
                     & Integer'Image (user_level_scheduler.get_current_time));
                  user_level_scheduler.set_task_status (i, task_ready);                  
                  user_level_scheduler.set_task_deadline (i, a_tcb.deadline + a_tcb.period);
               end if;

            else
               -- Release aperiodic and sporodic tasks
               if a_tcb.start = user_level_scheduler.get_current_time then
                  Put_Line ("Task" & Integer'Image (i) & " is released at time "
                     & Integer'Image (user_level_scheduler.get_current_time));
                  user_level_scheduler.set_task_status (i, task_ready);
               end if;

               -- If sporadic task completed, set the next start
               if a_tcb.the_type = task_sporadic then
                  if a_tcb.start < user_level_scheduler.get_current_time
                     and a_tcb.status = task_pended
                  then
                     user_level_scheduler.set_task_start (i, user_level_scheduler.get_current_time - a_tcb.capacity + a_tcb.minimum_delay);
                  end if;
               end if;
            
            end if;

         end loop;

      end loop;
      New_Line;
      Put_Line ("The simulation is schedulable");
   end earliest_deadline_first_schedule;

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
