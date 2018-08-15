pragma solidity ^0.4.24;


// @dev 所有者合约，提供了所有者的证明
contract Ownable {

  address public owner;

  // @dev 在构造函数初始化合约所有者
  constructor() public {
    owner = msg.sender;
  }


  // @dev只有合约所有者可以调用，其他人调用会throw
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  // @dev 允许当前所有者转移合约控制权
  function transferOwnership(address newOwner) public onlyOwner {
    if (newOwner != address(0)) {
      owner = newOwner;
    }
  }

}
