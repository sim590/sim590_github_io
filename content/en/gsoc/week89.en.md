+++
series      = ['Google Summer Of Code']
date        = "2016-07-25T19:41:44-04:00"
description = "Jet lag & PHT"
title       = "[GSOC] Week 8&9 Report"
+++

## Week 8

This particular week has been tiresome as I did catch a cold ;). I did come back
from Cape Town where [debconf][] taking place. My arrival at Montreal was in the
middle of the week, so this week is not plenty of news...

### What I've done

I have synced myself with my coworker Nicolas Reynaud, who's working on building
the indexation system over the DHT. We have worked together on critical
algorithms: concurrent maintenance of data in the trie (PHT).

[debconf]: {{< ref "gsoc/week567.en.md" >}}

## Week 9

### What I've done

Since my mentor, who's also the main author of OpenDHT, was gone for presenting
[Ring][] at the [RMLL][], I've been attributed tasks that needed attention
quickly. I've been working on making OpenDHT run properly when compiled with
some failing version of Apple's LLVM. I've had the pleasure of debugging obscure
runtime errors that you don't get depending on the compiler you use, but I mean
very obscure.

<div style="text-align:center"><img src="https://images.duckduckgo.com/iu/?u=http%3A%2F%2Fwanna-joke.com%2Fwp-content%2Fuploads%2F2013%2F11%2Ffunny-picture-programmers-problems.jpg&f=1"/></div>

I have released OpenDHT 0.6.2! This release was meant to fix a critical
functionality bug that would arise if one of the two routing table (IPv4, IPv6)
was empty. This was really critical for Ring to have the 0.6.2 version because
it is not rare that a user connects to some router not giving IPv6 address.

Finally, I have fixed some minor bugs in my work on the [queries][].

[Ring]: https://ring.cx
[RMLL]: https://sec2016.rmll.info/
[queries]: {{< ref "gsoc/week34.en.md" >}}
