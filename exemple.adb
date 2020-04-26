with Ada.Strings.Unbounded;   use Ada.Strings.Unbounded;
with Text_IO;                 use Text_IO;
with user_level_schedulers;   use user_level_schedulers;
with user_level_tasks;        use user_level_tasks;
with my_subprograms;          use my_subprograms;
with schedulers;              use schedulers;

procedure example is
begin
   -- Creation des tâches // RM
   --user_level_scheduler.new_user_level_task_periodic (id1, 5, 1, 5, T1'Access);
   --user_level_scheduler.new_user_level_task_periodic (id2, 5, 1, 5, T2'Access);
   --user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, T3'Access);

   -- Ordonnancement selon RM
   --rate_monotonic_schedule (29);
   --abort_tasks;

   -- Creation des taches // EDF
   --user_level_scheduler.new_user_level_task_periodic (id1, 12, 5, 12, T1'Access);
   --user_level_scheduler.new_user_level_task_periodic (id2, 6, 2, 6, T2'Access);
   --user_level_scheduler.new_user_level_task_periodic (id3, 24, 5, 24, T3'Access);
   --user_level_scheduler.new_user_level_task_aperiodic (ida1, 7, 1, 2, TA1'Access);
   --user_level_scheduler.new_user_level_task_aperiodic (ida2, 12, 3, 9, TA2'Access);
   user_level_scheduler.new_user_level_task_sporadic (id1, 5, 3, 50, T1'Access);
   -- Ordonnancement selon EDF
   earliest_deadline_first_schedule (30);
   abort_tasks;

end example;
