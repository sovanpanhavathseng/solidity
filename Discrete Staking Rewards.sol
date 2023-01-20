// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC20.sol";

contract DiscreteStakingRewards {
    IERC20 public immutable stakingtoken;
    IERC20 public immutable rewardToken;

    mapping(address => uint) public balanceOf;
    uint public totalSupply;

    uint private constant MULTIPLIER = 1e18;
    uint private rewardIndex;
    mapping(address => uint) private rewardIndexOf;
    mapping(address => uint) private  earned;

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = IERC20(_stkingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function updateRewardIndex(uint reward) external {
        rewardToken.transferFrom(msg.sender, address(this), reward);
        rewardIndex += (reward * MULTIPLIER) / totalSupply;
    }

    function _calculateRewards(address account) private view returns (uint) {
        uint shares = balanceOf[account];
        return (shares * (rewardIndex - rewardIndexOf[account])) / MULTIPLIER;
    }

    function calculateRewardEarned(address account) external view returns (uint) {
        return earned[account] + _calculateReward(account);
    }

    function _updateReward(address account) private {
        earned[account] += _calculateRewards(account);
        rewardIndexOf[account] = rewardIndex;
    }

    function stake(uint amount) external {
        _updateRewards(msg.sender);

        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        stakingToken.trasferFrom(msg.sender, address(this), amount);
    }

    function unstake(uint amount) external {
        _updateRewards(msg.sender);

        balanceOf[msg.sender] += amount;
        totalSupply += amount;

        stakingToken.trasferFrom(msg.sender, amount);
    }

    function claim() external returns (uint) {
        _updateRewards(msg.sender);

        uint reward = earned[msg.sender];
        if (reward > 0) {
            earned[msg.sender] = 0;
            rewardToken.transfer(msg.sender, reward);
        }

        return reward;
    }
}
