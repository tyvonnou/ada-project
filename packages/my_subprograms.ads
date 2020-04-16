package my_subprograms is

   id1, id2, id3, ida1, ida2, ids1 : Integer;

   -- Fonctions des tâches.
   -- Pour cette simulation, le rôle de chaque tâche est simplement une fonction d'affichage
   --

   -- Tâches périodiques
   procedure T1;
   procedure T2;
   procedure T3;

   -- Tâches apériodiques
   procedure TA1;
   procedure TA2;

   -- Tâches sporadiques
   procedure TS1;

end my_subprograms;
