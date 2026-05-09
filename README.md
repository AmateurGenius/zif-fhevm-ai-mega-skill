# ZIF FHEVM AI Mega Skill

**SSS+ Tier – The Complete AI-Native Development Blueprint for Confidential Smart Contracts on Zama FHEVM**

One single drop-in skill that instantly transforms **any** AI coding agent (Claude Code, Cursor, Windsurf, Flue, etc.) into a world-class expert capable of producing production-grade confidential smart contracts.

No more digging through documentation. No more hallucinations on ACL rules, input proofs, or gas-optimized patterns. Just natural language prompts → fully working, secure, and tested FHEVM code.

### The Complete Stack – What Each Layer Brings

Z-I-F stands for ZAMA-INFLECTIVE-FLUE

## 1. ZIF Skill Engine (`SKILL.md`)
- The **core brain** of the system.
- Contains perfect, up-to-date (May 2026) knowledge of FHEVM architecture, encrypted types, FHE operations, ACL patterns, input proofs, EIP-712 decryption, ERC-7984 integration, and anti-patterns.
- Provides strict guardrails ("NEVER BREAK THESE RULES") that prevent the most common FHEVM mistakes (missing `FHE.allowThis()`, using `view` on encrypted data, wrong input proofs, etc.).
- Defines consistent output format so every response is complete and production-ready.

#### 2. Project-Flow Protocol (`project-flow/` folder)
- Adds **agent discipline** and structured reasoning.
- Enforces the strict workflow: **Context → Clarify → Plan → Tasks → Execution → DONE**.
- Prevents premature code generation and forces the AI to ask clarifying questions, create a locked plan, and validate against checklists before writing any Solidity.
- Makes the agent significantly more reliable and auditable.

#### 3. Flue Harness (`FLUE-HARNESS/flue-fhevm-agent.ts`)
- Provides **autonomous execution capability**.
- Runs the AI inside a real sandboxed environment with Hardhat, compilation, testing, and deployment tools.
- Enables self-healing loops (up to 3 retries using ANTI_PATTERNS.md + Inflectiv).
- Turns passive code generation into active, verifiable dApp creation.

#### 4. Inflectiv Knowledge Layer
- The **structured memory** layer.
- Turns all your raw documentation, templates, and rules into a tokenized, queryable dataset on app.inflectiv.ai.
- Guarantees near-zero hallucinations by forcing the agent to query authoritative knowledge before every code generation.
- Creates a persistent, reusable intelligence base that improves over time.

### What Emerges When All Layers Work Together

A **complete AI-native confidential development environment** where:

- You describe a confidential application in plain English.
- The agent follows Project-Flow discipline.
- It queries Inflectiv for perfect FHEVM knowledge.
- It generates code using the ZIF Skill rules and templates.
- Flue autonomously compiles, tests, and deploys in a sandbox.
- You receive production-grade contracts + frontend + tests + deployment scripts.

**Result**: From idea to working confidential dApp in minutes instead of days — with correct ACLs, input proofs, gas optimization, and security patterns every single time.

### Quick Start (Under 60 Seconds)

1. Clone or download this repository.
2. Drop **SKILL.md** + the entire **`project-flow/`** folder into your AI coding tool (Cursor, Claude Code, Windsurf, etc.).
3. (Strongly recommended) Create an **Inflectiv dataset** named "FHEVM Mastery" and upload the `TEMPLATES/`, `SKILL.md`, and `ANTI_PATTERNS.md` folders.
4. Use a Project-Flow enabled prompt:
project: "Build a confidential voting dApp with ERC-7984 token integration and React frontend" --mode safe

The agent automatically follows the full disciplined workflow and delivers everything you need on the spot.

### Included Production Assets

- **TEMPLATES/** — 4 battle-tested contracts:
  - `ConfidentialCounter.sol` — Simple encrypted counter
  - `ConfidentialVoting.sol` — Multi-option encrypted voting with ACL
  - `ConfidentialERC7984Token.sol` — Full OpenZeppelin confidential token
  - `ConfidentialAuction.sol` — Sealed-bid encrypted auction

- **TEMPLATES/ReactFrontend.tsx** — Complete wagmi + @zama-fhe/sdk v3 frontend with encrypted input generation and EIP-712 decryption.

- **EXAMPLES/** — Hardhat config, tests, deployment scripts, and decryption guides.

- **ABIS/** — Ready-to-use contract ABIs for frontend integration.

- **ANTI_PATTERNS.md** — 20+ common FHEVM mistakes and how to avoid them.

- **FLUE-HARNESS/** — Autonomous agent configuration.

- **.github/workflows/ci-test.yml** — Full GitHub Actions pipeline.

### Why This Is SSS+ Tier

- **Accuracy** — Perfect alignment with May 2026 Zama + OpenZeppelin standards.
- **Agent Effectiveness** — Structured workflow + structured knowledge = reliable output.
- **Completeness** — Full end-to-end workflow (contract → test → deploy → frontend).
- **Error Prevention** — Multiple layered guardrails.
- **Future-Proof** — Easily extensible as new Zama tools emerge.

Enjoy building confidential dapps using natural language, go from idea to product with this ZIF Mega Skill.
