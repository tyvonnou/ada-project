with Text_IO;                 use Text_IO;
with user_level_schedulers;   use user_level_schedulers;
with user_level_tasks;        use user_level_tasks;
with my_subprograms;          use my_subprograms;
with schedulers;              use schedulers;

procedure edf_unit_test_sets is
   response : Character;
begin
   Put_Line ("Choisir le test d'ordonnancement EDF :");
   Put_Line ("1/ Test avec des tâches périodiques");
   Put_Line ("2/ Test avec des tâches apériodiques");
   Put_Line ("3/ Test avec une tâche sporadique");
   Put_Line ("4/ Test non ordonnancable");
   New_Line; Get(response); New_Line;
   
   case response is
      when '1' =>
         Put_Line("Tâche 1 (Périodique) => Période 12, Capacité  5, Deadline 12");
         Put_Line("Tâche 2 (Périodique) => Période  6, Capacité  2, Deadline  6");
         Put_Line("Tâche 3 (Périodique) => Période 24, Capacité  5, Deadline 24");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 12, 5, 12, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 6, 2, 6, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 24, 5, 24, T3'Access);

      when '2' =>
         Put_Line("Tâche 1 (Apériodique) => Start  7, Capacité  1, Deadline  9");
         Put_Line("Tâche 2 (Apériodique) => Start 12, Capacité  3, Deadline 21");
         New_Line;
         user_level_scheduler.new_user_level_task_aperiodic (ida1, 7, 1, 2, TA1'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida2, 12, 3, 9, TA2'Access);

      when '3' =>
         Put_Line("Tâche 1 (Sporadique) => Période  5, Capacité  3, Pourcentage de réveil 50");
         New_Line;
         user_level_scheduler.new_user_level_task_sporadic (ids1, 5, 3, 50, TS1'Access);

      when '4' =>
         Put_Line("Tâche 1 (Périodique)  => Période 12, Capacité  5, Deadline 12");
         Put_Line("Tâche 2 (Périodique)  => Période  6, Capacité  2, Deadline  6");
         Put_Line("Tâche 3 (Périodique)  => Période 24, Capacité  5, Deadline 24");
         Put_Line("Tâche 4 (Apériodique) => Start    7, Capacité  1, Deadline  9");
         Put_Line("Tâche 5 (Apériodique) => Start   12, Capacité  3, Deadline 21");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 12, 5, 12, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 6, 2, 6, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 24, 5, 24, T3'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida1, 7, 1, 2, TA1'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida2, 12, 3, 9, TA2'Access);

      when others =>
         Put_Line("Please, select a test ( 1 - 4 )");
         return;
   end case;

   -- Ordonnancement selon EDF
   earliest_deadline_first_schedule (30);
   abort_tasks;

end edf_unit_test_sets;
