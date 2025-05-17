module SupplyChain::MilestonePayment {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to hold project and milestone status
    struct DeliveryProject has key, store {
        total_payment: u64,
        paid: bool,
        supplier: address,
    }

    /// Buyer initializes the payment to the contract
    public fun init_project(buyer: &signer, supplier: address, payment: u64) {
        let deposit = coin::withdraw<AptosCoin>(buyer, payment);
        coin::deposit<AptosCoin>(signer::address_of(buyer), deposit); // Keep funds with buyer until milestone
        let project = DeliveryProject {
            total_payment: payment,
            paid: false,
            supplier,
        };
        move_to(buyer, project);
    }

    /// Buyer releases payment to supplier after milestone completion
    public fun release_payment(buyer: &signer) acquires DeliveryProject {
        let project = borrow_global_mut<DeliveryProject>(signer::address_of(buyer));
        assert!(!project.paid, 1); // prevent double payment

        let payment = coin::withdraw<AptosCoin>(buyer, project.total_payment);
        coin::deposit<AptosCoin>(project.supplier, payment);
        project.paid = true;
    }
}
