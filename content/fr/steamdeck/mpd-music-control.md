---
tags:              ['Steam Deck', 'mpd', 'MusicControl', 'Decky', 'Greffon']
categories:        ['Techno']
title:             "Contrôle intégré de MPD sur la Steam Deck"
date:              2022-12-29
description:
draft:             false
hideToc:           false
enableToc:         true
enableTocContent:  false
meta_image:        "images/steamdeck/mpd/mpd.png"
---

En tant que vétéran (GNU)Linux aguerri et de fan de technos libres, je me suis
donné l'occasion d'expérimenter plusieurs programmes dont j'ai développé une
dépendance avec certains d'eux, et avec raison. C'est le cas du programme MPD
(Music Player Daemon) qui est un programme de lecture de musique roulant en mode
serveur. On l'utilise donc normalement en pair avec un client comme [mpdevil][].
Personnellement, j'utilise [ncmpcpp][] et il y a une [longue liste de
clients][clients-mpd] pour MPD avec des fonctionnalités variées. Depuis que j'ai
reçu ma Steam Deck, j'ai donc bien sûr installé MPD sur celle-ci afin de pouvoir
contrôler avec mon téléphone (via [MPDroid][]) la musique qui joue sur ma Steam
Deck connectée à ma télé ou à mes écouteurs Bluetooth. Par contre, je n'avais
pas encore de moyen de contrôler MPD par la Steam Deck directement autrement
qu'en utilisant une app graphique comme mpdevil, mais c'était handicapant
considérant le type de contrôle (joystick ou trackpad) à notre disposition.
Parfois, on peut se trouver à utiliser la Steam Deck avec une manette bluetooth,
donc on n'a pas envie d'une interface qui est prévue pour la souris, quand on
n'a qu'un joystick à portée de main.

Je connaissais [MusicControl][] depuis un certain temps qui fournit une très
jolie interface pour contrôler un lecteur de musique interfaçant avec DBUS par
le biais de la spécification [MPRIS][], mais je n'avais pas réalisé depuis
comment connecter MPD avec ce joli greffon. Maintenant, c'est chose fait et je
vais partager comment y arriver dans ce billet de blog.

## Vue d'ensemble

Pour arriver à faire fonctionner le tout ensemble, il faut faire certaines
étapes d'installation. Dans un premier temps, il faut assembler les parties du
côté de MPD, soient:

* MPD: le lecteur de musique
* [mpdris2][]: programme interfaçant MPD à travers DBUS

Ensuite, il faut installer la partie du contrôleur, c.-à-d. MusicControl. Ce
greffon a besoin, pour fonctionner, de la plateforme [Decky][], un gestionnaire
et lanceur de greffon pour le mode Gaming de la Steam Deck. On trouve les
instructions d'installation sur la page du programme, mais je vais les
expliciter ici tout de même.

## Installation

Pour la partie MPD, il s'agit d'utiliser `pacman` pour installer `mpd`. Il faut
donc passer sur le mode Bureau de la Steam Deck et ouvrir le terminal Konsole.
___

Je conseille au lecteur de regarder le projet [rwfus][] avant d'aller plus loin
_s'il souhaite avoir une installation persistante_ car il faut savoir que la
Steam Deck utilise une approche de partitionnement fusionnée A/B comme
l'explique [cet article][partab]. En clair, cela veut dire que tout programme
installé par `pacman` (qui vit dans le répertoire `/usr`) sera possiblement
effacé lors de mise-à-jour subséquentes de la Steam Deck. Il s'agit d'une
mesure de protection pour la Steam Deck de sorte à pouvoir retourner à une
version fonctionnelle du système si jamais une mise-à-jour engendrait un échec
fatal.

Si le lecteur souhaite seulement essayer la démarche du présent article sans
tout de suite s'entourlouper avec les préoccupations au niveau des partitions
non persistantes, alors il peut passer outre la mesure de protection mettant le
système de fichier en lecture seule avec:

```
sudo steamos-readonly disable
```
___

Maintenant que nous avons parlé de ce détail, passons aux étapes
d'installation. Premièrement, on installe `mpd`:

```
sudo pacman -S mpd
```

Ensuite, on veut installer `mpdris2`. Pour ce faire, on peut soit utiliser
[yay][] en faisant:

```
yay -S mpdris2
```

et en suivant les instructions à l'écran.
___

<center>
  <big>
  <i>Sinon, ...</i>
  </big>
</center>
</br>

On peut installer manuellement le programme `mpdris2` comme suit:

```
cd /tmp/
git clone https://aur.archlinux.org/mpdris2.git
makepkg -si
```

Par contre, l'usager doit savoir qu'il devra installer toutes les dépendances
d'exécution et de compilation avant les procéder aux instructions ci-haut. D'où
l'avantage de passer par `yay` qui s'occupe de tout cela pour nous en plus de
nettoyer les dépendances de compilation une fois le programme désiré installé.
___

Une fois ceci fait, on doit démarrer les deux services, soient celui de `mpd` et
celui de `mpdris2`:

```
systemctl --user enable --now mpd.service
systemctl --user enable --now mpDris2.service
```

Je considère que l'utilisateur connait bien le mode de fonctionnement et de
configuration de MPD. C'est donc dire que je n'entrerai pas dans ces détails.

Maintenant, on doit installer Decky. Pour ce faire, on utilise l'instruction
partagée sur la [page d'installation par le projet][decky-install]:

```
curl -L https://github.com/SteamDeckHomebrew/decky-loader/raw/main/dist/install_release.sh | sh
```


Une fois ceci fait, on peut passer au mode Gaming de la Steam Deck. À cette
étape, on peut ouvrir le menu d'options rapides de la Steam Deck avec le bouton
<img style=display:inline-block src="/images/steamdeck/qam-light.svg"
height=16>. Dans le menu de Decky,

![](/images/steamdeck/mpd/menu-decky.png)

on peut sélectionner l'icône du magasin:

![](/images/steamdeck/mpd/magasin-decky.png)

et y trouver MusicControl:

![](/images/steamdeck/mpd/installation-musiccontrol.png)

Simplement, sélectionner l'option "install" et hop! L'utilisateur devrait alors
remarquer qu'il peut contrôler `mpd` par MusicControl!

![](/images/steamdeck/mpd/mpd-musiccontrol.png)

## Conclusion

En assemblant différents morceaux, on arrive à un résultant qui donne
l'impression d'une intégration prévue à cet effet, donc une sensation d'une mise
en place adéquate dans le système. Or, ce sont nos choix en pair avec l'accord
sur une spécification entre différents programmes libres qui mènent vers
l'achèvement de cet assemblage et cela est très satisfaisant car on voit ici
qu'on a un contrôle sur le logiciel qu'on manipule. Ceci se démarque fermement
du modèle tout-en-un auquel on reconnaît la plus part des produits propriétaires
(vendus ou non), c.-à-d. à licence fermée. À la fin, le logiciel libre
triomphera toujours!

[mpdevil]: https://github.com/SoongNoonien/mpdevil
[ncmpcpp]: https://github.com/arybczak/ncmpcpp
[clients-mpd]: https://www.musicpd.org/clients/
[MPDroid]: https://play.google.com/store/apps/details?id=com.namelessdev.mpdroid&gl=US&pli=1
[MusicControl]: https://github.com/mirobouma/MusicControl
[MPRIS]: https://specifications.freedesktop.org/mpris-spec/latest/
[mpdris2]: https://aur.archlinux.org/packages/mpdris2
[Decky]: https://github.com/SteamDeckHomebrew/decky-loader
[rwfus]: https://github.com/ValShaped/rwfus
[partab]: https://www.svenknebel.de/posts/2022/5/2/
[yay]: https://aur.archlinux.org/packages/yay
[decky-install]: https://github.com/SteamDeckHomebrew/decky-loader#-installation

