include("sudoku.jl")

mat1 = [5; 3; 0; 0; 7; 0; 0; 0; 0;; 6; 0; 0; 1; 9; 5; 0; 0; 0;; 0; 9; 8; 0; 0; 0; 0; 6; 0;; 8; 0; 0; 0; 6; 0; 0; 0; 3;; 4; 0; 0; 8; 0; 3; 0; 0; 1;; 7; 0; 0; 0; 2; 0; 0; 0; 6;; 0; 6; 0; 0; 0; 0; 2; 8; 0;; 0; 0; 0; 4; 1; 9; 0; 0; 5;; 0; 0; 0; 0; 8; 0; 0; 7; 9]
mat2 = [0; 0; 0; 0; 0; 0; 0; 0; 0;; 0; 0; 0; 0; 0; 3; 0; 8; 5;; 0; 0; 1; 0; 2; 0; 0; 0; 0;; 0; 0; 0; 5; 0; 7; 0; 0; 0;; 0; 0; 4; 0; 0; 0; 1; 0; 0;; 0; 9; 0; 0; 0; 0; 0; 0; 0;; 5; 0; 0; 0; 0; 0; 0; 7; 3;; 0; 0; 2; 0; 1; 0; 0; 0; 0;; 0; 0; 0; 0; 4; 0; 0; 0; 9]

@time for i in 1 : 10
	sudoku = Sudoku(copy(mat2))
	@time solve!(sudoku)
	show(sudoku)
end
