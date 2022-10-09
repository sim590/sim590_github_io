---
tags:              ['Steam Deck', 'mpv']
categories:        ['Techno']
title:             "Transformer sa Steam Deck en Chromecast?"
date:              2022-10-09
description:
draft:             false
hideToc:           false
enableToc:         true
enableTocContent:  false
meta_image:        "images/steamdeck/mpv/mpv.png"
---

J'avais commandé une [Steam Deck][steamdeck], un terminal mobile (selon [la traduction de
l'OQLF][oqlf-hanheld]) basé sur [Archlinux][], dès le moment que j'ai appris l'existence de ce
projet par [Valve][]. Ce terminal mobile est en fait un ordinateur complet ayant comme principale
fonction de fournir une plateforme de jeu portable, mais en réalité il permet une panoplie de choses
qui la rend capable de surpasser la compétition.

![steamdeck](/images/steamdeck/steamdeck.png)

Pourquoi ? Pour plusieurs raisons, mais principalement parce que je crois que c'est un appareil qui
jouera un rôle central dans le cheminement de GNU/Linux vers un statut de système plus populaire
chez les gens moins techniques et non initiés.

Cet appareil est super autant pour les gens qui aiment bidouiller que les gens lambdas. Autrement
dit, l'appareil offre toutes les fonctions nécessaires pour jouer à des jeux sans se casser la tête
tout en permettant à ceux qui veulent plus de creuser et s'amuser pleinement.

Dans le cadre de mes expériences avec cet appareil, j'ai pu:

* faire fonctionner des émulateurs de jeu pour toutes les plateformes que j'aime bien;
* rouler tout plein de jeux Windows qui n'ont pas été prévus pour jouer sur GNU/Linux;
* [installer des greffons][greffons] pour augmenter l'expérience de l'environnement de jeu de la
Steam Deck;
* installation de logiciels serveur comme MPD pour jouer de la musique dans mon salon avec mon
téléphone comme terminal de contrôle;
* installer des vieux logiciels comme Heroes of Might and Magic 3 avec une prise en charge de TCP/IP
grâce à WINE, `winetricks` et DirectPlay (un projet qui n'est plus pris en charge sur Windows).

Bref, la liste est longue et elle continuera d'augmenter.

## Chromecast?

OK, c'est pas exactement comme une Chromecast, mais c'est assez proche et pour quelqu'un d'un
minimum technique, c'est faisable en quelques minutes. L'approche que je propose est d'utiliser
[MPV][], un lecteur vidéo très puissant, plutôt connu chez les linuxiens. Le but est de permettre
d'utiliser la Steam Deck pour afficher une vidéo sur la télé (branchée sur la Steam Deck) dans le
confort de son divan.

![mpv](/images/steamdeck/mpv/mpv.png)

Le programme MPV admet les options suivantes qui seront utiles:

```
--keep-open
--force-window
--input-ipc-server
```

Les deux premières options sont évidentes, elles permettent de garder la fenêtre ouverte en tout
temps même lorsque la vidéo termine.

La dernière option permet de rouler un serveur qui recevra des commandes au format JSON sur un
connecteur logiciel (socket en anglais).

Finalement, on utilisera `ssh` afin d'envoyer les commandes à la Steam Deck à partir de son
ordinateur. Personnellement, j'utilise le navigateur [Qutebrowser][] pour envoyer mes commandes à la
Steam Deck. Ce navigateur est fait pour les utilisateurs désirant exploiter la puissance de leurs
outils. Entre autres, il a un système de configuration aisé permettant l'appel de commandes système.
Ce faisant, j'utilise simplement deux touches pour démarrer la vidéo sur ma Steam Deck sur l'URL de
la page où je navigue.

## Comment on fait

J'explicite, dans ce qui suit, le tout de ce que j'ai décrit dans les grandes lignes précédemment.

### Serveur IPC

Premièrement, sur la Steam Deck, il est nécessaire d'installer MPV. Pour ce faire, il est recommandé
d'utiliser flatpak puisque le système de la Steam Deck est un quelque peu limité en ce qui a trait à
l'installation par le gestionnaire de paquets Pacman d'Archlinux. En effet, les paquets installés
par le gestionnaire usuel seront possiblement supprimés par les mises à jour successives de la Steam
Deck. Ce faisant, on peut installer MPV avec:

```
flatpak install flathub io.mpv.Mpv
```

ou simplement par le biais du gestionnaire d'applications graphique.

Maintenant, afin de permettre la lecture d'URLs sur Internet, on doit installer `yt-dlp` qui prend
en charge le téléchargement de ces flux pour les fournir à MPV. Pour ce faire, on doit premièrement
désactiver le blocage en lecture seule du système de fichier sur la Steam Deck:

```
sudo steamos-readonly disable
```

Ensuite, on prépare Pacman:

```
sudo pacman-key --init
sudo pacman-key --populate archlinux
```

et finalement on installe `yt-dlp`:

```
sudo pacman -S yt-dlp
```

**NOTE**: comme les paquets installés par Pacman sont possiblement supprimés suivant des mises à
jour, ces étapes seront possiblement à répéter dans le futur. Si cela est indésirable pour vous,
alors vous devriez ajuster ces étapes pour faire une installation locale sous `/home/deck/` de sorte
à empêcher que soit écrasé `yt-dlp`.

Une fois ceci fait, écrivons le script suivant sous `~/bin/mpv-server.sh`:

```
#!/usr/bin/env bash

flatpak run io.mpv.Mpv --keep-open --force-window --input-ipc-server=/tmp/mpv.socket ~/Images/Icônes/mpv.png
```

Il est nécessaire d'utiliser un fichier multimédia pour ouvrir `mpv` et le garder ouvert en
attendant les commandes du client. Ce faisant, on utilise une image nommée `mpv.png` (l'image que
j'ai inclus dans cet article un peu plus haut). Il faut donc enregistrer cette image à l'endroit
correspondant à l'argument qu'on a donné à MPV dans le listage de code ci-haut.

Par la suite, on ajoute ce script comme un "jeu non-steam" par l'interface de Steam:

![jeu-non-steam](/images/steamdeck/mpv/jeu-non-steam.png)

Un fois ceci fait, lorsqu'on se trouve dans le mode jeu de la Steam Deck, on aura l'application
`mpv-server.sh` qu'on pourra démarrer avant d'envoyer des commandes de lecture de la part du client:

![mpv-mode-jeu](/images/steamdeck/mpv/mpv-mode-jeu.png)

Par contre, pour acheminer les commandes, on utilise `ssh`. Le serveur SSH doit donc être activé en
tout temps. Pour ce faire, rouler:

```
sudo systemctl enable --now sshd
```

Voilà, c'est tout ce qu'il y a à faire du côté de la Steam Deck.

### Client IPC

Maintenant, du côté de l'ordinateur client (une machine GNU/Linux), on créé un script nommé
`steamdeck-play` (ou comme on veut) avec le contenu suivant:

```sh
#!/usr/bin/env bash

program_name="steamdeck-play" options='hvt' loptions='help,version,toggle' version=0.1
getopt_out=$(getopt --name $program_name --options $options --longoptions $loptions -- "$@")
if (( $? != 0 )); then exit 1; fi

#sets the positionnal parameters with getopt's output
eval set -- "$getopt_out"

print_help() {
cat <<EOF
${program_name} -- play a video on the Steam Deck

SYNOPSIS
  $program_name [OPTIONS] URL

OPTIONS
  -h|--help
    Shows this help text.
  -v|--version
    Show the version information of the program.
  -t|--toggle
    Toggle playback.
EOF
}

send_mpv_command() {
  ssh deck@steamdeck.local "echo '{ \"command\": $@ }' | socat - /tmp/mpv.socket"
}

toggle=false

while [[ $1 != "--" ]]; do
  case "$1" in
    -h|--help)
      print_help
      exit 0
      ;;
    -v|--version)
      echo "${program_name} v${version}"
      exit 0
      ;;
    -t|--toggle)
      toggle=true
      shift
      ;;
  esac
done
# shift away from the last optional parameter (--)
shift

URL=$1
input_command_value=

if [[ "$toggle" == "true" ]]; then
  send_mpv_command "[\"keypress\", \"space\"]"
else
  send_mpv_command "[\"loadfile\", \"$URL\"]"
  send_mpv_command "[\"keypress\", \"space\"]"
fi
```

Ce script peut donc être appelé pour démarrer la lecture d'un contenu multimédia sur une URL prise
en charge par `yt-dlp`. On le place où bon nous semble de sorte à ce qu'on puisse l'appeler sur la
ligne de commande. Par exemple, je place personnellement les scripts que j'écris sous `~/bin/`.

Finalement, pour que cette approche fonctionne bien, on doit envoyer notre clef publique SSH du côté
du serveur. On fait cela avec la commande:

```
ssh-copy-id deck@steamdeck.local
```

## Utilisation

On peut utiliser le tout simplement avec le script `steamdeck-play`:

```
steamdeck-play 'https://www.youtube.com/watch?v=T90DbpCWk5k'
```

On peut (dés)activer la lecture avec:

```
steamdeck-play -t
```

À partir d'ici, vous pouvez ajuster l'utilisation à vos outils personnels. Je donne un exemple de
ce qui est possible de faire avec mon navigateur favoris dans la section suivante.

### Qutebrowser

Grâce au système de configuration de Qutebrowser, on peut simplement écrire:

```python
config.bind('xs',  'spawn steamdeck-play {url}')
config.bind(';xs', 'hint links spawn steamdeck-play {hint-url}')
```

Ce faisant, lorsqu'on se trouve sur la page Web de notre choix, on utilise `xs` pour démarrer la
vidéo sur l'URL courante. On peut utiliser `;xs` pour afficher des touches de sélection:

![qutebrowser-steamdeck-play](/images/steamdeck/mpv/qutebrowser-links.png)

En sélectionnant `ka`, je fais jouer la vidéo de la chanson La tête en gigue de Jim et Bertrand à
partir de mon ordinateur portable sur ma Steam Deck connectée sur le téléviseur.

## Conclusion

Le modèle de la Steam Deck permet une utilisation sans limite d'outils existants (sauf pour
Pacman...). Le fait que la Steam Deck est un ordinateur complet jumelé avec son format de terminal
mobile donne une tout autre dimension à la façon d'utiliser sa télé, sa plateforme de jeu et son
divan dans le salon! Je suis certain que dans le futur, il y aura d'autres approches moins manuelles
permettant de faire la même chose. Ceci dit, l'exercice dont j'ai fait la démonstration montre bien
à quel point on peut faire ce qu'on veut avec cet appareil et je crois qu'il s'agit là d'une
caractéristique bien importante d'un appareil qui vise à changer le portrait informatisé des foyers
adeptes des jeux vidéo et des technologies.

[steamdeck]: https://www.steamdeck.com/fr/
[Valve]: https://www.valvesoftware.com/
[oqlf-hanheld]: https://gdt.oqlf.gouv.qc.ca/ficheOqlf.aspx?Id_Fiche=8360495
[Archlinux]: https://www.archlinux.org/
[greffons]: https://linuxgamingcentral.com/posts/steam-deck-plugins/
[MPV]: https://mpv.io/
[Qutebrowser]: https://qutebrowser.org/

<!-- vim: set sts=2 ts=2 sw=2 tw=100 et :-->

