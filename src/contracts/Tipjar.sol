//SPDX-License-Identifier: GPL-3.0

pragma  solidity ^0.8.4;

import 'hardhat/console.sol';

contract TipJar {
  uint public totalTips;

  address payable owner;

  

  struct Tip {
    address sender;
    string message;
    string name;
    uint256 timestamp;
    uint256 amount;
  }

  Tip[] tips;

  event NewTip (address indexed from, uint amount, string message, string name, uint timestamp);
  event NewWithdrawal (uint amount);

  constructor() {
    owner = payable(msg.sender);
  }

  // Functions

	/*
	 * public funtion (like a getter) that returns the total number of tips
	 * is marked as public and as a view, meaning that only reads from the blockchain so is gas free
	 * In a function you should declare what it returns
	 */
	function getTotalTips() public view returns (uint256) {
		return totalTips;
	}

  function sendTip(string memory _message, string memory _name) public payable {
    require(msg.sender.balance >= msg.value, 'Insufficient funds');
    
    totalTips += 1;
    tips.push(Tip(msg.sender, _message, _name, block.timestamp, msg.value));
    emit NewTip(msg.sender, msg.value, _message, _name, msg.value);
  }

  function getAllTips() public view returns (Tip[] memory) {
    return tips;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'You are not the owner');
    _;
  }

  function withdraw() public onlyOwner{
    uint amount = address(this).balance;
    require(amount > 0, 'Insufficient funds');
    (bool success, ) = owner.call{value: amount}('');
    require(success, 'Failed to withdraw');
    emit NewWithdrawal(amount);
  }
}