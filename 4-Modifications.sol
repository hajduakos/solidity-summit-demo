/*
An example for a storage where users can add/update/clear their data (an integer).
The owner can clear any data. This illustrates the fine-grained specification
possibilities for annotating functions with the data they can modify.

Run with 'solc-verify.py 4-Modifications.sol'.
*/

pragma solidity >=0.5.0;

contract Storage {
    struct Entry {
        bool set;
        int data;
    }

    mapping(address=>Entry) entries;
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    /// @notice modifies owner if msg.sender == owner
    function changeOwner(address newOwner) public {
        require(msg.sender == owner, "");
        owner = newOwner;
    }

    /// @notice modifies entries[msg.sender] if !entries[msg.sender].set
    function add(int data) public {
        require(!entries[msg.sender].set, "");
        entries[msg.sender] = Entry(true, data);
    }

    /// @notice modifies entries[msg.sender].data if entries[msg.sender].set
    function update(int data) public {
        require(entries[msg.sender].set, "");
        entries[msg.sender].data = data;
    }

    /// @notice modifies entries[msg.sender]
    /// @notice modifies entries if msg.sender == owner
    function clear(address at) public {
        require(msg.sender == owner || msg.sender == at, "");
        entries[at] = Entry(false, 0);
    }
}