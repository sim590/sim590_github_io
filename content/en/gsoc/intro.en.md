+++
series      = ['Google Summer Of Code']
date        = "2016-06-03T00:02:37-04:00"
title       = "Google Summer Of Code"
description = ""
+++

I am part of the group of students working with the Debian organization. You can
see my profile on the Debian wiki [here](https://wiki.debian.org/SummerOfCode2016/StudentApplications/SimonD%C3%A9saulniers).

## Improving distributed and secure communication using free software

This the title of my project for this summer. It sounds good, but what am I
going to really do? Well, since I'm a student at Université du Québec à
Montréal, I have had the opportunity to meet with the company
[Savoir-Faire Linux][] in Montreal last year and that's when I found out about
their exciting project: [Ring][].

<div style="text-align:center"><img src="/images/ring.svg"/></div>

Ring is one of the few projects which bring communication confidentiality and
freedom in the hands of the users.

[Savoir-Faire Linux]: https://savoirfairelinux.com
[Ring]: https://ring.cx

## OpenDHT

Ring is divided in multiple components as explained here:
https://ring.cx/en/about/technical. The component I work on is called
[OpenDHT][]. This is the [distributed hash table][] which enables Ring users to
communicate in a decentralized network.

I have already been working on this project for a year now, so you won't see me
posting reports where I say I have to find my way around in this project. In
fact, I have contributed to rewriting a major part of the code for better
maintainability.

In the begining of last summer, I was able to be part of a research association
between Savoir-Faire Linux and Université du Québec à Montréal. We have been
working on adding two major features to OpenDHT.

### Short introduction to Distributed Hash Tables

OpenDHT is based on the [Kademlia design][]. If you know about DHTs, you are
aware that they define the notion of **distance** using the XOR metric. This
makes the tuple `(H_n, xor)` a metric space, where `H_n` is the space of
identifier keys of length `n`. This way, you can find an identifier be the
*closest* to a target hash than the rest of the nodes in the network.

<div style="text-align:center"><img src="/images/dht.eight.nodes.png"/></div>

In order to find some data that is associated with some hash `h`, you have to
find the nodes in the network for which the distance between their hash
identifier and the target hash `h` is minimized. The group of nodes which are
the closest to the target hash (OpenDHT allows up to 8 nodes) will hold data for
that hash.

[Kademlia design]: https://en.wikipedia.org/wiki/Kademlia

### Data persistence

Let's say you ask a group of 8 nodes to hold some data for a hash and you want
the data to hold the whole time until its expiration time as come. If the group
of 8 nodes change because that for some reason those nodes leave or others just
arrive and have an id that is closer to the target hash than the initial group
of 8 nodes. The data would then not be found on the new group of 8 nodes. A
first and simple solution was to count on the initial creator of the value to
periodically announce the value to the group of 8 nodes. However, what if this
node leaves? This is one of the main problem that I've been working on solving
since 2015. A first version of this was produced on September 2015. However, we
experienced traffic issues and were forced to redesign the OpenDHT network
requests engine. We are presently working on adding a Query feature that would
enable filtering of data on remote nodes, hence substantially lowering the
overall traffic produced by a response to a 'get' request.

### Indexation

During the last year, I have also been working on the design of a solution for
the use case of indexation. In a more technical way, this is the capability to
find data by providing a map where its key is a string field and the mapped
value is the value associated to that field, much like in a form. This could
help find data for which you don't know the hash, but you have specific
information about its content. In other words, this would be a search engine for
OpenDHT. I have already created a working, but still in progress, version of
this. You can find it on http://opendht.net, on the index branch. Now, Nicolas
Reynaud (kaldoran) is contributing to this during the GSOC.

[OpenDHT]: http://opendht.net
[distributed hash table]: https://en.wikipedia.org/wiki/Distributed_hash_table

## Roadmap

As I explained on my page on the Debian Wiki, I am going to work on:

1. Developing new functionalities in OpenDHT aiming at reducing overall
   generated traffic.
2. Maintenance and optimization of the OpenDHT code in general.
3. Optimizing data persistence solution over the distributed hash table.
4. Merge (1) in the Ring daemon component in order to benefit from lower traffic
   in Ring.
5. Make OpenDHT use TCP protocol instead of UDP. This is going to reduce code
   complexity and enhance robsutness of the DHT.

For further details, read my reports!
