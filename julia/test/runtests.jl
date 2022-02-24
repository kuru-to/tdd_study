using JuliaMoney
using Test

@testset "times" begin
    @test JuliaMoney.times(JuliaMoney.dollar(5), 2) == JuliaMoney.dollar(5 * 2)
    @test JuliaMoney.times(JuliaMoney.dollar(1), 3) == JuliaMoney.dollar(1 * 3)
end

@testset "franc" begin
    @test JuliaMoney.times(JuliaMoney.franc(5), 2) == JuliaMoney.franc(5 * 2)
    @test JuliaMoney.dollar(5) != JuliaMoney.franc(5)
end

@testset "bank reduce" begin
    aBank = JuliaMoney.Bank(Dict())
    JuliaMoney.add_rate!(aBank, JuliaMoney.Pair("USD", "CHF"), 2.0)
    test_dollar = JuliaMoney.dollar(2)
    @test JuliaMoney.reduce(aBank, test_dollar, "CHF") == JuliaMoney.franc(4)
    @test JuliaMoney.reduce(aBank, test_dollar, test_dollar.currency) == test_dollar
end
