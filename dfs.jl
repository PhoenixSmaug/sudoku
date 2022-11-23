"""
Depth first search
- Select first empty element starting top left
- Check through 1, 2, ... 9 until valid number found
- Classic backtracking approach
"""

function solveDFS!(s::Sudoku)
    distToFirstDigit = fill(0, 8)
    for i in 0 : 7
        distToFirstDigit[i + 1] = findDigit(Sudoku(rotate(s.field, i)))
    end
    rot = findmin(distToFirstDigit)[2] - 1  # optimal rotation for dfs
    sRot = Sudoku(rotate(s.field, rot))

    if (rot == 3)  # rotate(rotate(p, i), i) = p for all i except 1, 3
        rot = 1
    elseif (rot == 1)
        rot = 3
    end

    backtrackDFS!(sRot)

    sOut = rotate(sRot.field, rot)

    for i in 1 : 9
        for j in 1 : 9
            s.field[i, j] = sOut[i, j]
        end
    end
end

function backtrackDFS!(s::Sudoku)
    x, y = findEmpty(s)
    if (x == 0 && y == 0)  # sudoku filled
        return true
    end

    for i in 1 : 9
        if (check(s, x, y, i))
            s.field[x, y] = i

            if (backtrackDFS!(s))
                return true
            end

            s.field[x, y] = 0
        end
    end

    return false
end

@inline function rotate(p::Matrix, d::Int64)
    if d <= 3
        return rotl90(p, d)
    else
        return reverse(rotl90(p, d - 4), dims=2)
    end
end

@inline function findDigit(s::Sudoku)
    for i in 1 : 9
        for j in 1 : 9
            if (s.field[i, j] != 0)
                return j + (i - 1) * 9
            end
        end
    end
end

# find first empty field in s
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


@inline function check(s::Sudoku, x::Int64, y::Int64, value::Int64)
    for i in 1 : 9  # check row
        if (i != y && s.field[x, i] == value)
            return false
        end
    end

    for i in 1 : 9  # check column
        if (i != x && s.field[i, y] == value)
            return false
        end
    end

    # check groups
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