---
cap: 6
title: Rollups Factory
status: Draft
type: Core
author: Augusto Teixeira
created: 2022-04-04
---

## Abstract

This CIP establishes a new method for deploying a Rollups application to a public network.
This new standard is based on  a factory contract that is able to produce new Rollups Diamonds upon request.
Some advantages of this proposed change include:
?!?

## Motivation

The current implementation of Rollups requires the manual deployment of the diamond smart contract that manages the application (although the libraries themselves are fixed).
This architecture poses a few challenges such as:
- Requiring Hardhat for deployment (instead of a simple Metamask transaction);
- Makes it impractical for a mart contract on L1 to launch a Rollups instance (which would be useful for computational oracles);
- Making it harder to verify the code of existing Rollups diamonds as originating from the reference implementation;
- Forcing every application to be identified through its 20 bytes long address (which does not fit inside a ChainId and harms compression);
- It is not easy to enforce that the Setup Input be the first input to arrive to a rollups application.

## Specification

With the implementation of this CIP, every new Rollups version to be released will come accompanied by the deployment of a `Factory` Smart Contract.

Each new application deployed on Cartesi will do so by calling the `newApplication` method of the `Factory`, which have the following parameters:
- `inputDuration` (uint);
- `challengePeriod` (uint);
- `inputLog2Size` (uint8);
- `validators` (array[address]);
- `initialHash` (bytes32);
- other fields to be discussed.

Calling the `newApplication` method will:
- call the Solidity `new` method to create a Rollups Diamond;
- configure the Rollups with arguments to the constructor;
- send the Setup Input responsible for informing the Cartesi Machine about its deployment address;
- create a new (4 bytes) `RollupsId` for the recently deployed application;
- store a an array, indexed by `RollupsId`s and providing its deployed addresses;
- offer an endpoint for the above array.
- emit an event containing: the constructor arguments, the `RollupsId` and the address of the application.

## Rationale

Factories are a common design pattern for deploying an unlimited number of identical smart contracts, which is the case for our Rollups solution.

The Factory design is simple to implement and brings the following advantages:
- It will be much easier to guarantee the legitimacy of the code of a Rollups Diamond;
- It will be possible to deploy new applications both from Metamask and from another contract in L1 (think Computational Oracles or Poker World);
- [Currently](https://github.com/ethereum/EIPs/issues/2294), a chain is identified by the 64-bit integer ChainId, which is enough to store any number of Rollups applications we may desire, but it is not enough to embed the address of a given application within the ChainId.
With this CIP, it would be possible to store the `RollupsId` inside the `ChainId`;
- It would make sure that the Setup Input is correctly formed and sent by a trusted source (the Factory itself).

## Security Considerations

The security benefits of having a centralized place to deploy new applications out-weights the possible surface of attack added by the Factory.
Factories are a known design pattern with few security tensions.

## References

[ChainId]: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
[ChainId Limits]: https://github.com/ethereum/EIPs/issues/2294

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
