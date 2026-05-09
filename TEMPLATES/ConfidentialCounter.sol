// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { FHE, euint64, externalEuint64 } from "@fhevm/solidity/lib/FHE.sol";
import { ZamaEthereumConfig } from "@fhevm/solidity/config/ZamaConfig.sol";

contract ConfidentialCounter is ZamaEthereumConfig {
    euint64 private counter;

    event CounterIncremented(bytes32 handle);

    constructor() {
        counter = FHE.asEuint64(0);
        FHE.allowThis(counter);
    }

    function increment(externalEuint64 encryptedAmount, bytes calldata inputProof) external {
        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);
        counter = FHE.add(counter, amount);
        FHE.allowThis(counter);
        emit CounterIncremented(euint64.unwrap(counter));
    }

    function getEncryptedCounter() external view returns (euint64) {
        return counter;
    }

    function makePublic() external {
        FHE.makePubliclyDecryptable(counter);
    }
}
