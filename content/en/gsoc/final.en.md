+++
series = ['Google Summer Of Code']
date = "2016-08-19T12:04:13-04:00"
description = ""
title = "[GSOC] Final report"

+++

<div style="float:right">
    <img width="250" src="/images/gsoc.png"/><br>
    <div style="text-align:center">
        <img width="150" src="/images/debianlogo.svg"/><br><br>
        <img width="250" src="/images/ring.svg"/>
    </div>
</div>

The Google Summer of Code is now over. It has been a great experience and I'm
very glad I've been able to make it. I've had the pleasure to contribute to a
project showing very good promise for the future of communication: [Ring][]. The
words "privacy" and "freedom" in terms of technologies are being more and more
present in the mind of people. All sorts of projects wanting to achieve these
goals are coming to life each days like decentralized web networks ([ZeroNet][]
for e.g.), blockchain based applications, etc.

[Ring]: https://ring.cx
[ZeroNet]: https://zeronet.io/

## Debian

I've had the great opportunity to go to the Debian Conference 2016. I've been
introduced to the debian community and debian developpers ("dd" in short :p). I
was lucky to meet with great people like the president of the FSF, John
Sullivan.  You can have a look at my Debian conference report [here]({{< ref
"gsoc/week567.en.md" >}}).

If you want to read my debian reports,  you can do so by browsing the "Google
Summer Of Code" category on this blog.

## What I have done

Ring is now in [official debian
repositories](https://packages.qa.debian.org/r/ring.html) since June 30th. This
is a good news for the GNU/Linux community. I'm proud to say that I've been able
to contribute to debian by working on [OpenDHT][] and developing new
functionalities to reduce network traffic. The goal behind this was to finally
optimize the [data persistence][] traffic consumption on the DHT.

**Github repository**: https://github.com/savoirfairelinux/opendht

[OpenDHT]: http://opendht.net
[data persistence]: http://sim590.github.io/post/gsoc/intro/#data-persistence:34c4da6d4768d05e50db99357a299b5c

### Queries

Issues:

- [#43](https://github.com/savoirfairelinux/opendht/issues/43): DHT queries

Pull requests:

- [#79](https://github.com/savoirfairelinux/opendht/pull/79): [DHT] Queries: remote values filtering
- [93](https://github.com/savoirfairelinux/opendht/pull/93): dht: return consistent query from local storage
- [#106](https://github.com/savoirfairelinux/opendht/pull/106): [dht] rework get timings after queries in master

### Value pagination

Issues:

- [#71](https://github.com/savoirfairelinux/opendht/issues/71): [DHT] value pagination

Pull requests:

- [#110](https://github.com/savoirfairelinux/opendht/pull/110): dht: Value pagination using queries
- [#113](https://github.com/savoirfairelinux/opendht/pull/113): dht: value pagination fix

### Indexation (feat. Nicolas Reynaud)

Pull requests:

- [#77](https://github.com/savoirfairelinux/opendht/pull/77): pht: fix invalid comparison, inexact match lookup
- [#78](https://github.com/savoirfairelinux/opendht/pull/78): [PHT] Key consistency

### General maintenance of OpenDHT

Issues:

- [#72](https://github.com/savoirfairelinux/opendht/issues/72): Packaging issue for Python bindings with CMake: $DESTDIR not honored
- [#75](https://github.com/savoirfairelinux/opendht/issues/75): Different libraries built with Autotools and CMake
- [#87](https://github.com/savoirfairelinux/opendht/issues/87): OpenDHT does not build on armel
- [#92](https://github.com/savoirfairelinux/opendht/issues/92): [DhtScanner] doesn't compile on LLVM 7.0.2
- [#99](https://github.com/savoirfairelinux/opendht/issues/99): 0.6.2 filenames in 0.6.3

Pull requests:

- [#73](https://github.com/savoirfairelinux/opendht/pull/73): dht: consider IPv4 or IPv6 disconnected on operation done
- [#74](https://github.com/savoirfairelinux/opendht/pull/74): [packaging] support python installation with make DESTDIR=$DIR
- [#84](https://github.com/savoirfairelinux/opendht/pull/84): [dhtnode] user experience
- [#94](https://github.com/savoirfairelinux/opendht/pull/94): dht: make main store a vector<unique_ptr<Storage>>
- [#94](https://github.com/savoirfairelinux/opendht/pull/95): autotools: versionning consistent with CMake
- [#103](https://github.com/savoirfairelinux/opendht/pull/103): dht: fix sendListen loop bug
- [#106](https://github.com/savoirfairelinux/opendht/pull/107): dht: more accurate name for requested nodes count
- [#108](https://github.com/savoirfairelinux/opendht/pull/108): dht: unify bootstrapSearch and refill method using node cache

### View by commits

You can have a look at my work by commits just by clicking this link:
https://github.com/savoirfairelinux/opendht/commits/master?author=sim590

## What's left to be done

### Data persistence

The only thing left before achieving the totality of my work is to rigorously
test the data persistence behavior to demonstrate the network traffic reduction.
To do so we use our [benchmark python module][]. We are able to analyse traffic
and produce plots like this one:

<div style="text-align:center">
<img src="/images/gsoc/traffic.plot.png"/><br>
<b>Plot:</b> 32 nodes, 1600 values with normal condition test.
</div>

This particular plot was drawn before the enhancements. We are confident to
improve the results using my work produced during the GSOC.

### TCP

In the middle of the GSOC, we soon realized that passing from UDP to TCP would
ask too much efforts in too short lapse of time. Also, it is not yet clear if we
should really do that.

[benchmark python module]: https://github.com/savoirfairelinux/opendht/tree/master/python/tools
