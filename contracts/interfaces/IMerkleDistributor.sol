// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0;

// Allows anyone to claim a token if they exist in a merkle root.
interface IMerkleDistributor {

    // Returns true if the index has been marked claimed.
    function isClaimed(uint version,address addr) external view returns (bool);
    // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
    function claim(uint version,address token, address account, uint256 amount, bytes32[] calldata merkleProof) external;

    // This event is triggered whenever a call to #claim succeeds.
    event Claimed(uint version,address token, address account, uint256 amount);
}
