module TestMoney
    using Test
    include("../src/money.jl")

    function main()
        @testset "times" begin
            @test MoneyModule.times(MoneyModule.dollar(5), 2) == MoneyModule.dollar(5 * 2)
            @test MoneyModule.times(MoneyModule.dollar(1), 3) == MoneyModule.dollar(1 * 3)
        end

        @testset "franc" begin
            @test MoneyModule.times(MoneyModule.franc(5), 2) == MoneyModule.franc(5 * 2)
            @test MoneyModule.dollar(5) != MoneyModule.franc(5)
        end
    end
end

using. TestMoney
TestMoney.main()
