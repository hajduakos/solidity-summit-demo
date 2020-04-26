/*
An example contract that keeps track of a sorted (integer) sequence, illustrating the
usage of quantifiers in specification.

Run with 'solc-verify.py 5-Quantifiers.sol'.
Note that this feature is not yet supported on the main branch.
*/
pragma solidity >=0.5.0;

/// @notice invariant forall (uint i, uint j) !(0 <= i && i < j && j < items.length) || (items[i] < items[j])
contract SortedSequence {
    uint[] items;

    function add(uint x) public {
        require(items.length == 0 || x > items[items.length-1], "");
        items.push(x);
    }

    function pop() public {
        require(items.length > 0, "Empty array");
        items.pop();
    }
}