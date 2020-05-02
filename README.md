# ADA Project

The objective of this work is to develop software to simulate real-time scheduling algorithms.

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
