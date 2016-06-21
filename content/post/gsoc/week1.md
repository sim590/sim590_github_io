+++
categories = ["Google Summer Of Code"]
date = "2016-06-11T13:06:11-04:00"
title = "[GSOC] Week 1 - Report"
+++

I have been working on writing serializable structure for remote filtering of
values on the distributed hash table [OpenDHT][]. This structure is called
`Query`.

[OpenDHT]: http://opendht.net

## What's done

The implementation of the base design with other changes have been made. You can
see evolution on the matter
[here](https://github.com/savoirfairelinux/opendht/issues/43);

Changes allow to create a Query with a SQL-ish statement like the following

```cpp
Query q("SELECT * WHERE id=5");
```

You can then use this query like so

```cpp
get(hash, getcb, donecb, filter, "SELECT * WHERE id=5");
```

I verified the working state of the code with the [dhtnode][]. I have also done
some tests using our python benchmark scripts.

[dhtnode]: https://github.com/savoirfairelinux/opendht/blob/master/tools/dhtnode.cpp

## What's next

- [Value pagination][];
- Optimization of put operations with query for ids before put, hence avoiding
  potential useless traffic.

[Value pagination]: https://github.com/savoirfairelinux/opendht/issues/71

## Thoughts

The `Query` is the key part for optimizing my initial work on data persistence
on the DHT. It will enhance the DHT on more than one aspects. I have to point
out it would not have been possible to do that before our major refactoring we
introduced in
[0.6.0](https://github.com/savoirfairelinux/opendht/releases/tag/0.6.0).
