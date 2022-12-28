pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract BortoToken is ERC20 {
    uint256 private _totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor(uint256 initialSupply) ERC20("Borto Token", "BRT"){
        _mint(msg.sender, initialSupply);
    }

    function decimals() public override view returns(uint8){
        return 6;
    }

    function totalSupply() public override view returns(uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public override view returns(uint256){
        return _balances[_owner];
    }

    function transfer(address recipient, uint256 amount) public override returns(bool){
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns(bool){
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exeeds allowance");

        _transfer(sender, recipient, amount);
        _approve(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns(bool){
        _approve(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public override returns(bool){
        _approve(msg.sender, spender, _allowances[msg.sender][spender] += addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractValue) public override returns(bool){
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractValue, "ERC20: decreased allowance below zero");

        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractValue);
        }

        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal override {
        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: trsnfer amount exeeds balance");

        unchecked {
            _balances[sender] = senderBalance - amount;
        }

        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal override {
        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }
}
