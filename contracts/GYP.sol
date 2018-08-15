pragma solidity ^0.4.23;

import "./GYPTransfer.sol";
import "./PullPayment.sol";
import "./RMBToken.sol";

// @title 公益合约
contract GYP is GYPTransfer{

  // @dev 构造函数，初始化合约数据
  constructor(
    uint256 _limit,
    string _description,
    string _url,
    string _name,
    string _ipfsHash
    )
    public
  {
    // 如果_limit输入为0，代表合约金额无上限
    require(uint256(_limit) == limit);
    limit = _limit;
    if(limit == 0) {
      limit = 1 >> 255;
    }

    description = _description;           // 一些文本数据
    url = _url;             // 相关网址
    name = _name;           // 项目或者受助者名称
    ipfsHash = _ipfsHash;   // 保存在ipfs的数据文件
    timeStamp = now;        // 项目发起时间
    rmbToken = RMBToken(0); // ========= 部署的主网合约地址 =========

  }

  // @dev 修改合约网址时的事件
  event NewUrl(string _oldUrl, string _newUrl);
  // @dev 修改合约限制时的事件
  event NewLimit(uint256 _oldLimit, uint256 _newLimit);
  // @dev 修改合约说明的事件
  event NewDescription(string _oldDescription, string _newDescription);


  // @dev 提取合约金额，只有合约拥有者才能调用
  function WithdrawByOwner(
    address _to,
    uint256 _amount,
    string _name,
    string _data,
    string _url
    )
      external
      onlyOwner
      whenNotPaused
      returns(bool)
  {
    require(uint256(_amount) == _amount);
    require(_to != address(0));
    require(_amount <= address(this).balance);
    TransactionData memory transactionData = TransactionData(_name, _to, _amount, now, _data, _url);
    bool res = _transfer(_to, _amount, transactionData);
    require(res == true);
  }

  // @dev 提取合约金额，只有ceo能调用
  // @notice 只有在合约拥有者忘记私钥或者合约拥有者存在违规时候才能调用
  function WithdrawByCEO(
    address _to,
    uint256 _amount,
    string _name,
    string _data,
    string _url
    )
      external
      onlyCEO
      returns(bool)
  {
    require(uint256(_amount) == _amount);
    require(_to != address(0));
    require(_amount <= address(this).balance);
    TransactionData memory transactionData = TransactionData(_name, _to, _amount, now, _data, _url);
    bool res = _transfer(_to, _amount, transactionData);
    require(res == true);
  }

  // @dev 重新设置合约相关网址说明
  function setUrl(string _url) external onlyCLevel {
    string storage oldUrl = url;
    url = _url;
    emit NewUrl(oldUrl, url);
  }

  // @dev 修改合约说明
  function setDescription(string _description) external onlyCLevel {
    string storage oldDescription = description;
    description = _description;
    emit NewDescription(oldDescription, description);
  }

  // @dev 修改合约限制
  function setLimit(uint256 _limit) external onlyCLevel {
    require(uint256(_limit) == _limit);
    uint256 oldLimit = limit;
    limit = _limit;
    emit NewLimit(oldLimit, limit);
  }

  // @dev 开启合约提供功能
  function Pause()
    external
    whenNotPaused
    onlyCLevel
  {
    super.pause();
  }

  // @dev 暂停合约提现功能
  function unPause() external whenPaused onlyCLevel {
    super.unpause();
  }

  // @dev 获取合约金额
  function getBalance() external view returns(uint256) {
    return address(this).balance;
  }
}
