module JuliaMoney

"""
通貨の計算式を表すインターフェース
"""
abstract type Expression end

"""
お金

Attributes:
    amount: 金額
    currency: 通貨
"""
struct Money <: Expression
    amount::Int
    currency::String
end

"""
お金の合計を表すクラス
要素はどちらも`Expression`型（`Money`かもしれないし`Sum`かもしれない）

Attributes:
    augend: 被加算数
    addend: 加算数
"""
struct Sum <: Expression
    augend::Expression
    addend::Expression
end

"""
`Money`の掛け算
"""
function times(aMoney::Money, multiplier::Int)::Money
    return Money(aMoney.amount * multiplier, aMoney.currency)
end

function times(aSum::Sum, multiplier::Int)::Sum
    return Sum(times(aSum.augend, multiplier), times(aSum.addend, multiplier))
end

function dollar(amount::Int)::Money
    return Money(amount, "USD")
end

function franc(amount::Int)::Money
    return Money(amount, "CHF")
end

"""
通貨同士の足し算
"""
function add(augend::Expression, addend::Expression)::Expression
    return Sum(augend, addend)
end

"""
銀行が通貨の変換を行う際の通貨のペア
"""
struct CurrencyPair
    from_currency::String
    to_currency::String
end

"""
ペアの from/to を逆転
"""
function reverse(aCurrencyPair::CurrencyPair)::CurrencyPair
    return CurrencyPair(aCurrencyPair.to_currency, aCurrencyPair.from_currency)
end

"""
通貨の変換をつかさどる銀行. レートは変化するので mutable
レート辞書は初期化する
"""
mutable struct Bank
    dct_rate::Dict{CurrencyPair, Number}
    Bank() = new(Dict())
end

"""
銀行にレートを追加する

逆の場合も入れておく
"""
function add_rate!(aBank::Bank, aCurrencyPair::CurrencyPair, rate::Number)
    aBank.dct_rate[aCurrencyPair] = rate
    aBank.dct_rate[reverse(aCurrencyPair)] = 1 / rate
end

"""
銀行から対象の通貨組み合わせからレートを取得

同じ通貨同士の変換は, レート1として出力
"""
function rate(aBank::Bank, aCurrencyPair::CurrencyPair)::Number
    if aCurrencyPair.from_currency == aCurrencyPair.to_currency
        return 1
    end
    return aBank.dct_rate[aCurrencyPair]
end

"""
`Money`を縮約して通貨に変換
"""
function reduce(aBank::Bank, aMonay::Money, to_currency::String)::Money
    return Money(aMonay.amount * rate(aBank, CurrencyPair(aMonay.currency, to_currency)), to_currency)
end

"""
`Sum`を縮約して通貨に変換
"""
function reduce(aBank::Bank, aSum::Sum, to_currency::String)::Money
    return Money(reduce(aBank, aSum.augend, to_currency).amount + reduce(aBank, aSum.addend, to_currency).amount, to_currency)
end

end
