module TestMoney
    using Test
    include("../src/money.jl")

    function main()
        @testset "times" begin
            @test Money.times(Money.money(2), 2) == Money.money(4)
            @test 1+1 == 2
        end
    end
end

using. TestMoney
TestMoney.main()
