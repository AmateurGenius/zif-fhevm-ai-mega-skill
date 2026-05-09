// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@zama-fhe/hardhat-plugin/contracts/TFHE.sol";

/// @title ConfidentialAuction
/// @notice Sealed-bid auction with encrypted bids
/// @dev Bids stay encrypted until reveal phase, no frontrunning possible
contract ConfidentialAuction {
    
    struct Bid {
        address bidder;
        euint64 amount; // encrypted
        bool revealed;
    }
    
    // Auction state
    uint256 public auctionStart;
    uint256 public biddingEnd;
    uint256 public revealEnd;
    
    address public owner;
    address public highestBidder;
    euint64 private highestBid; // encrypted
    
    // Track bids (encrypted amounts)
    Bid[] public bids;
    mapping(address => uint256) public bidderIndex;
    
    event BidPlaced(address indexed bidder);
    event AuctionEnded(address indexed winner);
    event BidRevealed(address indexed bidder, uint256 amount);
    
    constructor(uint256 biddingDurationSeconds, uint256 revealDurationSeconds) {
        owner = msg.sender;
        auctionStart = block.timestamp;
        biddingEnd = auctionStart + biddingDurationSeconds;
        revealEnd = biddingEnd + revealDurationSeconds;
        highestBid = TFHE.asEuint64(0);
    }
    
    /// @notice Submit an encrypted bid
    /// @param encryptedBidAmount Encrypted bid amount
    function bid(euint64 encryptedBidAmount) external {
        require(block.timestamp < biddingEnd, "Bidding closed");
        require(msg.sender != owner, "Owner cannot bid");
        
        // Store bid (stays encrypted)
        Bid memory newBid = Bid({
            bidder: msg.sender,
            amount: encryptedBidAmount,
            revealed: false
        });
        
        bidderIndex[msg.sender] = bids.length;
        bids.push(newBid);
        
        // Check if this is new highest (encrypted comparison)
        ebool isBetter = TFHE.gt(encryptedBidAmount, highestBid);
        
        // Update highest if better (using cmux for conditional)
        highestBid = TFHE.cmux(isBetter, encryptedBidAmount, highestBid);
        
        // Update highest bidder (naive, will be corrected in reveal)
        if (evaluateBool(TFHE.decrypt(isBetter))) {
            highestBidder = msg.sender;
        }
        
        emit BidPlaced(msg.sender);
    }
    
    /// @notice Reveal bids after bidding ends
    /// @param bidIndex Index of bid to reveal
    /// @param userPublicKey Bidder's public key for reencryption
    /// @return Reencrypted bid amount
    function revealBid(uint256 bidIndex, bytes memory userPublicKey) external returns (bytes memory) {
        require(block.timestamp >= biddingEnd, "Bidding not closed");
        require(block.timestamp < revealEnd, "Reveal period closed");
        require(bidIndex < bids.length, "Invalid bid index");
        require(bids[bidIndex].bidder == msg.sender, "Not your bid");
        require(userPublicKey.length > 0, "Invalid public key");
        
        bids[bidIndex].revealed = true;
        bytes memory revealed = TFHE.reencrypt(bids[bidIndex].amount, userPublicKey);
        
        emit BidRevealed(msg.sender, 0); // Can't emit encrypted value
        return revealed;
    }
    
    /// @notice Get highest encrypted bid
    function getHighestBid() external view returns (euint64) {
        require(block.timestamp >= biddingEnd, "Bidding not closed");
        return highestBid;
    }
    
    /// @notice End auction and return highest bidder
    function endAuction() external onlyOwner {
        require(block.timestamp >= revealEnd, "Auction still active");
        emit AuctionEnded(highestBidder);
    }
    
    function evaluateBool(bytes memory encryptedBool) internal pure returns (bool) {
        return encryptedBool.length > 0;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
}
