+++
author = ""
categories = ['Google Summer Of Code']
date = "2016-07-10T20:06:24+02:00"
description = "Debconf 2016"
title = "[GSOC] Week 5&6 Report"

+++

During week 5 and 6, [I have been to the debian conference 2016]({{< ref "post/adieu.md" >}}). It was really interesting meeting with a lot of people all so involved in Debian.

## Key signing party

Each year, this is a really important tradition: people gather together and
exchange GPG public key fingerprint and sign each other's keys. This contributes
greatly to the growth of the web of trust.

<div style="text-align:center"><img src="https://imgs.xkcd.com/comics/responsible_behavior.png"/></div>

I did exchange public key fingerprint with others. It was the first opportunity
become more connected in the PGP web of trust. I think this is something that
needs to make its way to the less technical people so that everyone can benefit
from the network privacy features. There is support for some mail clients like
[Thunderbird][], but I think there is still work to do there and mostly there is
work to do about the opinion or point of view people have about encryption ;
people don't care enough and they don't really know what encryption can do for
them (digital signature, trust and privacy).

[Thunderbird]: https://en.wikipedia.org/wiki/Mozilla_Thunderbird

## Ring now part of Debian

During the first week at debcamp, Alexandre Viau, an employee at Savoir-Faire
Linux and a also a Debian developer (DD for short), has packaged [Ring][] for
Debian. Users can now install Ring like so:

```sh
$ sudo apt-get install ring
```

This is an important moment as more people are now going to easily try Ring and
potentially contribute to it.

[Ring]: https://ring.cx

## Presentating Ring

Alexandre Viau and I have been thinking about presenting Ring at debconf 2016.
We finally did it.
<div style="text-align:center">
    <video width="640" controls>
      <source src="http://meetings-archive.debian.net/pub/debian-meetings/2016/debconf16/Decentralized_communications_with_Ring.webm" type="video/webm">
    Your browser does not support the video tag.
    </video>
</div>
