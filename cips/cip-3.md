---
cip: 3
title: Setup Input 
status: Draft
type: Core
author: [Felipe Argento](felipe.argento@cartesi.io), [Guilherme Dantas](guilherme.dantas@cartesi.io), [Augusto Teixeira](augusto.teixeira@cartesi.io)
created: 2022-03-09
---

## Abstract

This CIP describes how a Rollups DApp will be informed about its L1 address.
The proposal intends to create an initial input to perform such communication.

## Motivation

When Rollups contracts are deployed, they are given an address.
It is very important for the off-chain machine to know this address, for example, to know if an input originated by a trusted Portal.
These are what we call *Internal Inputs*.

There is a chicken and egg problem:
- the off-chain machine needs to know the address of the deployed contracts (to recognize internal inputs).
- the deployed contract needs to have a full specification of the machine (through the machine hash), including all the data (such as all addresses that it contains).

We need to have the address included inside the off-chain machine at the same time as we deploy.

## Specification

We build a Cartesi Machine without any information about its address on the initial state (initial hash).

Once deployed, every Rollups contracts will include an input to itself, called *Setup Input*.
This input is empty, but it contains metadata:
- `msg_sender` (which will match the address of the Rollups itself, or diamond),
- `timestamp` (which will match the release time of that application),
- `block_number` (the L1 block corresponding to deployment) and
- `epoch_index` and `input_index` will both be zero.

The machine can be assured that the first input comes from the application itself and it can store the sender's address as "self".

This *Setup Input* is not treated any different from other inputs and it could end up in a dispute.
The purpose of this input is to update the machine hash in a way that now includes the application's address.

## Rationale

It is clear that it solves the chicken-egg problem by saying that the initial hash of the machine will not contain the application's address.

It does not alter the usage/development/deployment/disputes concerning the application.

It does require that the off-chain machine process the first input in a special way (different from the typical inputs when the application is running), but this can be done with a library or through the HTTP API, without extra work required from the developer.

The *Setup Input* can expand and include extra information for setting up the application in the future.

## Security Considerations

At the same time, this does not seem to add any security risks, because the first input can be trusted to have originated from the application itself.
The setup input is guaranteed to be the first one because it is added internally upon contract initialization, after all the facets have been cut into the Diamond and Diamond Storage is appropriately initialized.
Validators should make sure that the deployed contracts match the reference inplementation.

## References

[Ethereum Improvement Proposal]: https://eips.ethereum.org/

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
