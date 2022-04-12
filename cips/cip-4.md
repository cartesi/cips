---
cip: 4
title: Input Protocols
status: Draft
type: Core CIP
discussion-to: https://github.com/cartesi/cips/discussions/15
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

- The *header* will take between `1` and `4` bytes and it will specify the protocol number of the input, between `0` and `268,435,456`.
- The *payload* is a sequence of bytes that abides by the protocol whose number is specified in the header.

This CIP does not specify any protocol as this will be done in future CIPs.

The header will be specified in one, two, three or four bytes at most.
Its encoding is inspired (although slightly different) by the UTF-8 standard.
- The first byte is used to specify the size of the header, but it also contains some bits for the protocol itself;
- All the other bytes are used to store the protocol version.

```
+--------------------+--------------------------+
| header (1-4 bytes) | binary payload (n bytes) |
+--------------------+--------------------------+
```

Here is a table describing the encoding of the protocol number:

| protocol number range<br>(hexadecimal) | octet sequence<br>(binary) |
| -: | :- |
| `0000 0000` - `0000 007F` | `0xxxxxxx`                            |
| `0000 0080` - `0000 3FFF` | `10xxxxxx xxxxxxxx`                   |
| `0000 4000` - `001F FFFF` | `110xxxxx xxxxxxxx xxxxxxxx`          |
| `0020 0000` - `0FFF FFFF` | `1110xxxx xxxxxxxx xxxxxxxx xxxxxxxx` |

It is clear that the number of protocol versions allowed by this encoding is given by 2<sup>28</sup> = 268,435,456.

Encoding a protocol number in this format proceeds as follows:

1. Determine the number of octets required from the protocol number
   and the first column of the table above.  It is important to note
   that the rows of the table are mutually exclusive, i.e., there is
   only one valid way to encode a given protocol number.

2. Prepare the high-order bits of the first octet as per the second
   column of the table.

3. Fill in the bits marked `x` from the bits of the protocol number,
   expressed in binary. Any remaining `x` bits should be filled with `0`.

Decoding a protocol number in this format proceeds as follows:

1. Determine the number of octets `n` from the length of the prefix.
   The prefix is composed of zero or more `1` bits followed by one `0`.

2. Read the first `n` octets and remove the first `n` bits from it
   (that is, the prefix).

3. The remaining bits encode the protocol number in binary.

Both procedures were implemented in Lua for reference ([encode.lua](../assets/cip-4/encode.lua), [decode.lua](../assets/cip-4/decode.lua)).
To avoid any doubts, it's also instructive to give here some examples of encoded protocol numbers:

| protocol number<br>(decimal) | octet sequence<br>(binary) |
| -: | :- |
| 42 | `00101010` |
| 721 | `10000010 11010001` |
| 123456 | `11000001 11100010 01000000` |
| 123456789 | `11100111 01011011 11001101 00010101` |

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
