pragma solidity ^0.4.23;

import "./Ownable.sol";
import "./SafeMath.sol";

// @dev 定额数据合约
// @dev 合约保存了用户项目的相关信息
contract GYPBase is Ownable {

  using SafeMath for uint256;

  uint256 public limit;     // 捐献总额
  string public description;       // 相关说明
  string public url;        // 相关网址
  string public ipfsHash;   // 相关数据
  string public name;       // 发起人的姓名
  uint256 public timeStamp; // 合约创建时间

  event ReachLimit(uint256 _balance, uint256 _timeStamp);

  // 重新设置合约拥有者
  function _setOwner(address _newOwner) internal {
    super.transferOwnership(_newOwner);
  }


  // 重新设置项目网址
  function _setUrl(string _url) internal {
    url = _url;
  }

  // 获取合约数据
  function getContractInfo()
    external
    view
    returns(
      uint256,
      string,
      string,
      string,
      string,
      uint256
    )
  {
    return (limit, description, url, ipfsHash, name, timeStamp);
  }
}
