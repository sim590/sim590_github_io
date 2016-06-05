+++
categories = ['Google Summer Of Code']
date = "2016-06-03T00:02:37-04:00"
title = "Google Summer Of Code"
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

<div style="text-align:center"><img src="/img/ring.svg"/></div>

Ring is one of the few projects which bring communication confidentiality and
freedom in the hands of the users.

[Savoir-Faire Linux]: https://savoirfairelinux.com
[Ring]: https://ring.cx

## OpenDHT

Ring is divided in multiple components as explained here:
https://ring.cx/en/about/technical. The component I work on is called
[OpenDHT][]. This is the [distributed hash table][] which enables Ring users to
communicate in a decentralized network.

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
