pragma experimental ABIEncoderV2;
pragma solidity ^0.4.24;

import "./GYPBase.sol";
import "./AccessControl.sol";
import "./RMBToken.sol";

contract GYPTransfer is GYPBase, AccessControl{

  // @dev rmb代币地址
  RMBToken rmbToken;

  // @dev 交易的相关信息
  struct TransactionData{
    string name;        // 转出名称（项目名称或者受助者名字）
    address to;         // 转出地址
    uint256 amount;     // 转出金额
    uint256 timeStamp;  // 转账时间
    string data;        // 转出说明
    string url;         // 附加网址
  }

  TransactionData[] data;   // 合约所有交易数据
  mapping (address => uint256) addressToAmount; // 某个地址对应的捐献金额
  mapping (address => uint256) addressToTimes;  // 与某个地址的转账次数

  // 每次转账的时候都会触发该事件
  event Transfer(address _from, address _to, uint256 _amount, TransactionData _data);

  // @dev 转账功能
  // @param 转出地址，转出金额，转出说明
  // @return 转账是否成功
  function _transfer(address _to, uint256 _amount, TransactionData _data) internal returns(bool){
    bool res = rmbToken.transfer(_to, _amount);
    if (res == true) {
      data.push(_data);
      emit Transfer(msg.sender, _to, _amount, _data);
      return true;
    }

    addressToTimes[_to]++;

    return false;
  }

  // @dev 每个地址对应的转出金额
  function _addAmount(address _to, uint256 _amount) internal view {
    addressToAmount[_to].add(_amount);
  }

  // @dev 当某个地址回退金额时,删除映射
  function _subAmount(address _to) internal{
    require(_to != address(0));
    delete addressToAmount[_to];
  }

  // @ dev 设置token地址
  // @ notice 自动初始化，或者ceo调用
  function _setTokenAddress(address _rmbAddr) internal {
    require(_rmbAddr != address(0));
    rmbToken = RMBToken(_rmbAddr);
  }

  // @dev 返回某个地址对应的捐献金额
  function getAmount() external view returns(uint256) {
    return addressToAmount[msg.sender];
  }

  /*
  // @dev 获取某个地址对于的交易id
  function getIdByAddress(address _to) internal view returns(uint256[]) {
    uint256[] memory ID = new uint256[](addressToTimes[_to]);
    uint pos = 0;
    for (uint256 i = 0; i < data.length; i++) {
     if (data[i].to == _to) {
       ID[pos++] = i;
     }
    }
    return ID;
  }

  // @dev 通过ID获取某笔交易数据
  function getTransactionById(uint256 _id) internal view returns(TransactionData) {
    require(_id < data.length);
    return data[_id];
  }
  */

  // @dev 通过某个地址获取相关的转账信息
  function getTransactionByAddress(address _addr)
    external
    view
    returns(TransactionData[])
    {
      TransactionData[] memory tmpData = new TransactionData[](addressToTimes[_addr]);
      uint256 pos = 0;
      for (uint256 i = 0; i < data.length; i++) {
        if (data[i].to == _addr) {
          tmpData[pos++] = data[i];
        }
    }
    return tmpData;
  }

  // @dev 获取合约所有转账信息
  function getTransactions() external view returns(TransactionData[]) {
    return data;
  }

}
