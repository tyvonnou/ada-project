with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with user_level_tasks;      use user_level_tasks;

package user_level_schedulers is

   max_user_level_task : constant Integer := 100;

   type task_type is (task_periodic, task_aperiodic, task_sporadic);
   type task_status is (task_ready, task_pended);

   subtype Percent is Integer range 0 .. 100;

   type tcb is record
      -- La tâche 
      the_task : user_level_task_ptr;

      -- Le type de la tâche (périodique, apériodique ou sporadique)
      the_type : task_type;

      -- Le statut de la tâche (prêt ou en suspend)
      status   : task_status;

      -- L'unité de temps à laquelle la tâche doit se réveiller
      -- (exclusif aux tâches apériodiques et sporadiques, -1 sinon)
      start    : Integer;

      -- La période d'exécution (exclusif aux tâches périodiques,
      -- délai minimum entre deux occurences pour les tâches sporadiques,
      -- -1 sinon)
      period   : Integer;

      -- Le nombre d'unités à exécuter pendant la période 
      capacity : Positive;

      -- La capacité restante de la tâche
      executed_capacity : Integer;

      -- L'unité de temps limite pour l'execution de la tâche
      deadline : Positive;

      -- Pourcentage de chance de réveiller la tâche
      -- (exclusif aux tâches sporadiques, -1 sinon)
      awake_percent : Integer;

      -- 0 si la tâche est dans l'ensemble critique, 1 sinon
      -- (exclusif à l'ordonnancement MUF)
      criticality : Integer;

      -- Priorité inversement proportionelle à la laxity minimum
      -- (exclusif à l'ordonnancement MUF)
      dynamic_priority : Integer;

      -- Priorité définie par l'utilisateur. Plus la priorité est basse,
      -- plus elle est prioritaire (exclusif à l'ordonnancement MUF)
      user_priority : Natural;

   end record;

   type tcb_type is array (1 .. max_user_level_task) of tcb;

   protected user_level_scheduler is

      -- Fonctions de créations des différentes tâches
      --

      -- Création d'une tâche périodique
      procedure new_user_level_task_periodic
        (id            : in out Integer;
         period        : in Positive;
         capacity      : in Positive;
         deadline      : in Positive;
         user_priority : in Natural;
         subprogram    : in run_subprogram);
      
      -- Création d'une tâche apériodique
      procedure new_user_level_task_aperiodic
        (id         : in out Integer;
         start      : in Natural;   
         capacity   : in Positive;
         deadline   : in Positive;
         subprogram : in run_subprogram);
      
      -- Création d'une tâche sporadique
      procedure new_user_level_task_sporadic
        (id              : in out Integer;
         period          : in Positive;
         capacity        : in Positive;
         awake_percent   : in Percent;
         subprogram      : in run_subprogram);


      -- Fonctions spécifiques à une tâches
      --

      -- Récupère la tâche avec l'id correspondant
      function get_tcb (id : Integer) return tcb;
      -- Met à jour le statut d'une tâche
      procedure set_task_status (id : Integer; s : task_status);
      -- Met à jour l'unité de temps d'éveil d'une tâche
      procedure set_task_start (id : Integer; start : Integer);
      -- Met à jour la capacité restante d'une tâche
      procedure set_task_executed_capacity (id : Integer; executed_capacity : Integer);
      -- Met à jour la deadline d'une tâche
      procedure set_task_deadline (id : Integer; deadline : Integer);
      -- Met à jour la criticité d'une tâche
      procedure set_task_criticality (id : Integer; criticality : Integer);
      -- Met à jour la priorité d'une tâche
      procedure set_task_dynamic_priority (id : Integer; dynamic_priority : Integer);


      -- Fonctions spécifiques au simulateur
      --

      -- Récupère le nombre de tâches de la simulation
      function get_number_of_task return Integer;
      -- Récupère l'unité de temps actuelle
      function get_current_time return Integer;
      -- Passe la simulation à l'unité de temps suivante
      procedure next_time;

      -- Fonctions vérifiant des trucs (Description à améliorer)
      --
      procedure check_tasks_limit;

   private
      -- Tableau contenant les différentes tâches
      tcbs           : tcb_type;

      -- Nombre de tâches de la simulation
      number_of_task : Integer := 0;

      -- Unité de temps actuelle
      current_time   : Integer := 0;

   end user_level_scheduler;

   -- Fonctions pour l'utilisateur
   --

   -- Abandons de toutes les tâches courantes
   procedure abort_tasks;

end user_level_schedulers;