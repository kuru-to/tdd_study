module TestMoney
    using Test
    include("../src/money.jl")

    function main()
        @testset "times" begin
            @test MoneyModule.times(MoneyModule.dollar(2), 2) == MoneyModule.dollar(2 * 2)
            @test MoneyModule.times(MoneyModule.dollar(1), 3) == MoneyModule.dollar(1 * 3)
        end
    end
end

using. TestMoney
TestMoney.main()
