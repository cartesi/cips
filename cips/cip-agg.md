---
cip: 1
title: CIP Purpose and Guidelines
status: Living
type: Meta
author: The Cartesi Core Developers <https://cartesi.io>
created: 2021-04-19
updated: 2021-08-18
---


## Abstract


## Motivation


## Specification

### Input

This will be added directly to the `input` contract, by the aggregator.
- Format: binary;
- Example: `0100010011010011111...`;
- Every version of the protocol has a particular encoding (something like [this](https://github.com/Loopring/protocols/blob/release_loopring_3.6.3/packages/loopring_v3/DESIGN.md#transfer).
- Future versions can be more and more compressed.

### Decompress

The first processing of the input consists of decompressing and decoding the above format into a large and simple.
This will result in an array of *incomplete transactions*.
- Format: JSON
- Example:
```
[
  {
    type: "eth_transfer",
    fromAccountID: 14432,
    toAccountID: 83,
    amount_gigawei: 12398,
    fee: 200000,
    encoding_version: 2,
  },
  {
    type: "eth_transfer",
    ...
  }
  ...
]
```

### Complete

Up to the previous point, the transactions were bare-bones in order to minimize the data availability burden.
This was done by removing form the transaction, all the information that could be inferred by the machine, such as the network name, for example.
It would be a big waste to include things like the network name in all the transactions aggregated in L1.

The data to be added at this stage can be split into two groups: static and dynamic.

The static information is never changed throughout the evolution of the application.
They could however be changed on the event that the application itself is upgraded.
These are:
- `tag`. `Cartesi Rollups` (used to make sure that the transaction was directed at a rollups application);
- `rollupsVersion`. Example: `0.4`;
- `L1Network`. Example: `Ethereum`;
- `L1ChainID`. Example: `Ropsten`;

Note that the transaction that is actually signed includes all these values.
Therefore, the *completion* process has to be performed before verifying the signatures.

Dynamic information changes throughout the evolution of the application.
Some of them concerns users and change as new user join the system or if existing users send transaction.
These are:
- `accountID` -> Account 20bytes. Example: `accountID: 13` is associated with address `0x87ff27cd236...`;
- `nonce`. Example: user `accountID` has sent `17` transactions.

In the future, we can add support for other types of transactions and in this case we can store dynamic information about other things, like tokens for example:
- `tokenID` -> Token Address 20bytes. Example: `tokenID: 24` corresponds to address `0x18178a2ccf32...`;
- `fixedPointPrecision` -> Number of zeros to be added to get to a unit of the token. Example: `tokenID: 24` has `18` decimal precisions in its fixed point representation.

After going through the process of completing a transaction, it should look like this:
```
{
  from: "0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8",
  to: "0xac03bb73b6a9e108530aff4df5077c2b3d481e5a",
  gasLimit: "21000",
  maxFeePerGas: "300",
  maxPriorityFeePerGas: "10",
  nonce: "0",
  value: "10000000000"
  chainId: 234980923489
}
```



### Signature verification

- agnostic with respect to aggregation of signatures.

## Questions

- Where are fees paid? L2? Offchain? Aggregation blockchain?
- Should we use Sign Message or Sign Transaction?
  - we can use chain id, with [lots of values](https://github.com/ethereum/EIPs/issues/2294)


## Rationale


## Security Considerations


## References


## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
