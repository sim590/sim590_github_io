---
title:             "Debian: passer à «testing»"
date:              2020-05-09T20:36:40-04:00
description:
draft:             false
hideToc:           true
enableToc:         false
enableTocContent:  false
tags:              ["GNU/Linux", "Aptitude", "Paquet Debian", "Branche Debian"]
categories:        ["Debian", "Techno"]
meta_image:        images/debian/Debian_logo.png
---

Debian est une des distributions de GNU/Linux les plus communes et robustes
grâce à son système de publication de version structuré et méticuleux. Les
versions passent par différents stades de développement appelés «branches». On
peut voir ces branches comme des «versions» de Debian qui ne sont pas figées
dans le temps contrairement aux publications de Debian. Par exemple, Buster est
le nom de la dernière version publiée par Debian à ce jour et la branche
correspondant à Debian est appelée `stable`. Par défaut, il s'agit de la branche
avec laquelle Debian s'installe. Comme le système de paquetage inclut d'abord
les paquets dans la branche `unstable`, puis `testing` et finalement `stable`,
les versions prennent un certains temps à aboutir. Ce faisant, ceci garantie une
stabilité aux utilisateurs (d'où le nom de la branche). Ceci dit, certains
utilisateurs plus avancés ayant le désir d'un système plus à jour peuvent
configurer leur système afin que celui-ci passe à `testing`. Ce processus est
très commun parmi les utilisateurs avancés et comporte pratiquement très peu
d'inconvénients. Pour plus d'information par rapport aux branches, voyez les
différents liens ci-après:

https://www.debian.org/releases/

https://www.debian.org/doc/manuals/debian-faq/debian-faq.fr.pdf (PDF)

Personnellement, je vois `testing` comme un bon compromis entre la fine pointe
et la robustesse du logiciel. Dans ce qui suit, je vous montre comment passer à
`testing` ainsi que comment adéquatement configurer `apt` pour garantir un fin
contrôle sur la source des paquets que vous téléchargez des branches `testing`,
`unstable` et `experimental`.

**N.B**: Je fais l'hypothèse que le lecteur se trouve sur Debian dans la branche
`stable` et que les fichiers de configuration qui se trouvent sur votre système
sont par défaut.

**N.B no. 2**: Le lecteur doit être avisé que les étapes de mise à jour que nous
effectuerons ne sont pas réversibles. Une fois passé à `testing`, on ne revient
pas dans `stable`. Si c'est absolument nécessaire, on doit alors réinstaller le
système. Si votre système possède une partition `/home` il est assez aisé de
réinstaller sans avoir à copier les données de votre répertoire utilisateur.
Ceci dit, il est toujours pertinent de faire une sauvegarde, le cas échéant.
Bien sûr, ce n'est pas nécessaire pour simplement passer à `testing`.

## /etc/apt/sources.list.d

Passer à une version subséquente de Debian consiste à installer les versions
plus à jour des paquets du système. Pour ce faire, on doit donc configurer la
source où on prendra ces paquets. Il faut donc déplacer (ou supprimer) le
fichier de configuration actuel là où il ne sera pas effectif.

```sh
rm /etc/apt/sources.list
```

Si le fichier précédent ne se trouvait pas à cet endroit au premier abord, vous
avez possiblement une configuration divisée en plusieurs fichiers de la forme
`/etc/apt/sources.list.d/*.list`. Si c'est le cas, veilliez à les retirer (ou
déplacer hors de `/etc/apt/sources.list.d/`).

Maintenant, il faut s'assure que le répertoire `/etc/apt/sources.list.d/`
existe.

```sh
mkdir -p /etc/apt/sources.list.d
```

Ensuite, il suffit de créer le fichier `/etc/apt/sources.list.d/testing.list`
contenant les sources de la branche `testing`:

```plain
deb http://ftp.ca.debian.org/debian/ testing main contrib non-free
deb-src http://ftp.ca.debian.org/debian/ testing main contrib non-free
```

Personnellement, j'inclus `non-free` car certains paquets qui s'y trouvent
peuvent être utiles, mais je dois avouer que le dernier paquet que j'ai utilisé
provenant de cette section `browser-plugin-freshplayer-pepperflash` et les pages
Flash ne courrent vraiment plus les rues de nos jours. Bref, ça ne fait pas de
mal de l'inclure.

Maintenant, il s'agit de passer à la nouvelle version. Premièrement, on met la
liste des sources à jour:

```sh
apt update
```

Ensuite, on peut mettre à jour les paquets comme tel:

```sh
apt upgrade
```

Finalement, pour permettre à `apt` de mettre à jour certains paquets impliquant
la suppression d'autres paquets ou l'installation de nouveaux paquets (ce que
upgrade ne fait pas par défaut), on doit faire:

```sh
apt dist-upgrade
```

Et voilà ! Vous êtes maintenant sur `testing`.

## À la fine pointe!

Un accès à `unstable` et `experimental` permet à l'utilisateur aisé de mettre la
main sur des paquets encore plus à jour. Ceci dit, le téléchargement n'est pas
toujours possible et peut engendrer des cassures de dépendance, donc c'est à
faire à vos propres risques et périls.

Premièrement, on crée les fichiers `/etc/apt/sources.list.d/unstable.list`:

```plain
deb http://ftp.ca.debian.org/debian/ unstable main contrib non-free
```

et `/etc/apt/sources.list.d/experimental.list`:

```plain
deb http://ftp.ca.debian.org/debian/ experimental main contrib non-free
```

*Très bien, mais ce n'est pas tout!*

Ici, il est primordial d'apparier cette configuration à un triplet de fichiers
qui dictera l'ordre de priorité des sources. En effet, tel que configuré
jusqu'ici, toutes les sources seraient en concurrence et la version la plus à
jour pour tous les paquets serait installée, c'est-à-dire que tous les paquets
(ou presque) passeraient à la version `experimental` ou `unstable` suivant une
mise à jour avec `apt update && apt upgrade` et ce n'est pas ce qu'on veut! Afin
de palier à ce problème, on assure premièrement la création du répertoire des
préférences:

```sh
mkdir -p /etc/apt/preferences.d
```

Maintenant, les 3 fichiers ci-après doivent être créés:

* `/etc/apt/preferences.d/testing`

    ```plain
    Package: *
    Pin: release a=testing
    Pin-Priority: 900
    ```

* `/etc/apt/preferences.d/unstable`

    ```plain
    Package: *
    Pin: release a=unstable
    Pin-Priority: 800
    ```

* `/etc/apt/preferences.d/experimental`

    ```plain
    Package: *
    Pin: release a=experimental
    Pin-Priority: 700
    ```

Les champs `Package`, `Pin` et `Pin-Priority` indiquent respectivement les
paquets, la branche de ceux-ci et l'indice de priorité. Plus le nombre est élevé
et plus la branche a priorité. Ce faisant, le lecteur comprend bien que
`testing` est configuré comme la branche principale. Les autres branches sont
accessibles, mais ne seront utilisées que si les paquets installés ne sont pas
disponibles dans la/les branche(s) avec la plus grande priorité.

Afin que les changements soient effectifs, il est nécessaire de rouler

```sh
apt update
```

Le tout permet donc finalement d'installer des paquets depuis `unstable`
simplement en passant l'option `-t` à `apt`. Par exemple, afin d'installer la
version de `vim` depuis `unstable`, il suffit d'exécuter:

```sh
apt install -t unstable vim
```

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

