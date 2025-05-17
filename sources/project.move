module MyModule::MilestonePayments {
    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Represents a payment agreement between buyer and supplier.
    struct MilestonePayment has key, store {
        amount: u64,
        paid: bool,
        supplier: address,
    }

    /// Buyer locks funds for milestone payment to the supplier.
    public fun lock_payment(buyer: &signer, supplier: address, amount: u64) {
        let payment = MilestonePayment {
            amount,
            paid: false,
            supplier,
        };
        move_to(buyer, payment);
        let coins = coin::withdraw<AptosCoin>(buyer, amount);
        coin::deposit<AptosCoin>(@0x1, coins); // Temporarily hold in system account
    }

    /// Buyer confirms milestone completion and releases funds to supplier.
    public fun release_payment(buyer: &signer) acquires MilestonePayment {
        let payment = borrow_global_mut<MilestonePayment>(signer::address_of(buyer));
        assert!(!payment.paid, 1); // Ensure not already paid
        let coins = coin::withdraw<AptosCoin>(&signer::address_of(buyer), payment.amount);
        coin::deposit<AptosCoin>(payment.supplier, coins);
        payment.paid = true;
    }
}
