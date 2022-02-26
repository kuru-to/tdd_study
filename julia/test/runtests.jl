using JuliaMoney
using Test

@testset "dollar times" begin
    @test JuliaMoney.times(JuliaMoney.dollar(5), 2) == JuliaMoney.dollar(5 * 2)
    @test JuliaMoney.times(JuliaMoney.dollar(1), 3) == JuliaMoney.dollar(1 * 3)
end

@testset "franc" begin
    @test JuliaMoney.times(JuliaMoney.franc(5), 2) == JuliaMoney.franc(5 * 2)
    @test JuliaMoney.dollar(5) != JuliaMoney.franc(5)
end

@testset "Bank reduce" begin
    aBank = JuliaMoney.Bank()
    rate = 2.0
    JuliaMoney.add_rate!(aBank, "USD", "CHF", rate)
    test_dollar = JuliaMoney.dollar(2)
    @test JuliaMoney.reduce(aBank, test_dollar, "CHF") == JuliaMoney.franc(2 * rate)
    @test JuliaMoney.reduce(aBank, test_dollar, test_dollar.currency) == test_dollar
end

@testset "same currency add" begin
    aBank = JuliaMoney.Bank()
    five_dollar = JuliaMoney.dollar(5)
    @test JuliaMoney.reduce(aBank, JuliaMoney.add(five_dollar, five_dollar), "USD") == JuliaMoney.dollar(5 + 5)
    three_franc = JuliaMoney.franc(3)
    two_franc = JuliaMoney.franc(2)
    @test JuliaMoney.reduce(aBank, JuliaMoney.add(three_franc, two_franc), "CHF") == JuliaMoney.franc(3 + 2)
end

@testset "different currency add" begin
    aBank = JuliaMoney.Bank()
    rate = 2.0
    JuliaMoney.add_rate!(aBank, "USD", "CHF", rate)
    test_money = JuliaMoney.add(JuliaMoney.dollar(5), JuliaMoney.franc(10))
    @test JuliaMoney.reduce(aBank, test_money, "USD") == JuliaMoney.dollar(5 + 10 / rate)
end

@testset "Sum times" begin
    aBank = JuliaMoney.Bank()
    five_dollar = JuliaMoney.dollar(5)
    test_sum = JuliaMoney.add(five_dollar, five_dollar)
    test_dollar = JuliaMoney.reduce(aBank, JuliaMoney.times(test_sum, 2), "USD")
    @test test_dollar == JuliaMoney.dollar((5 + 5) * 2)
end

@testset "minus" begin
    aBank = JuliaMoney.Bank()
    one_dollar = JuliaMoney.dollar(1)
    two_dollar = JuliaMoney.dollar(2)
    test_dollar = JuliaMoney.reduce(aBank, JuliaMoney.minus(two_dollar, one_dollar), "USD")
    @test test_dollar == JuliaMoney.dollar(2 - 1)

    rate = 2.0
    JuliaMoney.add_rate!(aBank, "USD", "CHF", rate)
    two_franc = JuliaMoney.franc(2)
    test_dollar = JuliaMoney.reduce(aBank, JuliaMoney.minus(two_franc, two_dollar), "USD")
    @test test_dollar == JuliaMoney.dollar(2 / rate - 2)

    two_franc_plus_one_dollar = JuliaMoney.add(two_franc, one_dollar)
    test_dollar = JuliaMoney.reduce(aBank, JuliaMoney.minus(two_dollar, two_franc_plus_one_dollar), "USD")
    @test test_dollar == JuliaMoney.dollar(2 - (2 / rate + 1))
end
