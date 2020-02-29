+++
series = ['Google Summer Of Code']
date = "2016-07-10T19:12:18+02:00"
description = ""
title = "[GSOC] Week 3&4 Report"
+++

I have finally made a version of the [queries][] code that can viably be
integrated into the master branch of OpenDHT. I am awaiting my mentor's
approval and/or comments.

[queries]: {{< ref "gsoc/week1.en.md" >}}

## What's done

**Queries**. The library will provide the additional following functions in its
API:
```cpp
void get(InfoHash id, GetCallbackSimple cb, DoneCallback donecb={}, Value::Filter f = Value::AllFilter(), Where w = {}) {
void query(const InfoHash& hash, QueryCallback cb, DoneCallback done_cb = {}, Query q = {});
```
The structure `Where` in the first signature will allow the user to narrow the
set of values received through the network those that verify the "where"
statement. The `Where` actually encapsulates a statement of the following
SQL-ish form: `SELECT * WHERE <some_field>=<some_field_value>`.

Also, the `DhtRunner::query` function will let the user do something similar to
what's explained in the last paragraph, but where the returned data is
encapsulated in `FieldValueIndex` structure instead of `Value`. This structure
has a `std::map<Value::Field, FieldValue>`. You can think of the
`FieldValueIndex` as a subset of fields of a given `Value`. The `Query`
structure then allows you to create both `Select` and `Where` "statements".

## What's next

- **Value pagination**. I have begun working on this and I now have a more clear
  idea of the first step to accomplish. I have to redesign the 'get' operation
  callbacks calling process by making a callback execution per `SearchNode`
  instead of per `Search` (list of `SearchNode`). This will let us properly
  write the value pagination code with node concurrency in mind. This will
  therefor make sure we don't request a value from a node if it doesn't stores
  it;
- Optimizing announce operations;
