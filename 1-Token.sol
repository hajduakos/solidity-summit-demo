pragma solidity >=0.5.0;

//
contract Token {
    uint total;
    mapping(address=>uint) balances;

    constructor() public {
        total = 100000;
        balances[msg.sender] = total;
    }

    //
    //
    function transfer(address to, uint amount) public {
        require(to != msg.sender, "Self transfer");
        require(balances[msg.sender] >= amount, "Insufficent funds");

        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
}