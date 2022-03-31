// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBEP20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract LaqiraTokenFaucet {
    address private owner;
    address private laqiraTokenAddress;
    uint256 private withdrawalAmount;
    mapping(address => uint256) private withdrawTimestamp;
    
    constructor(address _laqiraToken) {
        owner = msg.sender;
        laqiraTokenAddress = _laqiraToken;
        withdrawalAmount = 10000000000000000000000;
    }

    function setWithdrawalAmount(uint256 _amount) public onlyOwner {
        withdrawalAmount = _amount;
    }

    function getWithdrawalAmount() public view returns (uint256) {
        return withdrawalAmount;
    }

    function transferAnyBEP20() public returns (bool) {
        require(block.timestamp - withdrawTimestamp[msg.sender] > 1 days, 'You have reached daily withdrawal limit');
        IBEP20(laqiraTokenAddress).transfer(msg.sender, withdrawalAmount);
        withdrawTimestamp[msg.sender] = block.timestamp;
        return true;
    }

    function getLaqiraTokenAddress() public view returns (address) {
        return laqiraTokenAddress;
    }

    function getUserTimestamp() public view returns (uint256) {
        return withdrawTimestamp[msg.sender];
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}