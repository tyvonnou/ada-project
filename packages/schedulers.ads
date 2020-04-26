package schedulers is

    procedure rate_monotonic_schedule (duration_in_time_unit : Integer);
    procedure earliest_deadline_first_schedule (duration_in_time_unit : Integer);

end schedulers;
