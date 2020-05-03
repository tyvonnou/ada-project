# ADA Project

The objective of this work is to develop software to simulate real-time scheduling algorithms.

## Create a simulation

First you can create your own file of simulation based on the exemples already created rm_unit_test_sets.adb, edf_unit_test_sets.adb, muf_unit_test_sets.adb. In your file, you need to create several tasks and run a simulation algorithm.

### Simulation algorithms

**Rate-monotonic scheduling** is an real-time scheduling algorithm with constant priority (static). It assigns the highest priority to the task with the smallest period.

**Earliest deadline ﬁrst scheduling** is a pre-emptive scheduling algorithm used in real-time systems. It assigns a priority to each task according to its deadline and according to the rule: If a task's deadline is close, its priority is higher. In this way, the sooner the work has to be done, the more likely it is to be executed.

**Maximum urgency ﬁrst scheduling** is a real-time algorithm of planiﬁcation for periodic tasks. Each task is assigned an urgency which is defined as a combination of two priorities ﬁxes and a dynamic priority. Prior to the execution of the algorithm, tasks are defined as "critical" by the scheduler. Then during scheduling, the critical tasks with the lowest "laxity" are selected. If no defined critical task is ready, the planiﬁcateur selects the task with the least laxity.

### Tasks

**Periodic tasks** have a period and a capacity. They execute their capacity each time their period renews.

**Aperiodic tasks** wake up at the time given by the user and run only once.

**Sporadic tasks** wake up at a random time but always with a minimum delay given by the user. To simulate randomness, the user gives a percentage chance of waking up. After waking up, at each turn, according to the given percentage of chance, the task will define its next wake up at the current time + the minimum delay.

## Compilation

### RM Exemple

* `gnat make -g -O0 -Ipackages rm_unit_test_sets`

### EDF Exemple

* `gnat make -g -O0 -Ipackages edf_unit_test_sets`

### MUF Exemple

* `gnat make -g -O0 -Ipackages muf_unit_test_sets`

## Start

### Using gdb

* `gdb rm_unit_test_sets`
* `(gdb) run`

### Without gdb

* `./rm_unit_test_sets`

## Clean

### Windows

* `rm b* *.exe *.o *.ali rm_unit_test_sets edf_unit_test_sets muf_unit_test_sets`

### Linux

* `rm b* exemple *.o *.ali rm_unit_test_sets edf_unit_test_sets muf_unit_test_sets`

## Authors

* [Théo Yvonnou](https://github.com/tyvonnou)
* [Kilian Anchyse](https://github.com/anchyseK)
