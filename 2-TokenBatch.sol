pragma solidity >=0.5.0;

/// @notice invariant __verifier_sum_uint(balances) == total
contract Token {
    using SafeMath for uint;
    uint total;
    mapping(address=>uint) balances;

    constructor() public {
        total = 100000;
        balances[msg.sender] = total;
    }

    function batchTransfer(address[] memory receivers, uint value) public {
        require(0 < receivers.length && receivers.length <= 10, "");
        //uint amount = receivers.length * value; // Overflow
        uint amount = receivers.length.mul(value); // OK
        require(balances[msg.sender] >= amount, "Insufficient funds");
        balances[msg.sender] = balances[msg.sender].sub(amount);

        /// @notice invariant total == __verifier_sum_uint(balances) + (receivers.length - i) * value
        /// @notice invariant i <= receivers.length
        for (uint i = 0; i < receivers.length; i++) {
            balances[receivers[i]] = balances[receivers[i]].add(value);
        }
    }
}

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // assert(b > 0); // Solidity automatically throws when dividing by 0
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }
}