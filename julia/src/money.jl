module MoneyModule
    struct Money
        amount::Integer
        currency::String
    end

    function times(aMoney::Money, augend::Int)
        return Money(aMoney.amount * augend, aMoney.currency)
    end

    function dollar(amount::Integer)
        return Money(amount, "USD")
    end
end
