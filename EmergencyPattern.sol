// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

/* @dev writes this function to deposit but we are able to pause or unpause
 * some situations like a big bug we need to suspend the system to prevent the risks
 */
contract Deposit{
    // defined the owner
    address public owner;
    bool paused = false; // at the beginning it's false
    mapping(address => uint) balances;

    // modifier
    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }
    modifier whenPaused(){
        require(paused);
        _;
    }
    modifier whenNotPaused(){
        require(!paused);
        _;
    }
    // define the owner with first msg.sender who deployed this contract
    constructor() public{
        owner = msg.sender;
    }
    function pause() public onlyOwner whenPaused{
        paused = true; // if we try this paused is true
    }
    function unPause() public onlyOwner whenNotPaused{
        paused = false;
    }
    function deposit() public payable whenNotPaused{
        // Ether deposit logic here
        uint amount = balances[msg.sender];
        // reset balances of sender
        balances[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
    // if any emergency then transfer all balance to the owner address
    function emergencyWithdraw() public onlyOwner whenPaused{
        payable(owner).transfer(address(this).balance);
    }

}