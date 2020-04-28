# Solidity Summit Demo

Examples for the [Solidity Summit 2020](https://solidity-summit.ethereum.org/) presentation titled _solc-verify: source-level formal verification for Solidity_.

Running the examples requires [solc-verify](https://github.com/SRI-CSL/solidity) to be available (see [install instructions](https://github.com/SRI-CSL/solidity/blob/boogie/SOLC-VERIFY-README.md) or try the [Docker image](https://github.com/SRI-CSL/solidity/blob/boogie/docker/README.md)).
During the demo, the latest version (commit [4fee04a](https://github.com/SRI-CSL/solidity/commit/4fee04a18ce7471d96ba97db39285c630a7d8357) at the time) was used.

For more information, take a look at the [readme](https://github.com/SRI-CSL/solidity/blob/boogie/SOLC-VERIFY-README.md) of solc-verify, our [tool paper](https://arxiv.org/abs/1907.04262), or our [paper](https://arxiv.org/abs/2001.03256) on formalizing reference types and the memory model.

## 0-Basic.sol

This is a basic example for a contract that keeps track of two values, `x` and `y`, which should always be equal (except of course during intermediate steps within a transaction).
This can be formulated with a _contract-level invariant_.
A contract level invariant must hold before and after every transaction, i.e., public function call.

Run with `solc-verify.py 0-Basic.sol`. The tool can prove that both the constructor and the `add` function satisfies the invariant.

## 1-Token.sol

This is an example for a simple fixed cap token.
The contract keeps track of users' balances and allows transfers.
The _contract-level invariant_ ensures that the total amount of tokens is constant.
Having only the invariant would still allow, for example to swap the `+=` and `-=` operators in the `transfer` function, therefore extra _postconditions_ are added.
The postconditions ensure that the transfer takes place properly.

Run with `solc-verify.py 1-Token.sol`.

## 2-TokenBatch.sol

This is the same token example as `1-Token.sol`, but with a batch transfer function, illustrating the infamous [overflow issue in the BEC Token](https://medium.com/@peckshield/alert-new-batchoverflow-bug-in-multiple-erc20-smart-contracts-cve-2018-10299-511067db6536).

If `SafeMath` is not used, the multiplication in `batchTransfer` can overflow, allowing to create
a large amount of tokens out of nowhere.

Run solc-verify with `solc-verify.py 2-TokenBatch.sol --arithmetic mod-overflow` to detect this issue.

Note that if `SafeMath` is used for the multiplication (and the other arithmetic operations), solc-verify does not report false overflow alarms.
Furthermore, with _contract and loop-level invariants_ added, solc-verify can also
prove functional properties (such as the total number of tokens is constant).

## 3-Reentrancy.sol
This is an example for a simple wallet where users can deposit and withdraw, illustrating
the infamous  [reentrancy issue of the DAO](https://medium.com/swlh/the-story-of-the-dao-its-history-and-consequences-71e6a8a551ee).

An external call alone might not always cause reentrancy issues.
By using a contract-level invariant, solc-verify can check if external calls are safe: `solc-verify.py 3-Reentrancy.sol`.

For the current contract it reports that the invariant does not hold before the external call, which is unsafe.
However, if the balance of the caller is deducted first (before the external call), the contract is safe and solc-verify no longer reports (false) alarms.
Furthermore, it can also prove safety if `transfer` is used instead of call.
Note that due to modular verification (each function checked independently), the verifier requires an extra hint, a _precondition_ that self-transfers are not possible.

## 4-Modifications.sol
This is an example for a storage contract where users can `add`/`update`/`clear` their data (which is simply an integer for illustrative purposes).
Furthermore, there is an `owner`, who can clear any data.
This example illustrates the fine-grained specification possibilities for annotating functions with the data they can _modify_.
It is possible to specify entire collections to be modified (e.g., `entries`), or just particular members at particular indexes (e.g., `entries[msg.sender].data`).
Furthermore, modifications can be restricted with additional conditions (e.g., `if msg.sender == owner`).

Run with `solc-verify.py 4-Modifications.sol`.

Note that the private `setdata` function takes a local storage pointer, which can point to any entry within the contract so it declares `entries` as a whole for modifications.
Furthermore, note that `update` calls `setdata`, which assigns the `.set` member but `update` should only modify `.data`.
However, `update` requires the `.set` member to be true so solc-verify can prove that the `setdata` function does not really modify it with the assignment.

## Experimental features

Note that the following features are not (yet) supported on the main branch.
At the demo, commit [2365707](https://github.com/SRI-CSL/solidity/commit/236570742c1ff9b6d25792b34c7ab7f972ac28ad) was used.

### 5-Quantifiers.sol
An example contract that keeps track of a sorted (integer) sequence, illustrating the
usage of _quantifiers_ in specification.
The _contract-level invariant_ states that for each index `i`, `j` within the range of the array, if `i < j` then `items[i] < items[j]` should hold (sortedness).

Run with `solc-verify.py 5-Quantifiers.sol`.

### 6-Events.sol
This is a storage contract, similar to 4-Modifications.sol, illustrating the specification possibilities for events.
Functions can be annotated with the events that they possibly _emit_.
Furthermore, events can be specified _pre- and postconditions_.

Run with `solc-verify.py 6-Events.sol`.
