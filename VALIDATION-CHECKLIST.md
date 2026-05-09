# VALIDATION-CHECKLIST: Machine-Readable Contract Verification

**For automated testing and code review. Flue harness runs this automatically.**

---

## COMPILATION & SYNTAX

```json
{
  "checks": [
    {
      "id": "compile-no-errors",
      "description": "Solidity compiles without errors",
      "command": "npx hardhat compile",
      "expected": "exit code 0",
      "tags": ["critical", "build"]
    },
    {
      "id": "compile-no-warnings",
      "description": "Solidity compiles without warnings",
      "command": "npx hardhat compile",
      "expected": "no warnings in stderr",
      "tags": ["warning", "build"],
      "severity": "medium"
    }
  ]
}
```

---

## ANTI-PATTERNS DETECTION

```json
{
  "anti_patterns": [
    {
      "id": "A1-if-on-encrypted",
      "name": "If statement on encrypted value",
      "severity": "critical",
      "fix": "Use TFHE.cmux() or sealed inference"
    },
    {
      "id": "A2-loop-encrypted",
      "name": "Loop over encrypted value",
      "severity": "critical",
      "fix": "Loop over plaintext, use encrypted inside"
    },
    {
      "id": "B1-mixed-arithmetic",
      "name": "Mixed plaintext + encrypted in TFHE op",
      "severity": "critical",
      "fix": "Cast to encrypted type first: TFHE.asEuint*()"
    },
    {
      "id": "C1-reencrypt-unauth",
      "name": "Reencryption without authorization check",
      "severity": "critical",
      "fix": "Add require(msg.sender == authorized) before reencrypt"
    },
    {
      "id": "C2-hardcoded-gateway",
      "name": "Hardcoded gateway public key",
      "severity": "high",
      "fix": "Use contract state variable, updatable by owner"
    }
  ]
}
```

---

## CODE QUALITY CHECKS

```json
{
  "code_quality": [
    {
      "id": "functions-have-comments",
      "description": "All public functions have explanatory comments",
      "severity": "medium"
    },
    {
      "id": "encrypted-fields-marked",
      "description": "All encrypted fields have // encrypted comment",
      "severity": "high"
    },
    {
      "id": "events-logged",
      "description": "State changes emit events",
      "severity": "medium"
    },
    {
      "id": "access-control",
      "description": "Sensitive functions have access modifiers",
      "severity": "high"
    }
  ]
}
```

---

## TEST COVERAGE

```json
{
  "testing": [
    {
      "id": "test-file-exists",
      "description": "Test file exists for each contract",
      "required": true,
      "severity": "high"
    },
    {
      "id": "test-happy-path",
      "description": "At least one test for happy path",
      "min_matches": 1,
      "severity": "high"
    },
    {
      "id": "test-edge-cases",
      "description": "Tests for edge cases (zero, max, min)",
      "min_matches": 3,
      "severity": "medium"
    },
    {
      "id": "test-error-cases",
      "description": "Tests for error conditions",
      "min_matches": 1,
      "severity": "medium"
    },
    {
      "id": "test-coverage-threshold",
      "description": "Code coverage >= 80%",
      "threshold": 80,
      "severity": "medium"
    }
  ]
}
```

---

## DEPLOYMENT & CONFIGURATION

```json
{
  "deployment": [
    {
      "id": "hardhat-config-exists",
      "description": "hardhat.config.ts exists and has Zama network",
      "required": true,
      "severity": "critical"
    },
    {
      "id": "no-private-keys-in-config",
      "description": "No private keys hardcoded in config files",
      "severity": "critical"
    },
    {
      "id": "env-variables-used",
      "description": "Secrets loaded from environment variables",
      "severity": "high"
    },
    {
      "id": "env-example-exists",
      "description": ".env.example file documents required variables",
      "required": true,
      "severity": "medium"
    },
    {
      "id": "deploy-script-exists",
      "description": "Deploy script included (scripts/deploy.ts)",
      "required": true,
      "severity": "high"
    }
  ]
}
```

---

## SECURITY CHECKS

```json
{
  "security": [
    {
      "id": "no-reentrancy",
      "description": "No obvious reentrancy vulnerabilities",
      "severity": "critical"
    },
    {
      "id": "overflow-protected",
      "description": "Arithmetic protected against overflow/underflow",
      "severity": "high"
    },
    {
      "id": "authorization-checked",
      "description": "Sensitive functions require authorization",
      "severity": "critical"
    }
  ]
}
```

---

## EXPECTED OUTPUT

```json
{
  "timestamp": "2026-05-09T14:30:00Z",
  "contract": "ConfidentialVoting.sol",
  "result": "PASS",
  "summary": {
    "total_checks": 52,
    "passed": 52,
    "failed": 0,
    "warnings": 0
  },
  "ready_for_testnet": true,
  "deployment_gas_estimate": 245000,
  "notes": "All checks passed. Ready for Zama testnet deployment."
}
```

---

**Last Updated:** May 2026
