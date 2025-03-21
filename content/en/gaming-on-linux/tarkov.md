---
tags:             ['EFT', 'EscapeFromTarkov', 'Tarkov', 'GNU/Linux', 'Proton', 'Wine']
categories:       ['Gaming']
title:            "Escape from Tarkov: Yes! GNU/Linux runs it!"
date:             2022-02-12T09:57:51-05:00
draft:            false
hideToc:          false
enableToc:        false
enableTocContent: false
meta_image:       "images/Escape-from-Tarkov-header.jpg"
---

Escape from Tarkov is hyper-realistic first person shooter game including survival, weapon
personalization, looting and questing mechanics. It is a well-known game which has been available to
play since 2016. However this game has stayed in Beta state since then, it is perfectly correct to
call this game full featured.

![EFT_splash](/images/Escape-from-Tarkov-header.jpg "Escape from Tarkov Splash Screen")

Yes, the title says that GNU/Linux runs EFT (Escape from Tarkov), but does that mean that [BSG][]
(BattleStateGames), the game studio, has made a fully supported Linux port? Well, no. But that is
not surprising at all!

Indeed, most popular games that run on GNU/Linux actually don't run natively, but use a platform
compatibility tool that is called [Wine][] (Wine Is Not an Emulator). This compatibility tool has
been developed since 1993 by its community and with the support of [CodeWeavers][].

[BSG]: https://www.battlestategames.com/
[Wine]: https://www.winehq.org/
[CodeWeavers]: https://www.codeweavers.com/

In the recent years, the company [Valve][], well-known for their software [Steam][], have been
developing [Proton][] a compatibility tool much like Wine. Actually, Proton is really just Wine but
tuned by the hand of Valve for assuring that their product Steam can make their offered games run
without any intervention by the user.

[Proton]: https://github.com/ValveSoftware/Proton
[Steam]: https://store.steampowered.com/
[Valve]: https://www.valvesoftware.com/

### EFT works well on GNU/Linux

The following screen capture have been taken from within the game running on GNU/Linux.

{{< image-gallery gallery_dir="tarkov" >}}

There are a few YouTube videos that demonstrate it. For example, there's this one which makes a sort
of benchmark comparison between Windows and GNU/Linux:

<div style="text-align:center">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/sWqpHZvbaRY" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
  </br></br>
</div>

There's this one which demonstrates playable features, which is everything except online raids:

<div style="text-align:center">
  <iframe width="560" height="315" src="https://www.youtube.com/embed/e74BT0u9_6E" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

And there are at least 650 people playing regularly which participate in discussions [on
Discord][eft-linux-discord].

[eft-linux-discord]: https://discord.gg/5zM86yJBYs

##### The Steam Deck

It is worth noting that the [Steam deck][steam-deck] runs literally a fork of [Archlinux][].
Therefore, this new product of Valve that has a ton of promises regarding the support it will
provide for the Steam library and other titles is a good reason for game developers to get
interested in Proton support. Indeed, it would be really nice to see EFT run on the Steam Deck and
it will.

[steam-deck]: https://www.steamdeck.com/
[Archlinux]: https://www.archlinux.org/

### But ...

There's a catch and it has a name: [BattlEye][].

[BattlEye]: https://www.battleye.com/

Indeed, because of this anti-cheat software, it is not possible to connect to the online raids which
is the main attraction of this game.

![BattlEye_err](/images/eft-battleye-error.png "BattlEye error message")

This is big bummer for Tarkov Penguins (as they call themselves on Discord) that have bought the
game as there is no progress saved when they play offline. But don't think that Tarkov Penguins want
to play without anti-cheat software. Anti-cheat support is exactly what they're asking for on the
EFT forums:

https://forum.escapefromtarkov.com/topic/157618-linuxmac-proton-support/
https://forum.escapefromtarkov.com/topic/161249-proton-support-a-single-e-mail-away/

and through a Twitch interview :smile::

<div style="text-align:center">
  <iframe src="https://clips.twitch.tv/embed?clip=HorribleInnocentReindeerYouDontSay-myi7a0MZVELZyRGf&parent=sim590.github.io" frameborder="0" allowfullscreen="true" scrolling="no" height="378" width="620"></iframe>
</div>

### BattlEye and Proton

BattlEye and Steam [have announced it][steam-announce]: enabling BattlEye on Proton will be as
simple as sending an e-mail.

<div align=center>
{{< tweet user="TheBattlEye" id="1441477816311291906" >}}
</div>

As per their [official documentation for Proton][proton-doc]:

>Proton supports BattlEye and BattlEye-enabled games. Each title requires a manual configuration
step, so please email your Valve or BattlEye technical contact for details.

[proton-doc]: https://partner.steamgames.com/doc/steamdeck/proton
[steam-announce]: https://store.steampowered.com/news/group/4145017/view/3104663180636096966

This is the result of a months of working between BattlEye and Valve. However, this doesn't mean
that this feature cannot be enabled for non-Steam games!

Indeed, any game developer that uses BattlEye as their anti-cheat solution can send an e-mail to
BattlEye and ask for updating **Proton BattlEye Runtime** so that it lets the game run it. That
would remove the error displayed above as a screen capture and let people using GNU/Linux play
ONLINE!

<!-- vim: set sts=2 ts=2 sw=2 tw=100 et :-->

