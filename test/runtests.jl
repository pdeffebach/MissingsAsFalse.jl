using MissingsAsFalse
using Test

@testset "scalar equality and other comparisons" begin
    x = missing

    b = @mfalse x == 5
    @test b == false

    b = @mfalse x > 5
    @test b == false


    b = @mfalse x >= 5
    @test b == false

    b = @mfalse x < 5
    @test b == false

    b = @mfalse x <= 5
    @test b == false
end

@testset "array equality and other comparisons" begin
    x = [1, missing]

    y = [1, 3]

    b = @mfalse x .== y
    @test b == [true, false]

    b = @mfalse x .> y
    @test b == [false, false]


    b = @mfalse x .>= y
    @test b == [true, false]

    b = @mfalse x .< y
    @test b == [false, false]

    b = @mfalse x .<= y
    @test b == [true, false]

    x = [1 missing; missing 3]
    y = [1 2; 4 3]
    b = @mfalse x .== y

    @test b == [true false; false true]
end

@testset "if and ifelse" begin
    x = missing

    b = @mfalse x == 1 ? 100 : 200

    @test b == 200

    b = @mfalse begin
        if x == 5
            100
        else
            200
        end
    end

    @test b == 200

    b = @mfalse begin
        if false
            100
        elseif x == 1
            200
        else
            300
        end
    end

    @test b == 300

    b = @mfalse if false
            100
        elseif x == 1
            200
        else
            300
    end

    @test b == 300
end

@testset "indexing" begin
    y = [1, 2, 3]
    x = [true, false, true]
    xm = [true, false, missing]
    xi = [1, 3]

    b = @mfalse y[x]
    @test b == [1, 3]

    b = @mfalse y[xm]
    @test b == [1]

    b = @mfalse y[xi]
    @test b == [1, 3]

    y = [1 2; 3 4]
    x = [true missing; missing true]
    b = @mfalse y[x]
    @test b == [1, 4]
end

@testset "&& and ||" begin
    x = missing

    b = @mfalse if (x || true)
        1
    else
        2
    end

    @test b == 1

    b = @mfalse if (x && true)
        1
    else
        2
    end

    @test b == 2

    b = @mfalse (x && missing)
    @test b = = false

    b = @mfalse (x || missing)
    @test b == false
end

@testset "infix" begin
    x = [missing]

    b = @mfalse map(==(true), x)
    @test b == [false]

    b = @mfalse map(<(100), x)
    @test b == [false]

    b = @mfalse map(<=(100), x)
    @test b == [false]

    b = @mfalse map(>(100), x)
    @test b == [false]

    b = @mfalse map(>=(100), x)
    @test b == [false]
end