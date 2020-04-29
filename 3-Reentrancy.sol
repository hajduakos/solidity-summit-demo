pragma solidity >=0.5.0;

/// @notice invariant __verifier_sum_uint(balances) <= address(this).balance
contract Reentrancy {
    mapping(address=>uint) balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(uint amount) public {
        require(balances[msg.sender] >= amount, "Insufficient funds");
        (bool ok, ) = msg.sender.call.value(amount)("");
        if(!ok) revert("");
        balances[msg.sender] -= amount;
    }
}