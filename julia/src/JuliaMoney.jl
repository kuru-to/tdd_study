module JuliaMoney
struct Money
    amount::Int
    currency::String
end

function times(aMoney::Money, augend::Int)::Money
    return Money(aMoney.amount * augend, aMoney.currency)
end

function dollar(amount::Int)::Money
    return Money(amount, "USD")
end

function franc(amount::Int)::Money
    return Money(amount, "CHF")
end

"""
銀行が通貨の変換を行う際の通貨のペア
"""
struct Pair
    from_currency::String
    to_currencty::String
end

"""
通貨の変換をつかさどる銀行. レートは変化するので mutable
"""
mutable struct Bank
    dct_rate::Dict{Pair, Number}
end

"""
銀行にレートを追加する
"""
function add_rate!(aBank::Bank, aPair::Pair, rate::Number)
    aBank.dct_rate[aPair] = rate
end

"""
縮約して通貨に変換

同じ通貨同士の変換は, そのまま出力する
"""
function reduce(aBank::Bank, aMonay::Money, to_currency::String)::Money
    from_currency = aMonay.currency
    if from_currency == to_currency
        return aMonay
    end
    rate = aBank.dct_rate[Pair(from_currency, to_currency)]
    return Money(aMonay.amount * rate, to_currency)
end

end
