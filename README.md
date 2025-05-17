# Supply Chain Milestone-Based Payments (Aptos Move Module)

This is a simple Move smart contract module for implementing milestone-based payments in a supply chain. The contract allows a buyer to fund a delivery project and release the payment to the supplier when a milestone is successfully completed.

## 📦 Module: `SupplyChain::MilestonePayment`

### 📁 Features
- Buyer initializes the project with a total payment amount and supplier address.
- Funds are held by the buyer until the milestone is marked complete.
- Payment is released to the supplier upon milestone confirmation.

---

## 🛠️ Functions

### `init_project(buyer: &signer, supplier: address, payment: u64)`

- Called by the **buyer** to create a new delivery project.
- Withdraws `payment` amount of `AptosCoin` from the buyer.
- Stores project info and keeps funds with the buyer.

#### Parameters:
- `buyer`: The account funding the project.
- `supplier`: The address of the supplier who will receive payment.
- `payment`: Amount of AptosCoin committed.

---

### `release_payment(buyer: &signer)`

- Called by the **buyer** to release the funds when the milestone is met.
- Transfers funds to the supplier.
- Marks the payment as completed to prevent re-use.

---

## 🧪 Example Workflow

1. Buyer publishes the contract.
2. Buyer calls `init_project` with supplier address and payment.
3. When the delivery milestone is achieved, the buyer calls `release_payment`.

---

## 🛡️ Notes
- Only one milestone is tracked in this simple version.
- Can be extended to support multiple milestones or escrow logic.
- All funds are handled using `AptosCoin`.
- 
![Screenshot 2025-05-17 134111](https://github.com/user-attachments/assets/bc7130b1-ffc7-474e-a55b-67a989252f49)

