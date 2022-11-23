"""
Dancing Links
- Conversion into Exact Cover Problem
- Backtracking with Algorithm X
- Variation with Dictionaries (https://www.cs.mcgill.ca/~aassaf9/python/algorithm_x.html)

      -        Field filled (n^2)   Row has all numbers (n^2)   Column has all numbers (n^2)   Group has all numbers (n^2)  
------------- -------------------- --------------------------- ------------------------------ ----------------------------- 
 1 at (1, 1)                                                                                                                
 ...                                                                                                                        
 n at (1, 1)                                                                                                                
 1 at (1, 2)                                                                                                                
 ...                                                                                                                        
 n at (1, 2)                                                                                                                
 ...                                                                                                                        
 1 at (n, n)                                                                                                                
 ...                                                                                                                        
 n at (n, n)                                                                                                                
"""

using DataStructures

function solveDancing!(s::Sudoku)
    table = fill(false, 9^3, 4 * 9^2)

    for x in 1 : 9
        for y in 1 : 9
            for n in 1 : 9
                table[n + (y - 1) * 9 + (x - 1) * 81, x + (y - 1) * 9] = true  # field (x, y) filled
                table[n + (y - 1) * 9 + (x - 1) * 81, 9^2 + n + (x - 1) * 9] = true  # row x contains n
                table[n + (y - 1) * 9 + (x - 1) * 81, 2*9^2 + n + (y - 1) * 9] = true  # column y contains n

                g = fld(x - 1, 3) * 3 + fld(y - 1, 3) + 1  # group number
                table[n + (y - 1) * 9 + (x - 1) * 81, 3*9^2 + n + (g - 1) * 9] = true  # group g contains n
            end
        end
    end

    dictX, dictY = cover2dicts(table)
    solution = Stack{Int64}()

    # cover constraints already satisfied by placed numbers
    for x in 1 : 9
        for y in 1 : 9
            if (s.field[x, y] != 0)
                select!(dictX, dictY, s.field[x, y] + (y - 1) * 9 + (x - 1) * 81)
            end
        end
    end

    backtrack!(dictX, dictY, solution)

    if !(isempty(solution))
        for i in solution
            n = mod(i - 1, 9) + 1
            y = mod(fld(i - 1, 9), 9) + 1
            x = fld(i - 1, 81) + 1

            s.field[x, y] = n
        end

        return true
    end

    return false
end

@inline function cover2dicts(table::Matrix{Bool})
    dictX = Dict{Int64, Set{Int64}}()
    dictY = Dict{Int64, Vector{Int64}}()

    # initialize
    for i in 1 : size(table, 1)
        dictY[i] = Vector{Int64}()
    end
    for i in 1 : size(table, 2)
        dictX[i] = Set{Int64}()
    end

    # copy data from table
    for i in 1 : size(table, 1)
        for j in 1 : size(table, 2)
            if table[i, j]
                push!(dictY[i], j)
                push!(dictX[j], i)
            end
        end
    end

    return dictX, dictY
end

function backtrack!(dictX::Dict{Int64, Set{Int64}}, dictY::Dict{Int64, Vector{Int64}}, solution::Stack{Int64})
    if isempty(dictX)
        return true
    end

    # heuristic: constraint with least number of variables
    c = valMin = typemax(Int64)  
    for (key, value) in dictX
        if length(value) < valMin
            valMin = length(value)
            c = key
        end
    end

    for i in dictX[c]
        push!(solution, i)
        cols = select!(dictX, dictY, i)
        if backtrack!(dictX, dictY, solution)
            return true
        end

        deselect!(dictX, dictY, i, cols)
        pop!(solution)
    end

    return false
end

@inline function select!(dictX::Dict{Int64, Set{Int64}}, dictY::Dict{Int64, Vector{Int64}}, r::Int64)
    cols = Stack{Set{Int64}}()
    for j in dictY[r]
        for i in dictX[j]
            for k in dictY[i]
                if k != j
                    delete!(dictX[k], i)
                end
            end
        end

        push!(cols, pop!(dictX, j))
    end

    return cols
end

@inline function deselect!(dictX::Dict{Int64, Set{Int64}}, dictY::Dict{Int64, Vector{Int64}}, r::Int64, cols::Stack{Set{Int64}})
    for j in reverse(dictY[r])
        dictX[j] = pop!(cols)
        for i in dictX[j]
            for k in dictY[i]
                if k != j
                    push!(dictX[k], i)
                end
            end
        end
    end
end