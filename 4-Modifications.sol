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

    //
    function changeOwner(address newOwner) public {
        require(msg.sender == owner, "");
        owner = newOwner;
    }

    //
    function setdata(Entry storage e, int data) private {
        e.set = true;
        e.data = data;
    }

    //
    function add(int data) public {
        require(!entries[msg.sender].set, "");
        Entry storage e = entries[msg.sender];
        setdata(e, data);
    }

    //
    function update(int data) public {
        require(entries[msg.sender].set, "");
        Entry storage e = entries[msg.sender];
        setdata(e, data);
    }

    //
    //
    function clear(address at) public {
        require(msg.sender == owner || msg.sender == at, "");
        entries[at] = Entry(false, 0);
    }
}