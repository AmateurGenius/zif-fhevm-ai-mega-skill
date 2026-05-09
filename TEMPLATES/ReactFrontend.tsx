'use client';

import React, { useState, useEffect } from 'react';
import { useAccount, useWriteContract, useWalletClient } from 'wagmi';
import { RainbowKitProvider, ConnectButton } from '@rainbow-me/rainbowkit';
import { createEncryptedInput, getFhevmInstance, reencrypt } from '@zama-fhe/sdk';
import { parseEther } from 'viem';
import type { Address } from 'viem';

const VOTING_ADDRESS = '0x...' as Address;   // Replace after deployment
const TOKEN_ADDRESS = '0x...' as Address;

export default function ZIFConfidentialDApp() {
  const { address, isConnected } = useAccount();
  const { data: walletClient } = useWalletClient();
  const { writeContract } = useWriteContract();

  const [voteOption, setVoteOption] = useState(1);
  const [transferAmount, setTransferAmount] = useState("1000");
  const [decryptedTally, setDecryptedTally] = useState<Record<number, bigint>>({});
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (isConnected) getFhevmInstance();
  }, [isConnected]);

  const castEncryptedVote = async () => {
    if (!address || !walletClient) return;
    setLoading(true);

    try {
      const input = await createEncryptedInput(VOTING_ADDRESS, address);
      input.add64(BigInt(voteOption));
      const { ciphertexts, proof } = await input.generateProof();

      await writeContract({
        address: VOTING_ADDRESS,
        functionName: 'castVote',
        args: [ciphertexts[0], proof],
      });

      alert('✅ Encrypted vote cast successfully!');
    } catch (error) {
      console.error(error);
      alert('❌ Error casting vote');
    } finally {
      setLoading(false);
    }
  };

  const decryptTally = async (option: number) => {
    // Implement reencrypt + decryption flow here (EIP-712)
    alert('Decryption flow triggered (EIP-712)');
  };

  return (
    <RainbowKitProvider>
      <div className="max-w-2xl mx-auto p-8">
        <h1 className="text-4xl font-bold mb-8 text-center">ZIF Confidential dApp</h1>
        <ConnectButton />

        {isConnected && (
          <>
            <div className="mt-12 border p-6 rounded-2xl">
              <h2 className="text-2xl mb-4">Confidential Voting</h2>
              <select value={voteOption} onChange={(e) => setVoteOption(Number(e.target.value))} className="w-full p-3 border rounded-xl mb-4">
                <option value={1}>Yes</option>
                <option value={0}>No</option>
              </select>
              <button 
                onClick={castEncryptedVote} 
                disabled={loading}
                className="w-full bg-blue-600 text-white py-4 rounded-2xl font-semibold"
              >
                {loading ? 'Casting Encrypted Vote...' : 'Cast Encrypted Vote'}
              </button>
              <button onClick={() => decryptTally(1)} className="mt-4 w-full border py-3 rounded-2xl">
                Decrypt Tally
              </button>
            </div>

            <div className="mt-8 text-xs text-gray-500 text-center">
              Powered by ZIF Mega Skill • Project-Flow • Flue • Inflectiv
            </div>
          </>
        )}
      </div>
    </RainbowKitProvider>
  );
    }
