/*
An example for a simple wallet where users can deposit and withdraw, illustrating
the infamous reentrancy issue (DAO).

An external call alone might not always cause reentrancy issues. Using an invariant
solc-verify can check if external calls are safe. For the current contract it reports
that the invariant does not hold before the external call. However, if the balance
of the caller is first deducted, it no longer reports (false) alarms.

Run with 'solc-verify.py 3-Reentrancy.sol'.
*/

pragma solidity >=0.5.0;

/// @notice invariant __verifier_sum_uint(balances) <= address(this).balance
contract Reentrancy {
    mapping(address=>uint) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    /// @notice precondition msg.sender != address(this)
    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        (bool ok, ) = msg.sender.call.value(amount)("");
        if(!ok) revert("");
        balances[msg.sender] -= amount;
    }
}