# Solidity Summit Demo

Examples for the [Solidity Summit 2020](https://solidity-summit.ethereum.org/) presentation titled _solc-verify: source-level formal verification for Solidity_.

Running the examples requires [solc-verify](https://github.com/SRI-CSL/solidity) to be available (see [install instructions](https://github.com/SRI-CSL/solidity/blob/boogie/SOLC-VERIFY-README.md) or try the [Docker image](https://github.com/SRI-CSL/solidity/blob/boogie/docker/README.md)).
During the demo, the latest version (commit [09941c0](https://github.com/SRI-CSL/solidity/commit/09941c0e68353ee99ff3d511ca2c1a989d00e1c8) at the time) was used.

For more information, take a look at the [readme](https://github.com/SRI-CSL/solidity/blob/boogie/SOLC-VERIFY-README.md) of solc-verify, our [tool paper](https://arxiv.org/abs/1907.04262), or our [paper](https://arxiv.org/abs/2001.03256) on formalizing reference types and the memory model.

## 1-Token.sol

This is an example for a simple fixed cap token.
The contract keeps track of users' balances and allows transfers.
The _contract-level invariant_ ensures that the total amount of tokens is constant.
A contract level invariant must hold before and after every transaction, i.e., public function call.
Having only the invariant would still allow to swap the `+=` and `-=` operators in the `transfer` function,
therefore extra _postconditions_ are added.

Run with `solc-verify.py 1-Token.sol`
or with `solc-verify.py 1-Token.sol --arithmetic mod-overflow` to check for overflows.

## 2-TokenBatch.sol

This is the same token example as `1-Token.sol`, but with a batch transfer function, illustrating the infamous [overflow issue in the BEC Token](https://medium.com/@peckshield/alert-new-batchoverflow-bug-in-multiple-erc20-smart-contracts-cve-2018-10299-511067db6536).

If `SafeMath` is not used, the multiplication in `batchTransfer` can overflow, creating
a large amount of tokens out of nowhere.

Run solc-verify with `solc-verify.py 2-TokenBatch.sol --arithmetic mod-overflow` to detect this issue.
Note that if `SafeMath` is used, solc-verify does not report false overflow alarms.
Furthermore, with _contract and loop-level invariants_ added, it can also
prove functional properties (such as the total number of tokens is constant).

## 3-Reentrancy.sol
This is an example for a simple wallet where users can deposit and withdraw, illustrating
the infamous  [reentrancy issue of the DAO](https://medium.com/swlh/the-story-of-the-dao-its-history-and-consequences-71e6a8a551ee).

An external call alone might not always cause reentrancy issues.
By using a contract-level invariant, solc-verify can check if external calls are safe: `solc-verify.py 3-Reentrancy.sol`.
For the current contract it reports that the invariant does not hold before the external call.
However, if the balance of the caller is deducted first (before the external call), the contract is safe and solc-verify no longer reports (false) alarms.
Furthermore, it can also prove safety if `transfer` is used instead of call.
Note that due to modular verification (each function checked independently), the verifier requires an extra hint, a _precondition_ that self-transfers are not possible.

## 4-Modifications.sol
This is an example for a storage contract where users can add/update/clear their data (an integer for illustrative purposes).
Furthermore, there is an owner, who can clear any data.
This example illustrates the fine-grained specification possibilities for annotating functions with the data they can modify.
It is possible to specify entire collections to be modified, or just particular members at particular indexes.
Furthermore, modifications can be restricted with additional conditions.
Run with `solc-verify.py 4-Modifications.sol`.

## 5-Quantifiers.sol
An example contract that keeps track of a sorted (integer) sequence, illustrating the
usage of _quantifiers_ in specification.

Run with `solc-verify.py 5-Quantifiers.sol`.
Note that this feature is not yet supported on the main branch.
At the demo, commit [afa0313](https://github.com/SRI-CSL/solidity/commit/afa03133b6c3b8f68f3f6e73b8e42d9ba7244fea) was used.

## 6-Events.sol
This is a storage contract, similar to 4-Modifications.sol, illustrating the specification possibilities for events.
Functions can be annotated with the events that they possibly _emit_.
Furthermore, events can be specified _pre- and postconditions_.

Run with `solc-verify.py 6-Events.sol`.
Note that this feature is not yet supported on the main branch.
At the demo, commit [afa0313](https://github.com/SRI-CSL/solidity/commit/afa03133b6c3b8f68f3f6e73b8e42d9ba7244fea) was used.