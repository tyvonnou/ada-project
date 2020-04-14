with Text_IO; use Text_IO;

package body user_level_schedulers is

   -- Rate monotonic scheduling
   --
   procedure rate_monotonic_schedule (duration_in_time_unit : Integer) is
      a_tcb           : tcb;
      no_ready_task   : Boolean;
      elected_task    : tcb;
      smallest_period : Integer;
   begin

      -- Loop on tcbs, and select tasks which are ready
      -- and which have smallest periods
      --
      loop

        -- Find the next task to run
        --
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

         -- Run the task
         --
         if not no_ready_task then
            elected_task.the_task.wait_for_processor;
            elected_task.the_task.release_processor;
         else
            Put_Line
              ("No task to run at time " &
               Integer'Image (user_level_scheduler.get_current_time));
         end if;

         -- Go to the next unit of time
         --
         user_level_scheduler.next_time;
         exit when user_level_scheduler.get_current_time >
                   duration_in_time_unit;

         -- Release periodic tasks
         --
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);
            if (a_tcb.status = task_pended) then
               if user_level_scheduler.get_current_time mod a_tcb.period =
                  0
               then
                  Put_Line
                    ("Task" &
                     Integer'Image (i) &
                     " is released at time " &
                     Integer'Image (user_level_scheduler.get_current_time));
                  user_level_scheduler.set_task_status (i, task_ready);
               end if;
            end if;
         end loop;

      end loop;

   end rate_monotonic_schedule;

   -- edf scheduling
   --
   procedure edf_schedule (duration_in_time_unit : Integer) is
      a_tcb           : tcb;
      no_ready_task   : Boolean;
      elected_task    : tcb;
      smallest_deadline: Integer;
      current_capacity : Integer := 0;
   begin

      -- Loop on tcbs, and select tasks which are ready
      -- and which have smallest periods
      --
      loop

        -- Find the next task to run
        --
         no_ready_task   := True;
         smallest_deadline := Integer'Last;
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);
            if (a_tcb.status = task_ready) then
               no_ready_task := False;

               -- Set the deadline for sporadic task
               if (a_tcb.deadline = -1) then
                  a_tcb.deadline := duration_in_time_unit;
               end if;

               -- Select the smallest Deadline
               if a_tcb.deadline < smallest_deadline then
                  -- If not sporadic task 
                  if (a_tcb.minimum_delay = -1) then
                     smallest_deadline := a_tcb.deadline;
                     elected_task := a_tcb;
                  end if;
                  -- If sporadic task
                  if (a_tcb.minimum_delay /= -1) then
                     -- If never run
                     if (a_tcb.last_run = 0) then
                        smallest_deadline := a_tcb.deadline;
                        elected_task := a_tcb;
                     else
                     -- If minimum delay is reached 
                     if (user_level_scheduler.get_current_time - a_tcb.last_run >= a_tcb.minimum_delay) then
                        smallest_deadline := a_tcb.deadline;
                        elected_task := a_tcb;
                     end if;

                     end if;
                    
                  end if;
               end if;
            end if;
         end loop;

         -- Run the task
         --
         if not no_ready_task then
            elected_task.the_task.wait_for_processor;
            elected_task.the_task.release_processor;
            Put_Line(Integer'Image(current_capacity));

            if (current_capacity = 0) then
               if (elected_task.minimum_delay /= -1) then
                for i in 1 .. user_level_scheduler.get_number_of_task loop
                  a_tcb := user_level_scheduler.get_tcb (i);
                     if user_level_scheduler.compare_task(a_tcb, elected_task) then
                        user_level_scheduler.set_tcb_last_run(i, user_level_scheduler.get_current_time);
                        Put_Line(Integer'Image(elected_task.last_run));
                     end if;
                  end loop;
               end if;

            end if;
                       
            current_capacity := current_capacity + 1;

            if (current_capacity = elected_task.capacity) then
               if (elected_task.minimum_delay = -1 ) then
                  for i in 1 .. user_level_scheduler.get_number_of_task loop
                     a_tcb := user_level_scheduler.get_tcb (i);
                     if user_level_scheduler.compare_task(a_tcb, elected_task) then
                        user_level_scheduler.set_tcb_deadline(i, elected_task.deadline + elected_task.period);
                     end if;
                  end loop;
               end if;
               current_capacity := 0;
            end if;  

         else
            Put_Line
              ("No task to run at time " &
               Integer'Image (user_level_scheduler.get_current_time));
         end if;
        

         -- Go to the next unit of time
         --
         user_level_scheduler.next_time;
         exit when user_level_scheduler.get_current_time >
                   duration_in_time_unit;

         

         -- release tasks
         --
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);
            -- if not sporadic
            if (a_tcb.period /= -1) then
               if (a_tcb.status = task_pended) then
                  if user_level_scheduler.get_current_time mod a_tcb.period = 0
                  then
                     Put_Line
                     ("Task" &
                        Integer'Image (i) &
                        " is released at time " &
                        Integer'Image (user_level_scheduler.get_current_time));
                     user_level_scheduler.set_task_status (i, task_ready);
                  end if;
               end if;
            -- if sporadic
            else
               if user_level_scheduler.get_current_time = a_tcb.last_run + a_tcb.minimum_delay 
                  then

                  if (a_tcb.status = task_pended) then
                     Put_Line
                     ("Task" &
                        Integer'Image (i) &
                        " is released at time " &
                        Integer'Image (user_level_scheduler.get_current_time) & " " & Integer'Image (a_tcb.last_run) & " " & Integer'Image (a_tcb.minimum_delay));
                     user_level_scheduler.set_task_status (i, task_ready);
                  end if;
               end if;
            end if;
         end loop;

         

      end loop;

   end edf_schedule;

   procedure abort_tasks is
      a_tcb : tcb;
   begin
      if (user_level_scheduler.get_number_of_task = 0) then
         raise Constraint_Error;
      end if;

      for i in 1 .. user_level_scheduler.get_number_of_task loop
         a_tcb := user_level_scheduler.get_tcb (i);
         abort a_tcb.the_task.all;
      end loop;
   end abort_tasks;

   protected body user_level_scheduler is

      procedure set_task_status (id : Integer; s : task_status) is
      begin
         tcbs (id).status := s;
      end set_task_status;

      function compare_task (task1 : tcb; task2 : tcb) return Boolean is
      begin
         if (task1.period = task2.period) then  
            if (task1.deadline = task2.deadline) then
               if (task1.minimum_delay = task2.minimum_delay) then
                  if (task1.capacity = task2.capacity) then
                     return true;
                  end if;
               end if;
            end if;
         end if;
         return false;
      end compare_task;

      function get_tcb (id : Integer) return tcb is
      begin
         return tcbs (id);
      end get_tcb;

      -- Update the DeadLine
      procedure set_tcb_deadline (id : Integer; deadline : Integer)  is
      begin
         tcbs (id).deadline := deadline;
      end set_tcb_deadline;

      -- Update the last run
      procedure set_tcb_last_run (id : Integer; last_run : Integer)  is
      begin
         tcbs (id).last_run := last_run;
      end set_tcb_last_run;

      -- Create Periodic task
      procedure new_user_level_task_periodic
        (id         : in out Integer;
         period     : in Integer;
         capacity   : in Integer;
         deadline   : in Integer;
         subprogram : in run_subprogram)
      is
         CAPACITY_NULL_ERROR : exception;
         PERIOD_NULL_ERROR : exception;
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

         -- Check is the period is 0
         if (period = 0) then
            raise PERIOD_NULL_ERROR with "Capacity incorrect !";
         end if;

         number_of_task        := number_of_task + 1;
         a_tcb.period          := period;
         a_tcb.capacity        := capacity;
         a_tcb.deadline        := deadline;
         a_tcb.last_run        := 0;
         a_tcb.minimum_delay   := -1;
         a_tcb.status          := task_ready;
         a_tcb.the_task        :=
           new user_level_task (number_of_task, subprogram);
         tcbs (number_of_task) := a_tcb;
         id                    := number_of_task;
      exception
         when CAPACITY_NULL_ERROR => put_line("The capacity can not be equal to 0 !") ; 
         when PERIOD_NULL_ERROR => put_line("The period can not be equal to 0 !") ; 
         when others    => put_line("The program have met with a terrible fate !") ; 

      end new_user_level_task_periodic;

      -- Create Aperiodic task
      procedure new_user_level_task_aperiodic
        (id         : in out Integer;
         capacity   : in Integer;
         deadline   : in Integer;
         subprogram : in run_subprogram)
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

         number_of_task        := number_of_task + 1;
         a_tcb.period          := -1;
         a_tcb.capacity        := capacity;
         a_tcb.deadline        := deadline;
         a_tcb.last_run        := 0;
         a_tcb.minimum_delay   := -1;
         a_tcb.status          := task_ready;
         a_tcb.the_task        :=
           new user_level_task (number_of_task, subprogram);
         tcbs (number_of_task) := a_tcb;
         id                    := number_of_task;
      exception
         when CAPACITY_NULL_ERROR => put_line("The capacity can not be equal to 0 !") ; 
         when others    => put_line("The program have met with a terrible fate !") ; 
      end new_user_level_task_aperiodic;

      -- Create Sporadic Task
      procedure new_user_level_task_sporadic
        (id         : in out Integer;
         capacity   : in Integer;
         minimum_delay   : in Integer;
         subprogram : in run_subprogram)
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

         number_of_task        := number_of_task + 1;
         a_tcb.period          := -1;
         a_tcb.capacity        := capacity;
         a_tcb.deadline        := -1;
         a_tcb.last_run        := 0;
         a_tcb.minimum_delay   := minimum_delay;
         a_tcb.status          := task_ready;
         a_tcb.the_task        :=
           new user_level_task (number_of_task, subprogram);
         tcbs (number_of_task) := a_tcb;
         id                    := number_of_task;
      exception
         when CAPACITY_NULL_ERROR => put_line("The capacity can not be equal to 0 !") ; 
         when others    => put_line("The program have met with a terrible fate !") ; 
      end new_user_level_task_sporadic;

      -- The number of task created
      function get_number_of_task return Integer is
      begin
         return number_of_task;
      end get_number_of_task;

      -- The current time of the execution
      function get_current_time return Integer is
      begin
         return current_time;
      end get_current_time;

      -- The next time of the execution
      procedure next_time is
      begin
         current_time := current_time + 1;
      end next_time;

   end user_level_scheduler;

end user_level_schedulers;
