module Money
    struct money
        amount::Int
    end

    function times(aMoney::money, augend::Int)
        return money(aMoney.amount * augend)
    end
end
