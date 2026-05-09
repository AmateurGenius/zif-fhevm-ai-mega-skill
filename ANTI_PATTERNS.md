# ANTI-PATTERNS: What NOT to Do in FHEVM

**Critical reference for AI agents and developers.**

Every pattern below is a footgun. Flue harness auto-detects these.

---

## CATEGORY A: ENCRYPTED CONTROL FLOW (SECURITY + LOGIC BREAKING)

### ❌ A1: If Statement on Encrypted Value
```solidity
// WRONG – Will fail or behave unexpectedly
if (encryptedBalance > 1000) {
    transfer();
}
```

**Why:** `encryptedBalance` is a ciphertext, not a boolean. Solidity can't evaluate it.

**Fix:**
```solidity
// RIGHT – Use sealed inference
ebool isHighBalance = TFHE.gt(encryptedBalance, 1000);
// Then either:
// (a) Use TFHE.cmux() for conditional logic
euint64 newBalance = TFHE.cmux(isHighBalance, reduceBy(encryptedBalance, 100), encryptedBalance);
// (b) Or reencrypt & let frontend decide
bytes memory encbalance_sealed = TFHE.reencrypt(isHighBalance, pubKey);
```

---

### ❌ A2: Loop Over Encrypted Value
```solidity
// WRONG – Infinite loop or compile error
for (uint i = 0; i < encryptedCount; i++) {
    processItem(i);
}
```

**Why:** Compiler can't determine loop bounds from ciphertext.

**Fix:**
```solidity
// RIGHT – Loop over plaintext, use encrypted value inside
uint256 plainCount = 10; // Known max
for (uint i = 0; i < plainCount; i++) {
    ebool condition = TFHE.eq(TFHE.asEuint64(encryptedValue), i);
    if (isTrue(condition)) {
        processItem(i); // Uses plaintext i
    }
}
```

---

## CATEGORY B: ARITHMETIC & TYPE MISMATCHES

### ❌ B1: Mixed Plaintext + Encrypted Arithmetic
```solidity
// WRONG
euint32 balance = TFHE.asEuint32(100);
uint256 fee = 10;
euint32 result = TFHE.add(balance, fee); // Type mismatch
```

**Why:** `fee` is plaintext (uint256), `balance` is encrypted (euint32). Types incompatible.

**Fix:**
```solidity
// RIGHT – Cast to same encrypted type first
euint32 feeCasted = TFHE.asEuint32(fee);
euint32 result = TFHE.add(balance, feeCasted);
```

---

### ❌ B2: Overflow Without Checked Arithmetic
```solidity
// WRONG – No overflow check
euint32 balance = TFHE.asEuint32(type(uint32).max);
euint32 newBalance = TFHE.add(balance, TFHE.asEuint32(1)); // Wraps silently
```

**Why:** Encrypted arithmetic wraps on overflow (like regular Solidity before 0.8.0).

**Fix:**
```solidity
// RIGHT – Use sealed inference to check bounds
ebool willOverflow = TFHE.gt(balance, TFHE.asEuint32(type(uint32).max - 1));
require(evaluateBool(TFHE.not(willOverflow)), "Would overflow");
euint32 newBalance = TFHE.add(balance, TFHE.asEuint32(1));
```

---

## CATEGORY C: REENCRYPTION & GATEWAY MISUSE

### ❌ C1: Reencrypt Without User Authorization
```solidity
// WRONG – Leaks user's encrypted balance to contract owner
bytes memory leaked = TFHE.reencrypt(userBalance, ownerPublicKey);
// Now owner can decrypt!
```

**Why:** User never authorized this. Violates privacy model.

**Fix:**
```solidity
// RIGHT – Only reencrypt with user's own public key or authorized gateway
// User calls: reencrypt(userPublicKey, signedApproval)
require(verifySignature(userApproval, msg.sender), "User must approve");
bytes memory userEncrypted = TFHE.reencrypt(userBalance, userPublicKey);
```

---

### ❌ C2: Hardcoded Gateway Public Key
```solidity
// WRONG
bytes memory gatewayKey = hex"0x123abc...";
bytes memory reencrypted = TFHE.reencrypt(value, gatewayKey);
```

**Why:** Hardcoded keys rotate. If leaked, all reencryption is compromised.

**Fix:**
```solidity
// RIGHT – Use contract state variable, updatable by owner
bytes internal currentGatewayKey;

function updateGatewayKey(bytes memory newKey) external onlyOwner {
    emit GatewayKeyUpdated(newKey);
    currentGatewayKey = newKey;
}
```

---

## CATEGORY D: STATE & STORAGE ANTI-PATTERNS

### ❌ D1: Storing Plaintext + Encrypted Together Without Audit
```solidity
// WRONG – Correlation attack
struct Transaction {
    uint256 timestamp; // plaintext
    uint256 amount;    // plaintext (oops!)
    euint64 sealedAmount; // encrypted
}
```

**Why:** Adversary sees plaintext `amount`, reduces security.

**Fix:**
```solidity
// RIGHT – Clear separation
struct Transaction {
    bytes32 commitmentHash; // H(amount, salt) – plaintext proof
    euint64 sealedAmount;   // encrypted
}
```

---

### ❌ D2: Mutable Encrypted State Without Versioning
```solidity
// WRONG – Can't audit which ciphertext was active when
euint64 public balance = 1000;

function deductFee(euint64 fee) external {
    balance = TFHE.sub(balance, fee); // No version, no event
}
```

**Why:** No traceability if contract is hacked.

**Fix:**
```solidity
// RIGHT – Version & emit on every change
euint64 public balance;
uint256 public balanceVersion;

function deductFee(euint64 fee) external {
    balance = TFHE.sub(balance, fee);
    balanceVersion++;
    emit BalanceUpdated(balanceVersion, balance);
}
```

---

## CATEGORY E: TESTING ANTI-PATTERNS

### ❌ E1: Testing Encrypted Logic Without TFHE Mock
```typescript
// WRONG
const result = await contract.compareEncrypted(a, b);
// Works locally but fails on testnet due to missing TFHE
```

**Why:** Local Hardhat has no real TFHE. Need @zama-fhe/hardhat-plugin mock.

**Fix:**
```typescript
// RIGHT – Use hardhat.config.ts with TFHE plugin
require("@zama-fhe/hardhat-plugin");

// Test file:
const result = await contract.compareEncrypted(a, b);
expect(result).to.equal(expectedValue);
```

---

## CATEGORY F: DEPLOYMENT & CONFIGURATION MISTAKES

### ❌ F1: Wrong Network in Deployment
```bash
# WRONG – Deployed to mainnet instead of testnet
npx hardhat run scripts/deploy.ts --network mainnet
```

**Why:** FHEVM is only on Zama testnet. Mainnet contract can't use TFHE, reverts.

**Fix:**
```bash
# RIGHT
npx hardhat run scripts/deploy.ts --network zama-testnet
```

---

### ❌ F2: Using Private Key in Deployment Script
```javascript
// WRONG – Secrets in version control!
module.exports = {
    networks: {
        zamaTestnet: {
            url: "https://devnet.zama.ai",
            accounts: ["0x1234567890abcdef..."]
        }
    }
};
```

**Why:** Anyone with access to repo gets private key.

**Fix:**
```javascript
// RIGHT – Use environment variables
require("dotenv").config();
module.exports = {
    networks: {
        zamaTestnet: {
            url: process.env.ZAMA_RPC_URL,
            accounts: [process.env.PRIVATE_KEY]
        }
    }
};
```

---

## CATEGORY G: GAS & PERFORMANCE FOOTGUNS

### ❌ G1: Calling Expensive Encrypted Op In Loop
```solidity
// WRONG – Each TFHE.add costs 100k gas, loop = 100k * 1000
for (uint i = 0; i < 1000; i++) {
    total = TFHE.add(total, values[i]); // 100M gas! Will fail
}
```

**Why:** Encrypted operations are expensive. Loop multiplies cost.

**Fix:**
```solidity
// RIGHT – Batch operations or use off-chain compute
// Option 1: Pre-sum off-chain, verify on-chain
uint256 plainSum = 0;
for (uint i = 0; i < 1000; i++) {
    plainSum += values[i];
}
total = TFHE.add(total, TFHE.asEuint64(plainSum));
```

---

## QUICK CHECKLIST FOR CODE REVIEW

Run this before marking a contract as "Ready for testnet":

- [ ] No `if (encryptedValue)` anywhere
- [ ] No loops over `encryptedValue`
- [ ] All arithmetic uses TFHE.add/sub/mul, not `+`/`-`/`*`
- [ ] Reencryption only with user's pubkey (or authorized gateway)
- [ ] No plaintext and encrypted mixed without clear separation
- [ ] No hardcoded gateway keys
- [ ] Tests pass with TFHE mock plugin
- [ ] Gas estimates realistic (>100k for deploy, >50k for ops)
- [ ] Events logged for every state change
- [ ] Comments explain which fields are encrypted
- [ ] Private keys NOT in hardhat.config or version control
- [ ] Deployment script uses environment variables for secrets

---

**Last Updated:** May 2026  
**Status:** Complete Reference
