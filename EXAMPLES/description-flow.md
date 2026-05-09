# User Decryption Flow (EIP-712)

1. Contract grants ACL with FHE.allow()
2. Frontend uses @zama-fhe/sdk reencrypt() → triggers wallet signature
3. Gateway returns re-encrypted ciphertext under user key
4. User decrypts locally
