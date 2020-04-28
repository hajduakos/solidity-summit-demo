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

    /// @notice modifies entries
    function setdata(Entry storage e, int data) private {
        e.set = true;
        e.data = data;
    }

    /// @notice modifies entries[msg.sender] if !entries[msg.sender].set
    function add(int data) public {
        require(!entries[msg.sender].set, "");
        Entry storage e = entries[msg.sender];
        setdata(e, data);
    }

    /// @notice modifies entries[msg.sender].data if entries[msg.sender].set
    function update(int data) public {
        require(entries[msg.sender].set, "");
        Entry storage e = entries[msg.sender];
        setdata(e, data);
    }

    /// @notice modifies entries[msg.sender]
    /// @notice modifies entries if msg.sender == owner
    function clear(address at) public {
        require(msg.sender == owner || msg.sender == at, "");
        entries[at] = Entry(false, 0);
    }
}