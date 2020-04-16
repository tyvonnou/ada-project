with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO;               use Text_IO;
with user_level_schedulers; use user_level_schedulers;
with user_level_tasks;      use user_level_tasks;
with my_subprograms; use my_subprograms;

-- On suppose que les délais critiques sont égaux aux périodes
--

procedure example is
begin
   -- Creation des tâches // RM
   --user_level_scheduler.new_user_level_task_periodic (id1, 29, 7, 12, T1'Access);
   --user_level_scheduler.new_user_level_task_periodic (id2, 5, 1, 3, T2'Access);
   --user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, 8, T3'Access);

   -- Ordonnancement selon RM
   --rate_monotonic_schedule (29);
   --abort_tasks;

   -- Creation des taches // EDF
   --user_level_scheduler.new_user_level_task_periodic (id1, 12, 5, 12, T1'Access);
   --user_level_scheduler.new_user_level_task_periodic (id2, 6, 2, 6, T2'Access);
   --user_level_scheduler.new_user_level_task_periodic (id3, 24, 5, 24, T3'Access);
   --user_level_scheduler.new_user_level_task_aperiodic (ida1, 7, 1, 9, TA1'Access);
   --user_level_scheduler.new_user_level_task_aperiodic (ida2, 12, 3, 21, TA2'Access);

   --user_level_scheduler.new_user_level_task_periodic (id1, 5, 1, 5, T1'Access);
   --user_level_scheduler.new_user_level_task_sporadic (ids1, 7, 2, TS1'Access);
   -- Ordonnancement selon EDF
   --earliest_deadline_first_schedule (24);
   --abort_tasks;

end example;
