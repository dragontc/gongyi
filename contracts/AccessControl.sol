pragma solidity ^0.4.24;


// @dev 权限控制合约，能够控制合约的流通和合约的销毁等一系列操作
contract AccessControl {
    address public ceoAddress;
    address public cfoAddress;
    address public cooAddress;

    // @dev 控制合约的提现功能
    bool public paused = false;

    /// @dev 只有ceo能调用
    modifier onlyCEO() {
        require(msg.sender == ceoAddress);
        _;
    }

    /// @dev 只有cfo能调用
    modifier onlyCFO() {
        require(msg.sender == cfoAddress);
        _;
    }

    /// @dev 只有coo能调用
    modifier onlyCOO() {
        require(msg.sender == cooAddress);
        _;
    }

    // @dev 只有ceo,cfo,coo能调用
    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress
        );
        _;
    }

    /// @dev 重新设置ceo地址
    function setCEO(address _newCEO) external onlyCEO {
        require(_newCEO != address(0));

        ceoAddress = _newCEO;
    }

    /// @dev 重新设置cfo地址
    function setCFO(address _newCFO) external onlyCEO {
        require(_newCFO != address(0));

        cfoAddress = _newCFO;
    }

    /// @dev 重新设置coo地址
    function setCOO(address _newCOO) external onlyCEO {
        require(_newCOO != address(0));

        cooAddress = _newCOO;
    }

    /// @dev 合约是否允许提现
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /// @dev 合约是否暂停提现操作
    modifier whenPaused {
        require(paused);
        _;
    }

    /// @dev 暂停合约所有者的提现功能
    function pause() internal {
        paused = true;
    }

    /// @dev 允许合约所有者的提现功能
    function unpause() internal {
        paused = false;
    }
}
