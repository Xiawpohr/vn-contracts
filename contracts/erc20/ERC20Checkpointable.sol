// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "./ERC20.sol";
import "../utils/SafeMath.sol";
import "../utils/Checkpointing.sol";


abstract contract ERC20Checkpointable is ERC20 {
    using SafeMath for uint256;
    using Checkpointing for Checkpointing.History;

    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => Checkpointing.History) private _balancesHistory;
    
    Checkpointing.History private _totalSupplyHistory;

    struct Checkpoint {
        uint256 time;
        uint256 value;
    }

    struct History {
        Checkpoint[] history;
    }

    function balanceOf(address _owner) public view override returns (uint256) {
        return balanceOfAt(_owner, _blockNumber());
    }

    function balanceOfAt(address _owner, uint256 blockNumber) public view returns (uint256) {
        return _balancesHistory[_owner].getValueAt(blockNumber);
    }

    function addBalancesCheckpoint(address _owner, uint256 _time, uint256 _value) public returns (bool) {
      _balancesHistory[_owner].addCheckpoint(_time, _value);
      return true;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupplyAt(_blockNumber());
    }

    function totalSupplyAt(uint256 _blockNumber) public view returns (uint256) {
        return _totalSupplyHistory.getValueAt(_blockNumber);
    }

    function addTotalSupplyCheckpoint(uint256 _time, uint256 _value) public returns (bool) {
      _totalSupplyHistory.addCheckpoint(_time, _value);
      return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return _allowances[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public override returns (bool) {
        _allowances[_msgSender()][_spender] = _value;
        emit Approval(_msgSender(), _spender, _value);
        return true;
    }

    function transfer(address _to, uint256 _value) public override returns (bool) {
        return transferFrom(
            _msgSender(),
            _to,
            _value
        );
    }

    function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool) {
        uint256 previousBalanceFrom = balanceOfAt(_from, _blockNumber());
        require(previousBalanceFrom >= _value, "insufficient-balance");

        if (_from != _msgSender() && _allowances[_from][_msgSender()] != uint(-1)) {
            require(_allowances[_from][_msgSender()] >= _value, "insufficient-allowance");
            _allowances[_from][_msgSender()] = _allowances[_from][_msgSender()] - _value; // overflow not possible
        }

        _balancesHistory[_from].addCheckpoint(
            _blockNumber(),
            previousBalanceFrom - _value // overflow not possible
        );

        _balancesHistory[_to].addCheckpoint(
            _blockNumber(),
            balanceOfAt(_to, _blockNumber()).add(_value)
        );

        emit Transfer(_from, _to, _value);
        return true;
    }
}
