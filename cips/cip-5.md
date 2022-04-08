---
cip: 5
title: Aggregated Inputs Protocol
status: Draft
type: Core CIP
discussion-to: https://github.com/cartesi/cips/discussions/17
author: Augusto Teixeira
created: 2022-03-19
---

## Abstract

This CIP introduces a new Input Protocol (following the standards introduced in CIP-4) that gives the basis for the specification of aggregated inputs.
The specification laid down below splits the input into two parts, named the *Transactions* and the *Signatures*.

The role of the *Transactions* field is to store an array of transactions that have been encoded in this aggregated input.
While the *Signatures* field stores the data necessary to verify the integrity of the transactions.

It is also the task of this CIP to fully specify what is meant by a transaction.
Making it clear what will be the expected output of decoding of the *Transactions* field (to be consumed by the signatures verification procedure).

Finally we specify some naming conventions for Transactions and Signatures Protocols.

## Motivation

Rollups currently receive every input individually.
Therefore, there is considerable L1 fee involved in submitting a transaction to the Rollups application.
This cost corresponds to the cost of starting a transaction on L1.

One of the main advantages of Rollups is that it allows for the aggregation of inputs from several users into a single L1 interaction, reducing the L1 fees to data availability costs only.

There is however no universal specification of how these aggregated transactions should be encoded in order to be processed in a standard way inside Rollups in general and the Cartesi Machine in particular.
The objective of this CIP is to provide a first specification of these standards.

## Specification

According to the Input Protocol numbering system introduced in CIP-4.
Should CIP be accepted, it would reserve the protocol number 12 to the protocol below.
According to the naming conventions (in CIP-4), the protocol for Aggregated Inputs will be referred to as `IP-0c` or `IP-0c Aggregated Inputs`.

This CIP specifies the protocol for aggregated inputs.
The processing of them is done in two steps:
- decompress and decode transactions;
- verify their signatures.
Noting that this CIP does not specify the encoding of transactions or signatures.
These tasks are left for future CIP's.

### Input encoding

Every input abiding by this protocol will be composed of five parts (see table below):
- The *Header* for the input will be composed of four bytes describing (in little endian encoding) the length (in bytes) of the *Transactions* field.
- The *Transactions* field has length specified by the header above and it is composed of two parts:
  - The *Transactions Header* is composed of four bytes, specifying (in little endian) the *Transactions Protocol* used to encode the collection of transactions present in the input.
  - The *Transactions Payload* field contains the actual data representing the inputs and it should be encoded according to the Transactions Protocol described in the *Transactions Header* above.
- The *Signatures* field makes up the remainder of the message and it is composed of two parts, which mimic exactly the *Transactions* field:
  - The *Signatures Header* is composed of four bytes, specifying (in little endian) the *Signatures Protocol* protocol used to encode the collection of transactions present in the input.
  - The *Signatures Payload* field contains the actual data necessary for signature verification.
  It should be encoded according to the Signatures Protocol described in the *Signatures Header* above.

```
+-------------+-----------------------+----------------------+
|   Header    |      Transactions     |      Signatures      |
| (Tx length) |--------+--------------|--------+-------------|
|             | Header |   Payload    | Header |   Payload   |
+-------------+--------+--------------+--------+-------------+
```

This CIP does not specify any Aggregation Protocol or Signature Protocol, as these will be done in future CIPs.

### Transaction Formatting

When an aggregated input is received, the first step that needs to be done to process it is decoding the transactions contained in the *Transactions* field.

After this process is finished, we will be left with an array of transactions.

The code below describes the format that each transaction should be after they have been extracted:
```
{
  from: "0x1923f626bb8dc025849e00f99c25fe2b2f7fb0db",
  chainId: "0x29",
  raw: "0xf883800182033394...1491663"
}
```
where the field `raw` corresponds to the contents to be signed:
```
{
  nonce: "0x28",
  gasPrice: "0x1234",
  gasLimit: "0x1234",
  to: "0x07a565b7ed7d7a678680a4c162885bedbb695fe0",
  value: "0x1234",
  data: "0xdeadbeef"
}
```
encoded in the RLP format.
The `raw` field corresponds exactly to how transactions are submitted to the Ethereum network.

Note that the meta-parameters `from` and `chainId` can be recovered during the signature verification process.
Nonetheless they are present here for later verification.

Although we do not specify here any encoding for transactions, it is instructive to provide an example.
Here is a sample displaying how a transfer-only transaction could be to serialized in a fictitious *Transactions Protocol*:
```
{
  fromId (32bit)
  toId (32bit)
  amount (96bit)
  fee (48bit)
}
```
Observe that a few fields are missing in this example, such as `nonce` (which can be retrieved from L2) and data (which is not useful for ETH transfers).

### Signature Verification

After decoding an array of transactions from the *Transactions* field, the protocol should verify the validity of each signature.

Although the Signature Protocol is free to chose any cryptography scheme, it is desirable to use some system that facilitates the use of existing tools, such as Metamask.

Although this CIP does not specify any *Signatures Protocol*, it is instructive to consider two examples for illustration purposes:
- an array of `{v, r, s}` values (as specified in Ethereum), one triple per transaction;
- an aggregated signature scheme, such as BLS.

## Rationale

The main point of the current CIP is to specify an input that describes aggregated transactions, while observing the following points:
- the processes of encoding transactions and verifying their signatures should be split, in an effort to allow these very different tasks to evolve in separate;
- there should be freedom to chose between many different encodings of transactions and signatures as compression/aggregation techniques progress on each front.
- the "interface" between encoding transactions and verifying their signatures should be well established to fix a standard;

A few details of implementation are justified below:
- the endianess of header was chosen to match the Cartesi Machine's architecture, as transactions will not be aggregated by smart contracts;
- every header is 4 bytes long, to allow for a large range of values, but there is no need of extreme compression for fields that appear a single time in an aggregated block;
- the choice of transaction encoding (following the Ethereum standards) was done in order to minimize the friction between our system and existing Ethereum tools, such as Metamask.

## Security Considerations

This CIP leaves most of the implementation complex details to the Transactions Protocols and the Signatures Protocols.
Therefore, the vulnerabilities introduced by this CIP itself are minimal.
Although of course the tests should stress the decoding and malformed inputs to the maximum extent possible.

## Referring to Protocols

The suggestion of this CIP is that every Transactions Protocol should be identified by `TP-<header>`, where `<header>` stands for the hexadecimal description of the (4-bytes) header of the protocol.
Example `TP-0000ba23`.

Similarly, Signatures Protocols should be refereed by `SP-<header>`, such as `SP-0000bbf2`.

## References

[CIP-4](https://github.com/cartesi/cips/blob/input-protocol/cips/cip-4.md)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
