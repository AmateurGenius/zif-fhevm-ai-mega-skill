# ZIF FHEVM AI Mega Skill – Core Specification

**For AI Coding Agents | Claude, Cursor, Windsurf, or Flue**

---

## SKILL MISSION
Transform any AI into a production-grade FHEVM expert capable of:
- Writing secure, gas-optimized confidential smart contracts
- Debugging encrypted state logic
- Building React frontends with @zama-fhe/sdk
- Deploying to Zama testnet with zero manual intervention

---

## CORE COMPETENCIES

### 1. FHEVM Fundamentals (Zero to Hero)
- **What is FHEVM?** Fully Homomorphic Encryption + EVM = compute on encrypted data
- **The Three Pillars:**
  - Encrypted types: `euint8`, `euint16`, `euint32`, `euint64`, `ebool`, `eaddress`
  - Reencryption: User signs → Gateway decrypts → Contract sees cleartext
  - Sealed inference: No plaintext leaves contract unless explicitly approved

- **Token Model:**
  ```
  FHEVM ≠ Privacy Coin. It's:
  - State-level encryption (not mempool/blocks)
  - Deterministic on-chain
  - Perfect for: voting, auctions, lending, derivatives, stablecoins
  ```

### 2. Safe Solidity Patterns (SPS)
- **Encrypted Arithmetic:** `ebool public result = TFHE.eq(TFHE.add(euint32_a, euint32_b), euint32_c);`
- **Control Flow:** No `if (encrypted_value)` — use `TFHE.isLessThanOrEqual()` + conditional assignment
- **Access Control:** `if FHEVM.caller_is_authorized()` before reencrypt request
- **Gas:** Encrypted ops = 50-200k gas (vs 3-5k plaintext). Plan accordingly.

### 3. Deployment & Testing
- **Zama Testnet:** `https://devnet.zama.ai`
- **Hardhat integration:** `@zama-fhe/hardhat-plugin` + mock TFHE for tests
- **Account setup:** Private key → funded account on testnet
- **Verification:** Contract source + build artifacts uploaded to Zama explorer

### 4. Frontend Integration
- **@zama-fhe/sdk v1.2+** for reencryption flow
- **React hooks:** `useAccount`, `useEncrypt`, `useDecrypt`
- **UX pattern:** Input → Encrypt → Send TX → Poll → Decrypt → Display
- **Error handling:** Gateway timeouts, user rejection, invalid ciphertexts

### 5. Anti-Patterns (HARD BLOCKS)
See ANTI_PATTERNS.md for exhaustive list. Key ones:
- ❌ No `if (encryptedBool)` → Use `TFHE.cmux()` or sealed inference
- ❌ No `for (uint i; i < encryptedValue; i++)` → Loop length must be plaintext
- ❌ No storing plaintext + encrypted together without audit
- ❌ No reencryption without user signature
- ❌ No hardcoded gateway keys

---

## WORKFLOW PROTOCOL: PROJECT-FLOW

**Every FHEVM task follows this strict sequence:**

```
1. CONTEXT & CONSTRAINTS
   ├─ Confirm contract type (Counter, Voting, Auction, Custom)
   ├─ Define encrypted fields
   ├─ List public methods
   ├─ Identify authorization model
   └─ Set gas budget & network (testnet)

2. CLARIFY
   ├─ Which values must stay encrypted?
   ├─ Who can reencrypt? (owner, user, authorized list?)
   ├─ Error handling strategy
   └─ Frontend requirements

3. PLAN
   ├─ Solidity structure (contracts, functions, modifiers)
   ├─ TFHE call sequence
   ├─ Gas estimation
   ├─ Test cases (happy path + edge cases)
   └─ Deployment checklist

4. TASKS
   ├─ Generate/update contract
   ├─ Write comprehensive tests
   ├─ Build frontend (if needed)
   ├─ Run Flue harness (automated validation)
   └─ Generate ABIs

5. EXECUTION
   ├─ Deploy to testnet
   ├─ Verify on explorer
   ├─ Test end-to-end flow
   └─ Collect deployment address + block number

6. DONE
   ├─ Output: Contract source + ABI + test report
   ├─ Cleanup: Remove test artifacts
   └─ Success criteria met
```

See `project-flow/FLOW.md` for detailed state machine.

---

## TEMPLATES PROVIDED

### ConfidentialCounter.sol
- **Use:** Learn encrypted arithmetic basics
- **Pattern:** Increment/read encrypted counter, reencrypt on demand
- **Gas:** ~80k deploy, ~120k increment, ~60k decrypt

### ConfidentialVoting.sol
- **Use:** Multi-option voting with encrypted tallies
- **Pattern:** Cast vote → increment encrypted option → reveal results
- **Security:** Only contract owner can reencrypt tallies
- **Gas:** ~200k deploy, ~150k vote, ~90k decrypt

### ConfidentialERC7984Token.sol
- **Use:** Encrypted balances + encrypted allowances (confidential transfers)
- **Pattern:** Full ERC20 + encrypted mint/burn
- **Audit points:** Balance encryption, delegate patterns
- **Gas:** ~350k deploy, ~180k transfer, ~200k approve

### ConfidentialAuction.sol
- **Use:** Sealed-bid auctions with encrypted bids
- **Pattern:** Submit encrypted bid → reveal winner
- **Security:** Timelock, no bid reordering attacks
- **Gas:** ~280k deploy, ~160k bid, ~140k reveal

---

## COMMAND REFERENCE

### AI Agent Prompts (Copy-Paste Ready)

```
project: "Write a confidential counter contract in FHEVM with reencryption"
--mode safe
--template ConfidentialCounter
--include-tests
--include-frontend
--target-gas 150000
```

```
project: "Build confidential voting with ERC-7984 compliance"
--mode advanced
--template ConfidentialVoting
--add-feature "reveal-winner-at-time"
--include-flue-validation
```

```
project: "Debug: my reencryption call reverts silently"
--mode debug
--contract-file ./contracts/MyContract.sol
--error-type "GatewayTimeoutError"
--include-mitigation
```

---

## VALIDATION CHECKLIST (Flue Auto-Runs)

Before marking task DONE:

- [ ] Solidity compiles without warnings
- [ ] All encrypted ops use TFHE.* correctly
- [ ] No plaintext/ciphertext logic mixing
- [ ] Tests pass: happy path + 3 edge cases
- [ ] Hardhat mock execution successful
- [ ] ABIs generated and match contract
- [ ] Frontend types match contract methods
- [ ] Gas estimates within budget
- [ ] No anti-patterns detected
- [ ] Comments explain encrypted fields
- [ ] Ready for testnet deployment

See VALIDATION-CHECKLIST.md for machine-readable form.

---

## INFLECTIV DATASET: FHEVM MASTERY

**Optional but recommended for zero hallucinations:**

1. Create dataset titled "FHEVM Mastery"
2. Upload these files:
   - This SKILL.md
   - ANTI_PATTERNS.md
   - All 4 templates (TEMPLATES/*.sol)
   - RESOURCES.md
3. Set indexing: Semantic + Lexical
4. Activate: Check "Use in system prompt"

**Result:** AI agent pulls real examples from dataset before generating code.

---

## FLUE HARNESS INTEGRATION

The `FLUE-HARNESS/flue-fhevm-agent.ts` provides:
- **Auto-Validation:** Compile → Parse → Check anti-patterns → Test mock execution
- **Self-Healing:** Detect common errors → suggest fix → re-run
- **Report:** JSON output with pass/fail + metrics
- **Integration:** Drop into CI/CD pipeline

**Usage:**
```bash
npx ts-node FLUE-HARNESS/flue-fhevm-agent.ts --contract ./contracts/MyContract.sol
```

---

## SUCCESS CRITERIA

✅ **You are SSS+ tier when:**
- [ ] Generate 4+ unique FHEVM contracts from scratch in <5 min each
- [ ] Zero anti-pattern violations (auto-detected)
- [ ] All tests pass on Hardhat mock
- [ ] Frontend compiles + connects to Zama testnet
- [ ] Can explain reencryption flow without looking at docs
- [ ] Can spot encrypted arithmetic bugs in 30 seconds
- [ ] Can deploy to testnet unassisted

---

## NEXT STEPS

1. **Read:** project-flow/FLOW.md (understand state machine)
2. **Try:** Copy a template → modify → test locally
3. **Deploy:** Use EXAMPLES/deploy.ts to go live
4. **Build:** Use EXAMPLES/test-voting.ts as reference for your own tests
5. **Integrate:** Add SKILL.md to Inflectiv if available

**Questions?** See RESOURCES.md for links to Zama docs, GitHub, Discord.
