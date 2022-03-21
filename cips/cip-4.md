---
cip: 4
title: Input Protocols
status: Draft
type: Core CIP
author: Augusto Teixeira
created: 2022-03-18
---

## Abstract

This CIP introduces a way for Rollups inputs to specify their own protocols.
This allows future applications to use different protocols and encodings, with a few advantages:
- a single application could accept more than one protocol;
- after upgrades that involve the protocol, applications could retain backwards compatibility;
- as better protocols arrive (for example with better compression), minimal disturbance will be generated;
- the protocol specification could help us differentiate direct inputs from those which are aggregated, as well as the type of aggregation used;
- tools could be developed that help the developer in processing inputs, since some of the processing could be done at a protocol level.

## Motivation

Currently, machines receive as inputs an arbitrary payload and parsing/decoding is completely left to the application developer.
This of course is very un-opinionated and gives the most freedom to developers.
However, lack of standardization could harm the ecosystem in the long run as tooling will be very application specific.

This CIP is very minimal in that it solely defines the protocol version of an input and how to refer to them.
Each protocol version will be specified in their separate CIPs.

## Specification

After this CIP is accepted, every input to a Cartesi Rollups Machine will be composed of two parts: a header and a payload.

- The *header* will take between `1` and `4` bytes and it will specify the protocol number of the input, between `0` and `270,549,119`.
- The *payload* can be an arbitrary sequence of bytes that abides by the protocol number specified in the header.

This CIP does not specify any protocol as this will be done in future CIPs.

The header will be specified in one, two, three or four bytes at most.
Its encoding is inspired (although slightly different) by the UTF-8 standard.
- The first byte is used to specify the size of the header, but it also contains some bits for the protocol itself;
- All the other bytes are used to store the protocol version.

|--------|----------------|
| header | binary payload |
|--------|----------------|

Here is a table describing the encoding:

|                  |   byte 1 | byte 2   | byte 3   | byte4    |
|------------------|----------|----------|----------|----------|
| 1 byte encoding  | 0xxxxxxx |          |          |          |
| 2 bytes encoding | 10xxxxxx | xxxxxxxx |          |          |
| 3 bytes encoding | 110xxxxx | xxxxxxxx | xxxxxxxx |          |
| 4 bytes encoding | 1110xxxx | xxxxxxxx | xxxxxxxx | xxxxxxxx |

It is clear that the number of protocol versions allowed in this specification is given by: `2^7 + 2^14 + 2^21 + 2^28 = 270,549,120`.

The first implementation of the parser for this CIP could be restricted to supporting only one-byte encodings.
This would restrict the number of protocols to `128`, but it would have a few advantages:
- It is simpler to implement;
- `128` protocols should be enough for a long time and
- The full specification is backwards compatible with the single-byte version.

## Rationale

This CIP tries to accommodate a few competing desires:
- allow for a large number of protocols, since it is unpredictable how many will be needed;
- minimize the cost in terms of data availability, since forcing every individual input to include something like 4 bytes would be wasteful;
- be minimal in terms of specification, overloading the hard decisions to each protocol, where experimentation can take place;
- easiness to implement, specially with a first version that is even simpler.

## Security Considerations

It is possible that an application that handles many protocols could find itself with an increased attack surface.
Therefore it is recommendable that applications try to keep the number of protocols low and add them as they have been tested in depth, for example in the case of backwards compatibility.

The reference library for establishing the protocol version should be throughly tested with non-conformant inputs.
Some malformed headers should not trick the application into undefined or dangerous behavior.

## Referring to an Input Protocol

The suggestion of this CIP is that every Input Protocol to be specified should be called by `IP-<header>`, where `<header>` stands for the hexadecimal description of the header of the protocol.
Optionally, one can give a readable name to the protocol to be written after the code.

For example, protocol zero should be referred to by `IP-00`, while the protocol 130 should be `IP-8002`.
It could be mentioned as `IP-8002 My example protocol` to make the name explicit.

## References

[UTF-8 Specs](https://datatracker.ietf.org/doc/html/rfc3629)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
