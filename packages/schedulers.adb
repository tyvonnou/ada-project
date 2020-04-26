with user_level_schedulers;   use user_level_schedulers;
with Text_IO;                 use Text_IO;
with random_number_generator; use random_number_generator;

package body schedulers is
   
   procedure rate_monotonic_schedule (duration_in_time_unit : Integer) is
      a_tcb           : tcb;
      no_ready_task   : Boolean;
      elected_task    : tcb;
      smallest_period : Integer;
      schedulable     : Boolean := True;

      Task_not_periodic         : exception;
      Deadline_not_equal_period : exception;
   begin

      -- Checks the concordance of tasks against the scheduler
      for i in 1 .. user_level_scheduler.get_number_of_task loop
         a_tcb := user_level_scheduler.get_tcb (i);
         if a_tcb.the_type /= task_periodic then
            raise Task_not_periodic;
         else
            if a_tcb.deadline /= a_tcb.period then
               raise Deadline_not_equal_period;
            end if;
         end if;
      end loop;

      -- Loop on tcbs, and select tasks which are ready and which have smallest periods
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
               schedulable := False;
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
      if schedulable then
         Put_Line ("The simulation is schedulable");
      else
         Put_Line ("The simulation is not schedulable");
      end if;

   exception
      when Task_not_periodic =>
         Put_line ("Task must be periodic !");
         raise;
      when Deadline_not_equal_period =>
         Put_line ("Deadline must be equal to period !"); 
         raise;
      when others =>
         Put_line("The program have met with a terrible fate !");
         raise;
   end rate_monotonic_schedule;

   procedure earliest_deadline_first_schedule (duration_in_time_unit : Integer) is
      a_tcb             : tcb;
      no_ready_task     : Boolean;
      elected_task      : tcb;
      smallest_deadline : Integer;
      schedulable       : Boolean := True;
   begin

      -- Loop on tcbs, and select tasks which are ready and which have smallest deadlines
      loop

         -- Find the next task to run
         no_ready_task   := True;
         smallest_deadline := Integer'Last;
         for i in 1 .. user_level_scheduler.get_number_of_task loop
            a_tcb := user_level_scheduler.get_tcb (i);
            if a_tcb.status = task_ready then
               no_ready_task := False;
               if a_tcb.deadline < smallest_deadline then
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
               schedulable := False;
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
                  -- Set the new deadline for sporadic tasks
                  if a_tcb.the_type = task_sporadic then
                     user_level_scheduler.set_task_deadline (i, a_tcb.start + a_tcb.period);
                  end if;
               end if;

               -- If sporadic task completed and the random choice to wake her up, set the next start
               if a_tcb.the_type = task_sporadic then
                  if a_tcb.start < user_level_scheduler.get_current_time
                     and random_number_generator.generate_random_number (100) < a_tcb.awake_percent
                  then
                     user_level_scheduler.set_task_start (i, user_level_scheduler.get_current_time + a_tcb.period);
                  end if;
               end if;
            
            end if;
         end loop;

      end loop;
      New_Line;
      if schedulable then
         Put_Line ("The simulation is schedulable");
      else
         Put_Line ("The simulation is not schedulable");
      end if;
   end earliest_deadline_first_schedule;

end schedulers;