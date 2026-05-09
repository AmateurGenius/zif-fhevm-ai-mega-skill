# RESOURCES: FHEVM Learning & Debugging Reference

**Curated links for AI agents and developers.**

---

## OFFICIAL ZAMA DOCUMENTATION

### Getting Started
- **FHEVM Intro:** https://docs.zama.ai/fhevm/overview
- **Quick Start Guide:** https://docs.zama.ai/fhevm/get-started
- **Security Model:** https://docs.zama.ai/fhevm/security

### API References
- **TFHE Solidity API:** https://docs.zama.ai/fhevm/solidity/tfhe
- **Encrypted Types:** https://docs.zama.ai/fhevm/solidity/encrypted-types
- **Reencryption Gateway:** https://docs.zama.ai/fhevm/solidity/reencryption

### Testnet Setup
- **Zama Devnet:** https://devnet.zama.ai
- **Faucet:** https://faucet.zama.ai
- **Block Explorer:** https://explorer.zama.ai
- **Network Config:** https://docs.zama.ai/fhevm/networks

  Official Links:
- Zama Hardhat Template: https://github.com/zama-ai/fhevm-hardhat-template
- Zama Solidity Guides: https://docs.zama.ai/fhevm/solidity-guides
- OpenZeppelin Confidential Contracts: https://github.com/OpenZeppelin/openzeppelin-confidential-contracts
- @zama-fhe/sdk: npm install @zama-fhe/sdk
- Inflectiv Dataset Creation: https://app.inflectiv.ai
- Flue Framework: https://github.com/withastro/flue

---

## TUTORIALS & EXAMPLES

### Beginner
- **Your First Encrypted Contract:** https://docs.zama.ai/fhevm/tutorials/vote
- **Encrypted Voting (Step-by-Step):** https://docs.zama.ai/fhevm/tutorials/voting
- **Hardhat Setup Guide:** https://docs.zama.ai/fhevm/hardhat

### Intermediate
- **Confidential Transfers:** https://docs.zama.ai/fhevm/tutorials/confidential-transfer
- **Reencryption Patterns:** https://docs.zama.ai/fhevm/tutorials/reencryption
- **Testing with Mock TFHE:** https://docs.zama.ai/fhevm/testing

### Advanced
- **Gas Optimization:** https://docs.zama.ai/fhevm/advanced/gas-optimization
- **Security Audit Checklist:** https://docs.zama.ai/fhevm/advanced/audit
- **Threshold Cryptography:** https://docs.zama.ai/fhevm/advanced/threshold

---

## COMMUNITY & SUPPORT

### Chat
- **Zama Discord:** https://discord.gg/zama (Official)
- **#fhevm channel:** Ask questions, get help, share projects
- **Bounty Program:** https://discord.gg/zama → #bounties

### GitHub
- **Zama FHEVM Repo:** https://github.com/zama-ai/fhevm
- **Examples:** https://github.com/zama-ai/fhevm/tree/main/examples
- **Issue Tracker:** Report bugs here
- **Discussions:** https://github.com/zama-ai/fhevm/discussions

### Forums
- **Zama Roadmap:** https://zama.ai/roadmap
- **Blog:** https://blog.zama.ai (Latest updates)
- **Twitter:** https://twitter.com/zama_fhe

---

## DEVELOPMENT TOOLS & LIBRARIES

### Hardhat Plugins
```bash
npm install --save-dev @zama-fhe/hardhat-plugin
npm install --save-dev @zama-fhe/solidity
npm install --save-dev hardhat-deploy
```

### SDK for Frontend
```bash
npm install @zama-fhe/sdk
npm install @zama-fhe/tfhe
npm install @zama-fhe/precompiled
```

### CLI Tools
```bash
npm install -g @zama-fhe/cli
zama-fhe --help
```

---

## DEBUGGING GUIDE

### Issue: "Invalid ciphertext"
**Cause:** Client-side encryption failed or mismatched key.
**Fix:** Verify `pubKey` matches gateway key. Use `@zama-fhe/sdk@latest`.

### Issue: "Reencryption Timeout"
**Cause:** Gateway unreachable or overloaded.
**Fix:** Check https://status.zama.ai, add retry logic, increase timeout.

### Issue: "Out of Gas"
**Cause:** Encrypted op more expensive than estimated.
**Fix:** Add 50% safety margin, use batch operations.

### Issue: "Type Mismatch: euint64 vs uint64"
**Cause:** Mixing plaintext and encrypted types.
**Fix:** Use `TFHE.asEuint64()` casting.

---

## QUICK REFERENCE: API CHEAT SHEET

```solidity
// Encryption
euint64 value = TFHE.asEuint64(42);

// Arithmetic
euint64 sum = TFHE.add(a, b);
euint64 diff = TFHE.sub(a, b);
euint64 product = TFHE.mul(a, b);

// Comparison (sealed inference)
ebool equal = TFHE.eq(a, b);
ebool less = TFHE.lt(a, b);
ebool lessOrEq = TFHE.lte(a, b);

// Logical
ebool result = TFHE.and(cond1, cond2);
ebool result = TFHE.or(cond1, cond2);
ebool result = TFHE.not(cond);

// Conditional (expensive)
euint64 chosen = TFHE.cmux(condition, ifTrue, ifFalse);

// Reencryption
bytes memory revealed = TFHE.reencrypt(value, pubKey);
```

---

**Last Updated:** May 2026  
**Status:** Production Reference
