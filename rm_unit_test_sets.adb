with Text_IO;                 use Text_IO;
with user_level_schedulers;   use user_level_schedulers;
with user_level_tasks;        use user_level_tasks;
with my_subprograms;          use my_subprograms;
with schedulers;              use schedulers;

procedure rm_unit_test_sets is
   response : Character;
begin
   Put_Line ("Choisir le test d'ordonnancement RM :");
   Put_Line ("1/ Test ordonnançable");
   Put_Line ("2/ Test non ordonnançable");
   Put_Line ("3/ Test avec des tâches non périodiques");
   Put_Line ("4/ Test avec des tâches où la période est différente de la deadline");
   New_Line; Get(response); New_Line;
   
   case response is
      when '1' =>
         Put_Line("Tâche 1 (Périodique) => Période 29, Capacité  7, Deadline 29");
         Put_Line("Tâche 2 (Périodique) => Période  5, Capacité  1, Deadline  5");
         Put_Line("Tâche 3 (Périodique) => Période 10, Capacité  2, Deadline 10");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 29, 7, 29, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 5, 1, 5, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, 10, T3'Access);

      when '2' =>
         Put_Line("Tâche 1 (Périodique) => Période 29, Capacité  7, Deadline 29");
         Put_Line("Tâche 2 (Périodique) => Période  5, Capacité  3, Deadline  5");
         Put_Line("Tâche 3 (Périodique) => Période 10, Capacité  2, Deadline 10");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 29, 7, 29, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 5, 3, 5, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, 10, T3'Access);

      when '3' =>
         Put_Line("Tâche 1 (Périodique)  => Période 12, Capacité  5, Deadline 12");
         Put_Line("Tâche 2 (Apériodique) => Start    7, Capacité  1, Deadline  9");
         Put_Line("Tâche 3 (Apériodique) => Start   12, Capacité  3, Deadline 21");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 12, 5, 12, T1'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida1, 7, 1, 2, TA1'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida2, 12, 3, 9, TA2'Access);

      when '4' =>
         Put_Line("Tâche 1 (Périodique) => Période 29, Capacité  7, Deadline 25");
         Put_Line("Tâche 2 (Périodique) => Période  5, Capacité  1, Deadline  3");
         Put_Line("Tâche 3 (Périodique) => Période 10, Capacité  2, Deadline  8");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 29, 7, 25, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 5, 1, 3, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, 8, T3'Access);

      when others =>
         Put_Line("Please, select a test ( 1 - 4 )");
         return;
   end case;

   -- Ordonnancement selon RM
   rate_monotonic_schedule (30);
   abort_tasks;

end rm_unit_test_sets;
