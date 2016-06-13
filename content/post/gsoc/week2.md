+++
categories = ["Google Summer Of Code"]
date = "2016-06-13T00:22:58-04:00"
description = ""
title = "Week 2 - Report"

+++

I've been reworking the code for the queries I introduced in the [first week][].

[first week]: {{< relref "week1.md" >}}

## What's done

- I have worked on [value pagination][] and optimization of accnounce operations;
- Fixed bugs like [#72][], [#73][];
- I've split the `Query` into `Select` and `Where` strcutures. This change was
  explained
  [here](https://github.com/savoirfairelinux/opendht/issues/43#issuecomment-222795776).

## What's still work in progress

- Value pagination;
- Optimizing announce operations;

[value pagination]: https://github.com/savoirfairelinux/opendht/issues/71
[#72]: https://github.com/savoirfairelinux/opendht/issues/72
[#73]: https://github.com/savoirfairelinux/opendht/pull/73
