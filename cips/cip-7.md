---
cip: 7
title: MC - Increase CIP Identifier Expressiveness
status: Draft
type: Meta
author: [Felipe Argento](felipe.argento@cartesi.io), [Guilherme Dantas](guilherme.dantas@cartesi.io), [Fabiana Cecin](fabiana.cecin@cartesi.io), [Augusto Teixeira](augusto.teixeira@cartesi.io)
discussions-to: https://github.com/cartesi/cips/discussions/11
created: 2022-04-11
---

## Abstract

This CIP describes a new and more expressive way of identifying CIPs.
The proposal intends to create an enumeration scheme that assists interested parties in understanding the focus of a CIP immediately, just by looking at it's identifier.

## Motivation

Not everyone will be interested in every CIP. It is quite realistic to imagine people that would like to follow and contribute to a subgroup of the CIP categories.
However, as the number of CIPs grow, scrolling through them all to figure out what would suit one interests becomes cumbersome.
Having a clear numbering system that can indicate the type of a CIP and the area within that type it touches would be beneficial, allowing for faster identification and possibility of subscribing/following specific areas.

## Specification

CIPs are now identified by the following schema: [First Letter of Type][First letter of subtype][Number of Pull Request]. The CIP being proposed for aggregation encoding, for example, would be identified as CR32 as it is [type: Core][Subtype: Rollups][PR:32]. X is a reserved subtype, for CIPs that do not fit a specific subtype, is generic or "catch-all". CIPs of types with no subtypes should use two letters instead of one for it's type, Informative CIPs would use IN[PR Number].

Past CIPs are going to be renamed, with the exception of CIP 1 - which will hold a catalogue of possible types and subtypes for future CIPs.


## Rationale

It is clear that this makes it easier to navigate the CIP landscape without adding unnecessary bureaucracy. New CIP types and subtypes will arise naturally and the process will evolve, attracting different communities and different eyes for the different areas of improvement in Cartesi's ecosystem.

## Security Considerations

Organized information is beneficial for the long term security of any project. By making it easier for interested eyes to find the areas they're willing to contribute we increase the pool of relevant people contributing with each decision.

## References

[Ethereum Improvement Proposal]: https://eips.ethereum.org/

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
