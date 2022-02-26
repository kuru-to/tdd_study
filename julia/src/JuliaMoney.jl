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
struct Money{T<:Real} <: Expression
    amount::T
    currency::String
end

function dollar(amount::Real)::Money
    return Money(amount, "USD")
end

function franc(amount::Real)::Money
    return Money(amount, "CHF")
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
function times(aMoney::Money, multiplier::Real)::Money
    return Money(aMoney.amount * multiplier, aMoney.currency)
end

function times(aSum::Sum, multiplier::Real)::Sum
    return Sum(times(aSum.augend, multiplier), times(aSum.addend, multiplier))
end

"""
通貨同士の足し算
"""
function add(augend::Expression, addend::Expression)::Expression
    return Sum(augend, addend)
end

"""
`Money` の金額の符号を反転させる

引き算に使用
"""
function negative(aMoney::Money)::Expression
    return Money(-aMoney.amount, aMoney.currency)
end

"""
`Sum` の金額の符号を反転させる

各要素の金額の符号を反転させることで対応
"""
function negative(aSum::Sum)::Expression
    return Sum(negative(aSum.augend), negative(aSum.addend))
end

"""
通貨同士の引き算

Args:
    minuend: 被減数. 引かれる数
    subtrahend: 減数. 引く数
"""
function minus(minuend::Expression, subtrahend::Expression)::Expression
    return Sum(minuend, negative(subtrahend))
end

"""
通貨の変換をつかさどる銀行. レートは変化するので mutable
レート辞書は初期化する
"""
mutable struct Bank
    dct_rate::Dict{Tuple{String, String}, Number}
    Bank() = new(Dict())
end

"""
銀行にレートを追加する

逆の場合も入れておく
"""
function add_rate!(aBank::Bank, from_currency::String, to_currency::String, rate::Number)
    aBank.dct_rate[(from_currency, to_currency)] = rate
    aBank.dct_rate[(to_currency, from_currency)] = 1 / rate
end

"""
銀行から対象の通貨組み合わせからレートを取得

同じ通貨同士の変換は, レート1として出力

Args:
    aBank: 変換のレートを保持している銀行インスタンス. 同じ通貨の場合銀行を通す必要がないため,
        デフォルトとしてレートを持たない銀行インスタンスを格納しておく
"""
function rate(aBank::Bank, from_currency::String, to_currency::String)::Number
    if from_currency == to_currency
        return 1
    end
    return aBank.dct_rate[(from_currency, to_currency)]
end

"""
`Money`を縮約して通貨に変換
"""
function reduce(aBank::Bank, aMonay::Money, to_currency::String)::Money
    return Money(aMonay.amount * rate(aBank, aMonay.currency, to_currency), to_currency)
end

"""
`Sum`を縮約して通貨に変換
"""
function reduce(aBank::Bank, aSum::Sum, to_currency::String)::Money
    sum_amount = reduce(aBank, aSum.augend, to_currency).amount + reduce(aBank, aSum.addend, to_currency).amount
    return Money(sum_amount, to_currency)
end

end
