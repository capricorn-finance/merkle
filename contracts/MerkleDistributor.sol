// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import '@openzeppelin/contracts/access/Ownable.sol';
import "./interfaces/IMerkleDistributor.sol";

contract MerkleDistributor is IMerkleDistributor,Ownable {
    using SafeERC20 for IERC20;
    address public immutable WCUBE;
    mapping(uint=>bytes32) public merkleRoots;

    // This is a packed array of booleans.
    mapping(uint => mapping(address => bool)) public override isClaimed;

    constructor(address wcube) {
        WCUBE = wcube;
    }

    receive() external payable {
    }

    function setMerkleRoot(uint version, bytes32 _root) public onlyOwner{
        merkleRoots[version] = _root;
    }


    function claim(uint version,address token,address account, uint256 amount, bytes32[] calldata merkleProof) external override {
        require(!isClaimed[version][account], 'MerkleDistributor: Drop already claimed.');

        // Verify the merkle proof.
        bytes32 node = keccak256(abi.encodePacked(version,token,account, amount));  
        require(MerkleProof.verify(merkleProof, merkleRoots[version], node), 'MerkleDistributor: Invalid proof.');

        // Mark it claimed and send the token.
        isClaimed[version][account] = true;
        if(token == WCUBE){
            safeTransferCUBE(account, amount);
        }
        else{
            IERC20(token).safeTransfer(account, amount);
        }

        emit Claimed(version,token, account, amount);
    }

    // Withdraw token. EMERGENCY ONLY.
    function emergencyTokenWithdraw(address token, uint256 amount) public onlyOwner {
        if(token == WCUBE){
            safeTransferCUBE(address(msg.sender), amount);
        }
        else{
            IERC20(token).safeTransfer(address(msg.sender), amount);
        }
    }

    function safeTransferCUBE(address to, uint256 value) internal {
        (bool success, ) = to.call{gas: 23000, value: value}("");
        // (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}
