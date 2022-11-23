# Benchmark Exact Cover Solver with Sudoku

Julia implemenation of the classical three exact cover solver:

* Simple Depth first search

* Solve as a Linear Integer Program with [HiGHS](https://github.com/jump-dev/HiGHS.jl)

* Knuth's Dancing Link Algorithm

Using `benchmark()` the performance of the three solvers at Sudoku can be tested. All three solvers have to solve the complete dataset of "hardest sudokus" [here](http://forum.enjoysudoku.com/the-hardest-sudokus-new-thread-t6539.html#p65791) manually collected by the "The New Sudoku Players' Forum". It is not intended to compete with solvers specialized in Sudoku, but simply uses Sudoku as an example for Exact Cover problems. My results on a machine with an Intel Core i9-10980HK were:

|       Solver        | Time |
|---------------------|------|
| Dancing Links       | 4s   |
| Integer Programming | 100s |
| Depth first search  | 47s  |
