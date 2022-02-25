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
    aBank = JuliaMoney.Bank()
    JuliaMoney.add_rate!(aBank, JuliaMoney.CurrencyPair("USD", "CHF"), 2.0)
    test_dollar = JuliaMoney.dollar(2)
    @test JuliaMoney.reduce(aBank, test_dollar, "CHF") == JuliaMoney.franc(2* 2)
    @test JuliaMoney.reduce(aBank, test_dollar, test_dollar.currency) == test_dollar
end

@testset "add" begin
    aBank = JuliaMoney.Bank()
    JuliaMoney.add_rate!(aBank, JuliaMoney.CurrencyPair("USD", "CHF"), 2.0)
    five_dollar = JuliaMoney.dollar(5)
    @test JuliaMoney.reduce(aBank, JuliaMoney.add(five_dollar, five_dollar), "USD") == JuliaMoney.dollar(5 + 5)
end

@testset "different currency add" begin
    aBank = JuliaMoney.Bank()
    JuliaMoney.add_rate!(aBank, JuliaMoney.CurrencyPair("USD", "CHF"), 2.0)
    test_money = JuliaMoney.add(JuliaMoney.dollar(5), JuliaMoney.franc(10))
    @test JuliaMoney.reduce(aBank, test_money, "USD") == JuliaMoney.dollar(10)
end

@testset "Sum times" begin
    aBank = JuliaMoney.Bank()
    five_dollar = JuliaMoney.dollar(5)
    test_sum = JuliaMoney.add(five_dollar, five_dollar)
    test_dollar = JuliaMoney.reduce(aBank, JuliaMoney.times(test_sum, 2), "USD")
    @test test_dollar == JuliaMoney.dollar((5 + 5) * 2)
end
