with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Text_IO;               use Text_IO;
with user_level_schedulers; use user_level_schedulers;
with user_level_tasks;      use user_level_tasks;
with my_subprograms; use my_subprograms;

procedure example is

begin
   ---- Creation des taches // RM
   -- user_level_scheduler.new_user_level_task (id1, 5, 1, 0, T1'Access);
   -- user_level_scheduler.new_user_level_task (id2, 10, 3, 0, T2'Access);
   -- user_level_scheduler.new_user_level_task (id3, 30, 8, 0, T3'Access);

   ---- ordonnancement selon RM
   -- rate_monotonic_schedule (29);

   -- Creation des taches // EDF
   user_level_scheduler.new_user_level_task_aperiodic (id1, 3, 7, T1'Access);
   user_level_scheduler.new_user_level_task_periodic (id2, 5, 2, 4, T2'Access);
   user_level_scheduler.new_user_level_task_sporadic (id3, 2, 15, T3'Access);

   -- ordonnancement selon EDF
   edf_schedule (29);
   abort_tasks;

end example;
