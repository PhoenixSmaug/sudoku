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

@inline function check(s::Sudoku, x::Int64, y::Int64, value::Int64)
    for i in 1:9  # check row
        if (i != y && s.field[x, i] == value)
            return false
        end
    end

    for i in 1:9  # check column
        if (i != x && s.field[i, y] == value)
            return false
        end
    end

    cornerX = x - (x - 1) % 3
    cornerY = y - (y - 1) % 3

    for i in 0 : 2
        for j in 0 : 2
            if (i != x || j != y)
                if (s.field[cornerX + i, cornerY + j] == value)
                    return false
                end
            end
        end
    end

    return true
end

@inline function findEmpty(s::Sudoku)
    for i in 1 : 9
        for j in 1 : 9
            if (s.field[i, j] == 0)
                return i, j
            end
        end
    end

    return 0, 0
end

function solve!(s::Sudoku)
    x, y = findEmpty(s)
    if (x == 0 && y == 0)
        return true
    end

    for i in 1 : 9
        if (check(s, x, y, i))
            s.field[x, y] = i

            if (solve!(s))
                return true
            end

            s.field[x, y] = 0
        end
    end

    return false
end
