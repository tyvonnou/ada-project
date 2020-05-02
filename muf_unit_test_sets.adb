with Text_IO;                 use Text_IO;
with user_level_schedulers;   use user_level_schedulers;
with user_level_tasks;        use user_level_tasks;
with my_subprograms;          use my_subprograms;
with schedulers;              use schedulers;

procedure muf_unit_test_sets is
   response : Character;
begin
   Put_Line ("Choisir le test d'ordonnancement MUF :");
   Put_Line ("1/ Test ordonnançable");
   Put_Line ("2/ Test non ordonnançable");
   Put_Line ("3/ Test des priorités utilisateurs");
   Put_Line ("4/ Test avec des tâches non périodiques");
   Put_Line ("5/ Test avec des tâches où la période est différente de la deadline");
   New_Line; Get(response); New_Line;

   case response is
      when '1' =>
         Put_Line("Tâche 1 (Périodique) => Période  6, Capacité  2, Deadline  6, Priorité 0");
         Put_Line("Tâche 2 (Périodique) => Période 10, Capacité  4, Deadline 10, Priorité 0");
         Put_Line("Tâche 3 (Périodique) => Période 12, Capacité  3, Deadline 12, Priorité 0");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 6, 2, 6, 0, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 10, 4, 10, 0, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 12, 3, 12, 0, T3'Access);

      when '2' =>
         Put_Line("Tâche 1 (Périodique) => Période  6, Capacité  2, Deadline  6, Priorité 0");
         Put_Line("Tâche 2 (Périodique) => Période 10, Capacité  4, Deadline 10, Priorité 0");
         Put_Line("Tâche 3 (Périodique) => Période 12, Capacité  3, Deadline 12, Priorité 0");
         Put_Line("Tâche 4 (Périodique) => Période 15, Capacité  4, Deadline 15, Priorité 0");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 29, 7, 29, 0, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 5, 3, 5, 0, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, 10, 0, T3'Access);
         user_level_scheduler.new_user_level_task_periodic (id4, 15, 4, 15, 0, T4'Access);

      when '3' =>
         Put_Line("Tâche 1 (Périodique) => Période 30, Capacité  1, Deadline 10, Priorité 1");
         Put_Line("Tâche 2 (Périodique) => Période 30, Capacité  1, Deadline 10, Priorité 0");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 30, 1, 30, 1, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 30, 1, 30, 0, T2'Access);


      when '4' =>
         Put_Line("Tâche 1 (Périodique)  => Période 12, Capacité  5, Deadline 12");
         Put_Line("Tâche 2 (Apériodique) => Start    7, Capacité  1, Deadline  9");
         Put_Line("Tâche 3 (Apériodique) => Start   12, Capacité  3, Deadline 21");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 12, 5, 12, 0, T1'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida1, 7, 1, 2, TA1'Access);
         user_level_scheduler.new_user_level_task_aperiodic (ida2, 12, 3, 9, TA2'Access);

      when '5' =>
         Put_Line("Tâche 1 (Périodique) => Période 29, Capacité  7, Deadline 25");
         Put_Line("Tâche 2 (Périodique) => Période  5, Capacité  1, Deadline  3");
         Put_Line("Tâche 3 (Périodique) => Période 10, Capacité  2, Deadline  8");
         New_Line;
         user_level_scheduler.new_user_level_task_periodic (id1, 29, 7, 25, 0, T1'Access);
         user_level_scheduler.new_user_level_task_periodic (id2, 5, 1, 3, 0, T2'Access);
         user_level_scheduler.new_user_level_task_periodic (id3, 10, 2, 8, 0, T3'Access);

      when others =>
         Put_Line("Please, select a test ( 1 - 4 )");
         return;
   end case;

   -- Ordonnancement selon MUF
   maximum_urgency_first_schedule (30);
   abort_tasks;

end muf_unit_test_sets;
