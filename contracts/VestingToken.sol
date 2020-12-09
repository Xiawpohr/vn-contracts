// SPDX-License-Identifier: MIT

pragma solidity ^0.7.3;

import "./erc20/ERC20Checkpointable.sol";
import "./utils/Ownable.sol";
import "./utils/SafeMath.sol";


contract VestingToken is ERC20Checkpointable, Ownable {
    using SafeMath for uint256;

    event Claim(
        address indexed owner,
        uint256 value
    );

    uint256 public vestingDuration;
    uint256 public vestingStartTimestamp;
    uint256 public vestingEndTimestamp;

    uint256 public totalClaimed; // total claimed since start

    IERC20 public underlying;

    uint256 private _startingBalance;

    mapping (address => uint256) private _lastClaimTime;
    mapping (address => uint256) private _userTotalClaimed;

    bool private _isInitialized;

    constructor(string memory _name, string memory _symbol) public ERC20(_name, _symbol) {}


    // sets up vesting and deposits underlying token
    function initialize(address _underlying, uint256 _startBalance, uint256 _startTimestamp, uint256 _duration) external {
        require(!_isInitialized, "already initialized");

        vestingDuration = _duration;
        vestingStartTimestamp = _startTimestamp;
        vestingEndTimestamp = vestingStartTimestamp + vestingDuration;
        underlying = IERC20(_underlying);
        _startingBalance = _startBalance;

        address _msgSender = _msgSender();
        uint256 _blockNumber = _blockNumber();
        addBalancesCheckpoint(_msgSender, _blockNumber, _startingBalance);
        addTotalSupplyCheckpoint(_blockNumber, _startingBalance);
        
        emit Transfer(address(0), _msgSender, _startingBalance);

        underlying.transferFrom(_msgSender, address(this), _startingBalance);

        _isInitialized = true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool) {
        _claim(_from);
        if (_from != _to) {
            _claim(_to);
        }

        return super.transferFrom(
            _from,
            _to,
            _value
        );
    }

    // user can claim vested underlying
    function claim() public {
        _claim(_msgSender());
    }

    // user can burn remaining vesting tokens once fully vested; unclaimed underlying token with be withdrawn
    function burn() external {
        require(_timestamp() >= vestingEndTimestamp, "not fully vested");

        address _msgSender = _msgSender();
        uint256 _blockNumber = _blockNumber();

        _claim(_msgSender);

        uint256 balanceBefore = balanceOfAt(_msgSender, _blockNumber);
        addBalancesCheckpoint(_msgSender, _blockNumber, 0);
        addTotalSupplyCheckpoint(_blockNumber, totalSupplyAt(_blockNumber)); // overflow not possible

        emit Transfer(_msgSender, address(0), balanceBefore);
    }

    // funds unclaimed one year after vesting ends can be rescued
    function rescue(address _receiver, uint256 _amount) external onlyOwner {
        require(_timestamp() > vestingEndTimestamp, "unauthorized");

        underlying.transfer(
            _receiver,
            _amount
        );
    }

    // total that has vested, but has not yet been claimed by a user
    function vestedBalanceOf(address _owner) public view returns (uint256) {
        uint256 lastClaim = _lastClaimTime[_owner];
        if (lastClaim < _timestamp()) {
            return _totalVested(
                balanceOfAt(_owner, _blockNumber()),
                lastClaim
            );
        }
    }

    // total that has not yet vested
    function vestingBalanceOf(address _owner) public view returns (uint256 balance) {
        balance = balanceOfAt(_owner, _blockNumber());
        if (balance != 0) {
            uint256 lastClaim = _lastClaimTime[_owner];
            if (lastClaim < _timestamp()) {
                balance = balance.sub(_totalVested(balance, lastClaim));
            }
        }
    }

    // total that has been claimed by a user
    function claimedBalanceOf(address _owner) public view returns (uint256) {
        return _userTotalClaimed[_owner];
    }

    // total vested since start (claimed + unclaimed)
    function totalVested() external view returns (uint256) {
        return _totalVested(_startingBalance, 0);
    }

    // total unclaimed since start
    function totalUnclaimed() external view returns (uint256) {
        return _totalVested(_startingBalance, 0).sub(totalClaimed);
    }

    function _claim(address _owner) internal {
        uint256 vested = vestedBalanceOf(_owner);
        if (vested != 0) {
            _userTotalClaimed[_owner] = _userTotalClaimed[_owner].add(vested);
            totalClaimed = totalClaimed.add(vested);

            underlying.transfer(_owner, vested);

            emit Claim(_owner, vested);
        }

        _lastClaimTime[_owner] = _timestamp();
    }

    function _totalVested(uint256 _proportionalSupply, uint256 __lastClaimTime) internal view returns (uint256) {
        uint256 currentTimeForVesting = _timestamp();

        if (currentTimeForVesting <= vestingStartTimestamp ||
            __lastClaimTime >= vestingEndTimestamp) {
            // time cannot be before vesting starts
            // OR all vested token has already been claimed
            return 0;
        }
        if (__lastClaimTime < vestingStartTimestamp) {
            // vesting starts at the cliff timestamp
            __lastClaimTime = vestingStartTimestamp;
        }
        if (currentTimeForVesting > vestingEndTimestamp) {
            // vesting ends at the end timestamp
            currentTimeForVesting = vestingEndTimestamp;
        }

        uint256 timeSinceClaim = currentTimeForVesting.sub(__lastClaimTime);
        return _proportionalSupply.mul(timeSinceClaim).div(vestingDuration);
    }
}
