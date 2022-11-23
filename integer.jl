"""
Integer programming (HiGHS)
- Standard translation into Linear Inequality System
- Open source solver HiGHS
"""

using JuMP
using HiGHS

function solveINT!(s::Sudoku)
    model = Model(HiGHS.Optimizer)
    set_silent(model)

    @variable(model, x[1:9, 1:9, 1:9], Bin)

    # already placed numbers
    for r in 1 : 9
        for c in 1 : 9
            if s.field[r, c] != 0
                @constraint(model, x[r, c, s.field[r, c]] == 1)
            end
        end
    end

    # exactly one value per field
    for r in 1 : 9
        for c in 1 : 9
            @constraint(model, sum(x[r, c, :]) == 1)
        end
    end

    # no duplicate values in row
    for c in 1 : 9
        for v in 1 : 9
            @constraint(model, sum(x[:, c, v]) == 1)
        end
    end

     # no duplicate values in column
    for r in 1 : 9
        for v in 1 : 9
            @constraint(model, sum(x[r, :, v]) == 1) 
        end
    end

    # no duplicate values in group
    for r in [1, 4, 7]
        for c in [1, 4, 7]
            for v in 1 : 9
                group = Vector{VariableRef}()
                for i in 0 : 2
                    for j in 0 : 2
                        push!(group, x[r + i, c + j, v])
                    end
                end

                @constraint(model, sum(group) == 1)
            end
        end
    end

    optimize!(model)

    if has_values(model)  # if solveable
        for r in 1 : 9
            for c in 1 : 9
                for v in 1 : 9
                    if value(x[r, c, v]) > 0.5
                        s.field[r, c] = v
                    end
                end
            end
        end

        return true
    end

    return false
end