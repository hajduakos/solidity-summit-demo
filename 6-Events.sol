pragma solidity >=0.5.0;

contract Storage {
    struct Entry {
        bool set;
        int data;
    }

    mapping(address=>Entry) entries;
    address lastUpdate;

    /// @notice precondition !entries[from].set
    /// @notice postcondition entries[from].set
    /// @notice postcondition entries[from].data == value
    /// @notice postcondition lastUpdate == from
    event new_entry(address from, int value);

    /// @notice precondition entries[from].set
    /// @notice postcondition entries[from].set
    /// @notice postcondition entries[from].data == value
    /// @notice postcondition lastUpdate == from
    event updated_entry(address from, int value);

    /// @notice emits new_entry
    function add(int data) public {
        require(!entries[msg.sender].set, "");
        entries[msg.sender] = Entry(true, data);
        lastUpdate = msg.sender;
        emit new_entry(msg.sender, data);
    }

    /// @notice emits updated_entry
    function update(int data) public {
        require(entries[msg.sender].set, "");
        entries[msg.sender].data = data;
        lastUpdate = msg.sender;
        emit updated_entry(msg.sender, data);
    }
}