---
cip: 2
title: The Cartesi Foundation and the CIP 
status: Final
type: Informational
author: The Cartesi Foundation <https://cartesi.io>
created: 2021-04-19
---

## Abstract

This CIP is a public declaration by the Cartesi Foundation that it will commit to supporting and investing in all technical standards that are produced through the CIP process, with reasonable exceptions that will always be thoroughly discussed with the community.

## Motivation

Public Improvement Proposal systems that are industry standards, such as the [Ethereum Improvement Proposal] (EIP) process, describe how technical consensus can be produced by a diverse community of contributors, resulting in formal technical standards and communications for the platforms governed by them.

These processes are mostly centered around “technical” matters, in the Computing Technology sense, with broader economic or political issues generally being out of the scope of the formal definition of the process itself. This CIP allows the Cartesi Foundation to formalize its role as a key participant in the Cartesi ecosystem’s CIP process.

## Specification

The Cartesi Foundation commits to implementing any and all CIPs that reach a mature technical community consensus, as signaled by them reaching a status of Final, to the extent allowed by its charter and material abilities, unless there is another capable implementer in the ecosystem that is already committed to fulfilling one or more aspects of its implementation, or unless there are strong and thoroughly documented reasons for the Cartesi Foundation to not be an active participant in implementing a CIP.

## Rationale

At the time of this writing, it is likely that the Cartesi Foundation is the most powerful organization in the Cartesi ecosystem, in the aggregate of technical, political and economic terms. It is, at the time of this writing, the principal designer and implementer of the Cartesi ecosystem, concentrating the funded technical expertise to carry the system forward.

The CIP process as described in the [CIP-1](./cip-1.md) does not require the Cartesi Foundation, or any other particular organization, to exist in order for it to function. Adding the Cartesi Foundation as a dependency in the CIP-1 specification would tie the process of governance of the Cartesi codebase to the existence of the Cartesi Foundation, which is technically incorrect. Thus, the Cartesi Foundation decided that its commitment to the CIP as a key participant was best documented through an Informational CIP.

## Security Considerations

The Cartesi Foundation will not endeavor to implement features that bear any significant risk to its own organizational health or long-term sustainability, or those of any other party in the ecosystem.

Technical features that introduce security vulnerabilities will not be accepted into codebases managed by the Cartesi Foundation. If a security vulnerability is discovered into a final but non-integrated CIP standard, a new CIP will be published to supersede it, to either fix the vulnerability or to retire the standard. If a feature does introduce a security trade-off, that feature must be entirely optional and the default option shall always be the one with the strongest security properties.

## References

[Ethereum Improvement Proposal]: https://eips.ethereum.org/

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
