pragma solidity >=0.5.0;

//
contract Basic {
    int x;
    int y;

    constructor(int start) public {
        x = y = start;
    }

    function add(int n) public {
        x += n;
        y += n;
    }
}