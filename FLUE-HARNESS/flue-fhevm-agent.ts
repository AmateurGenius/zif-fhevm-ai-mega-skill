mkdir -p FLUE-HARNESS
cat > FLUE-HARNESS/flue-fhevm-agent.ts << 'EOF'
import { createAgent, Sandbox } from 'flue';
import fs from 'fs';

const skill = fs.readFileSync('../SKILL.md', 'utf-8');

export const fhevmAgent = createAgent({
  name: "ZamaFHEVMMegaAgent",
  systemPrompt: skill,
  tools: ["inflectiv:query", "hardhat:compile", "hardhat:test", "hardhat:deploy", "fhevm:encrypt", "git:commit"],
  sandbox: new Sandbox({ template: "zama-ai/fhevm-hardhat-template" }),
  workflow: {
    maxRetries: 3,
    onError: "query Inflectiv Zama dataset + self-heal using ANTI_PATTERNS.md"
  }
});

// Run example: npx flue run FLUE-HARNESS/flue-fhevm-agent.ts "Build a confidential voting contract with ERC-7984"
EOF
