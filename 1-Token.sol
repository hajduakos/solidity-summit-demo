pragma solidity >=0.5.0;

/// @notice invariant __verifier_sum_uint(balances) == total
contract Token {
    uint total;
    mapping(address=>uint) balances;

    constructor() public {
        total = 100000;
        balances[msg.sender] = total;
    }

    /// @notice postcondition balances[msg.sender] == __verifier_old_uint(balances[msg.sender]) - amount
    /// @notice postcondition balances[to] == __verifier_old_uint(balances[to]) + amount
    function transfer(address to, uint amount) public {
        require(to != msg.sender, "Self transfer");
        require(balances[msg.sender] >= amount, "Insufficent funds");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}