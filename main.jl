"""
General Sudoku Solver
- Depth first search
- Integer programming (HiGHS)
- Dancing Links
- Dataset: http://forum.enjoysudoku.com/the-hardest-sudokus-new-thread-t6539.html#p65791
"""

using ProgressMeter

struct Sudoku
    field::Array{Int64, 2}
end

Base.show(io::IO, x::Sudoku) = begin
    for i in 1 : 9
        if (i % 3 == 1)
            println(io, "+-------+-------+-------+")
        end
        for j in 1 : 9
            if (j % 3 == 1)
                print(io, "| ")
            end
            if (x.field[i, j] != 0)
                print(io, string(x.field[i, j]) * " ")
            else
                print(io, ". ")
            end
        end
        println(io, "|")
    end

    println(io, "+-------+-------+-------+")
end

function Sudoku(str::String)
    field = fill(0, 9, 9)
    for i in 1 : 9
        for j in 1 : 9
            field[i, j] = parse(Int64, str[j + (i - 1) * 9])
        end
    end

    Sudoku(field)
end

include("dfs.jl")
include("integer.jl")
include("dancing.jl")

function benchmark()
    text = readlines("data.txt")
    fields = Vector{Sudoku}()
    for i in text
        push!(fields, Sudoku(i))
    end

    pDAN = Progress(length(fields), "Dancing Links")
    ProgressMeter.update!(pDAN, 0)

    @time "Dancing Links" for i in 1 : length(fields)
        sudoku = Sudoku(copy(fields[i].field))
        solveDancing!(sudoku)
        ProgressMeter.update!(pDAN, i)
    end

    pINT = Progress(length(fields), "Integer programming")
    ProgressMeter.update!(pINT, 0)

    @time "Integer programming" for i in 1 : length(fields)
        sudoku = Sudoku(copy(fields[i].field))
        solveINT!(sudoku)
        ProgressMeter.update!(pINT, i)
    end

    pDFS = Progress(length(fields), "Depth first seach")
    ProgressMeter.update!(pDFS, 0)

    @time "Depth first seach" for i in 1 : length(fields)
        sudoku = Sudoku(copy(fields[i].field))
        solveDFS!(sudoku)
        ProgressMeter.update!(pDFS, i)
    end
end