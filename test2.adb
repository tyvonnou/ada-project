with Text_IO;                 use Text_IO;
with user_level_schedulers;   use user_level_schedulers;
with user_level_tasks;        use user_level_tasks;
with my_subprograms;          use my_subprograms;
with schedulers;              use schedulers;

procedure test2 is
begin
   user_level_scheduler.new_user_level_task_periodic (id1, 6, 2, 6, 0, T1'Access);
   user_level_scheduler.new_user_level_task_periodic (id2, 10, 4, 10, 0, T2'Access);
   user_level_scheduler.new_user_level_task_periodic (id3, 12, 3, 12, 0, T3'Access);
   user_level_scheduler.new_user_level_task_periodic (ida1, 15, 4, 15, 0, TA1'Access);
   maximum_urgency_first_schedule (8);
   abort_tasks;
end test2;
