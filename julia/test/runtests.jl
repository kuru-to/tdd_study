using JuliaMoney
using Test

usd = JuliaMoney.currency_dollar()
chf = JuliaMoney.currency_franc()
jpy = JuliaMoney.currency_yen()

# 通貨に関する設定のテスト
@testset "currrency" begin
    @test JuliaMoney.currency_dollar() == JuliaMoney.Currency("USD")
    @test_throws DomainError JuliaMoney.Currency("usd")
end

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
    JuliaMoney.add_rate!(aBank, usd, chf, rate)
    test_dollar = JuliaMoney.dollar(2)
    @test JuliaMoney.reduce(test_dollar, chf, aBank) == JuliaMoney.franc(2 * rate)
    @test JuliaMoney.reduce(test_dollar, test_dollar.currency, aBank) == test_dollar
end

@testset "same currency plus" begin
    five_dollar = JuliaMoney.dollar(5)
    @test JuliaMoney.reduce(JuliaMoney.plus(five_dollar, five_dollar), usd) == JuliaMoney.dollar(5 + 5)
    three_franc = JuliaMoney.franc(3)
    two_franc = JuliaMoney.franc(2)
    @test JuliaMoney.reduce(JuliaMoney.plus(three_franc, two_franc), chf) == JuliaMoney.franc(3 + 2)
end

@testset "different currency plus" begin
    aBank = JuliaMoney.Bank()
    rate = 2.0
    JuliaMoney.add_rate!(aBank, usd, chf, rate)
    test_money = JuliaMoney.plus(JuliaMoney.dollar(5), JuliaMoney.franc(10))
    @test JuliaMoney.reduce(test_money, usd, aBank) == JuliaMoney.dollar(5 + 10 / rate)
end

@testset "Sum times" begin
    five_dollar = JuliaMoney.dollar(5)
    test_sum = JuliaMoney.plus(five_dollar, five_dollar)
    test_dollar = JuliaMoney.reduce(JuliaMoney.times(test_sum, 2), usd)
    @test test_dollar == JuliaMoney.dollar((5 + 5) * 2)
end

@testset "minus" begin
    one_dollar = JuliaMoney.dollar(1)
    two_dollar = JuliaMoney.dollar(2)
    test_dollar = JuliaMoney.reduce(JuliaMoney.minus(two_dollar, one_dollar), usd)
    @test test_dollar == JuliaMoney.dollar(2 - 1)

    aBank = JuliaMoney.Bank()
    rate = 2.0
    JuliaMoney.add_rate!(aBank, usd, chf, rate)
    two_franc = JuliaMoney.franc(2)
    test_dollar = JuliaMoney.reduce(JuliaMoney.minus(two_franc, two_dollar), usd, aBank)
    @test test_dollar == JuliaMoney.dollar(2 / rate - 2)

    two_franc_plus_one_dollar = JuliaMoney.plus(two_franc, one_dollar)
    test_dollar = JuliaMoney.reduce(JuliaMoney.minus(two_dollar, two_franc_plus_one_dollar), usd, aBank)
    @test test_dollar == JuliaMoney.dollar(2 - (2 / rate + 1))
end

@testset "yen" begin
    hundred_yen = JuliaMoney.yen(100)
    @test JuliaMoney.times(hundred_yen, 3) == JuliaMoney.yen(100 * 3)
    @test JuliaMoney.reduce(JuliaMoney.plus(hundred_yen, hundred_yen), jpy) == JuliaMoney.yen(100 + 100)

    aBank = JuliaMoney.Bank()
    yen_rate = 100
    JuliaMoney.add_rate!(aBank, usd, jpy, yen_rate)
    @test JuliaMoney.reduce(hundred_yen, usd, aBank) == JuliaMoney.dollar(100 / yen_rate)

    franc_rate = 2
    JuliaMoney.add_rate!(aBank, usd, chf, franc_rate)
    sum = JuliaMoney.plus(hundred_yen, JuliaMoney.franc(2))
    test_dollar = JuliaMoney.reduce(sum, usd, aBank)
    @test test_dollar == JuliaMoney.dollar(100 / yen_rate + 2 / franc_rate)
end

@testset "account" begin
    usd_account = JuliaMoney.Account(usd)
    JuliaMoney.deposite!(usd_account, JuliaMoney.franc(4))
    aBank = JuliaMoney.Bank()
    rate = 2.0
    JuliaMoney.add_rate!(aBank, usd, chf, rate)
    @test JuliaMoney.balance(usd_account, aBank) == JuliaMoney.dollar(4 / rate)

    # 他の銀行口座に送金できること
    # 送金後に口座の残高が減っていること
    transfer_payment = JuliaMoney.dollar(1)
    chf_account = JuliaMoney.Account(chf)
    JuliaMoney.transfer!(usd_account, chf_account, transfer_payment, aBank)
    @test JuliaMoney.balance(chf_account, aBank) == JuliaMoney.franc(1 * rate)
    @test JuliaMoney.balance(usd_account, aBank) == JuliaMoney.dollar(4 / rate - 1)

    # 送金金額が自分の預金口座額より大きい場合, 送金不可能になること
    over_transfer_payment = JuliaMoney.dollar(100)
    @test_throws DomainError JuliaMoney.transfer!(usd_account, chf_account, over_transfer_payment, aBank)
end
