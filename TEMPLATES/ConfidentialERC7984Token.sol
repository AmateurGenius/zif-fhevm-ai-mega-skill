// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { ERC7984 } from "@openzeppelin/confidential-contracts/token/ERC7984/ERC7984.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { ZamaEthereumConfig } from "@fhevm/solidity/config/ZamaConfig.sol";
import { FHE, euint64, externalEuint64 } from "@fhevm/solidity/lib/FHE.sol";

contract ConfidentialERC7984Token is ERC7984, Ownable2Step, ZamaEthereumConfig {
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10**18;
    euint64 private encryptedTotalSupply;

    event ConfidentialMinted(address to, bytes32 handle);
    event ConfidentialBurned(address from, bytes32 handle);

    constructor(
        string memory name,
        string memory symbol,
        string memory uri
    ) ERC7984(name, symbol, uri) Ownable2Step() {
        encryptedTotalSupply = FHE.asEuint64(1_000_000 * 10**18);
        FHE.allowThis(encryptedTotalSupply);
    }

    function confidentialMint(
        address to,
        externalEuint64 encryptedAmount,
        bytes calldata inputProof
    ) external onlyOwner {
        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);
        
        ebool noOverflow = FHE.le(
            FHE.add(encryptedTotalSupply, amount),
            FHE.asEuint64(MAX_SUPPLY)
        );
        
        encryptedTotalSupply = FHE.select(noOverflow, 
            FHE.add(encryptedTotalSupply, amount), 
            encryptedTotalSupply
        );

        _mint(to, amount);
        FHE.allowThis(amount);

        emit ConfidentialMinted(to, euint64.unwrap(amount));
    }

    function confidentialTransfer(
        address to,
        externalEuint64 encryptedAmount,
        bytes calldata inputProof
    ) external {
        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);
        FHE.allowTransient(amount, address(this));

        _transfer(msg.sender, to, amount);
    }

    function confidentialBurn(
        address from,
        externalEuint64 encryptedAmount,
        bytes calldata inputProof
    ) external onlyOwner {
        euint64 amount = FHE.fromExternal(encryptedAmount, inputProof);
        _burn(from, amount);
        encryptedTotalSupply = FHE.sub(encryptedTotalSupply, amount);
        FHE.allowThis(encryptedTotalSupply);

        emit ConfidentialBurned(from, euint64.unwrap(amount));
    }

    function getEncryptedTotalSupply() external view returns (euint64) {
        return encryptedTotalSupply;
    }
}
