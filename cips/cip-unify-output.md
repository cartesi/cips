---
cip: unify-outputs
title: Unify Rollups outputs
status: Draft
type: Core
author: Augusto Teixeira (idea by Diego Nehab)
created: 2022-04-11
---

## Abstract

This CIP suggests unifying Notices and Vouchers into a single entity called Outputs.
At the same time, we suggest an encoding system that would allow distinguishing Notices from Outputs by decoding their headers.
This would simplify the implementation of the Machine Server and allow for new types of outputs in the future.

## Motivation

Cartesi Rollups currently has two types of "provable" outputs: Vouchers and Notices.
While Vouchers can be executed on L1, Notices exist solely for verification.
This difference in functionality is only visible on the blockchain and not on the emulator.
This induces three problems:
- the Server Manager has to deal with details that are not relevant at that level;
- the existence of multiple outputs leaks to other parts of the system, adding complexity to internal API's and the code;
- it becomes very difficult to add a new type of output, since this requires changes throughout several repositories.

## Specification

This CIP determines that from the perspective of the emulator, vouchers and notices should be unified into a single entity, called *outputs*.
The same goes for the Machine Server, which will no longer keep track of two Merkle Trees (one for Vouchers and one for Notices).
Instead, the Epoch Hash will be determined simply by the hashes of the *output tree* and of the machine state.

The distinction between Vouchers and Notices will be done through the *output*'s encoding, following the specification below.

Every *output* will be composed of a four bytes header and a payload.
The four bytes will specify the type of output that has been emitted, which in turn is enough to determine how it should be encoded/decoded.
See diagram below:

```
+----------+--------------------------+
|  header  | contents                 |
+----------+--------------------------+
|  0023af  | 28b928d8...              |
+----------+--------------------------+
```

Future CIPs can introduce other types of outputs, and they will be referred to with the convention `OUT-<header-without-leading-zeros>`.
So for example the output with header `00000b10` will be called `OUT-0b10`.

The current CIP already introduces two output encodings, in order to properly replace Vouchers and Notices.

**Notice Output** (`OUT-04`) This will contain a simple payload to be proved on-chain.
The memory layout of the data is given by:
- 4 bytes for the `00000004` header;
- 28 bytes of zeros;
- 32 bytes for the big-endian representation of the payload's length;
- payload padded with zeros to align with 32 bytes;
- extra padding with zeros to reach the length of the output:

```
+----------+----------------+------------------------+------------------+------+
|  header  | pad (28 bytes) | big-end len (32 bytes) | payload (32 * k) | pad  |
+----------+----------------+------------------------+------------------+------+
|  000004  | 000000000...   | 28b80000...            | c8a79eb87...     | 0... |
+----------+----------------+------------------------+------------------+------+
```

The reason to introduce 28 bytes of zeros after the header is to make all fields aligned with 32 bytes words, which are cheaper to load on the EVM.

**Voucher Output** (`OUT-06`) These represent transactions that can be executed on L1 (only once) on behalf of the Rollups contract.
They are composed of:
- the 4-bytes `00000006` header;
- 28 bytes of zeros;
- 20 bytes address, padded to the left to become 32-bytes long;
- 0x40, padded with 31 bytes of zeros to the left;
- 32 bytes big-endian representation of the length;
- payload padded with zeros to the right in order to align with 32 bytes;
- padding with zeros to reach the length of the output:

```
+----------+----------------+-------------------------+------------------+-
|  header  | pad (28 bytes) | 12 zero bytes + address | constant         | ...
+----------+----------------+-------------------------+------------------+-
|  000006  | 000000000...   | 0000000...0000a399be... | 00000000..000040 | ...
+----------+----------------+-------------------------+------------------+-


   -+------------------------+------------------+----------+
... | big-end len (32 bytes) | payload (32 * k) | padding  |
   -+------------------------+------------------+----------+
... | 28b80000...            | c8a79eb87...     | 00000... |
   -+------------------------+------------------+----------+

```

The Output Contract will also have to be changed accordingly, notably addressing the following points:
- the Epoch Hash has to be calculated from solely two hashes (Output Tree Hash) and (Machine State Hash);
- there will be a single method `verifyContents`, to validate the proofs of outputs;
- there will be one specific function for each type of outputs (currently Vouchers and Notices) that will make use of the `verifyContents` function above before parsing and acting accordingly.

This CIP does not require any changes to the Query Container or the HTTP API, having minimal impact on the application development.

## Rationale

The above design simplifies the off-chain code of the Server Manager, which is desirable.

However, one of the main advantages of this new design is that it allows for the creation of new types of outputs with not changes being necessary on the Server Manager.

Vouchers to be introduced in the future could have special properties, like:
- having a separate vault for their assets;
- being ordered;
- paying immediate and transparent fees to executors.

## Security Considerations

A new attack is possible under this CIP, in which one type of output pretends to be another.
For example, the application could try to emit a notice and end up producing an unwanted voucher.
This type of problems would require the attacker to get control over the application code (because sending a voucher instead of a notice would violate the Output's API).
Therefore, this does not decrease the security of the application as a whole, since taking control over the application already allows the attacker to send arbitrary vouchers on the Rollups behalf.

## References

[Output implementation](https://github.com/cartesi/rollups/blob/main/contracts/OutputImpl.sol)

## Copyright

Copyright and related rights waived via [CC0](https://creativecommons.org/publicdomain/zero/1.0/).
