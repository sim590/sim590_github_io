+++
categories = ['Techno', 'Outil', 'Éditeur de texte', 'Programmation']
tags       = ['Vim', 'hjkl', 'greffon']
title      = "Vim peut tout faire"
date       = 2020-03-22T11:11:56-04:00
meta_image = "images/vim/vim-peut-tout-faire/vim-all-the-things.png"
+++

Vim est un [éditeur de texte][editeur] et clairement le meilleur qui soit. Je ne
dis pas ça sans peser mes mots. Ceci dit, il ne faut pas lui prêter une identité
qu'il n'a pas. Vim n'est pas un environnement de développement intégré (EDI ou
IDE en anglais) complet.  Cependant, plusieurs aspects à son utilisation font sa
grande force pour fournir un EDI complet à son usager:

* un **langage de touches** permettant aux doigts de faire tout le travail
  d'édition de texte (couper, effacer, coller, réordonner, formater, etc.). En
  effet, dans une boîte de texte régulière (comme ce qu'on trouve dans les EDIs
  populaires) la modification de texte, et non la simple écriture, n'est pas
  chose facile. Elle demande souvent l'utilisation de la souris, donc la perte
  de la position des mains déjà en place pour écrire. De plus, cette approche
  est normalement très lente. Avec Vim, les doigts font le travail. La meilleure
  comparaison pour comprendre le sentiment est justement celle de l'écriture. On
  ne pense pas à trouver les touches pour écrire et cela se fait
  automatiquement. Pour la modification de texte avec Vim, c'est la même chose.
* un **langage de script** (*VimScript*) qui lui permet une haute extensibilité;
* une **intégration de l'interface système** (IS ou le *shell* en anglais).
  L'utilisation de l'IS est entièrement intégrée à travers VimScript ainsi que
  les différents modes de Vim (Normal, Visual, CMD, etc.). Je ne peux mettre
  assez l'accent sur comment ce trait de Vim est **si significatif**. Ce
  faisant, de manière totalement gratuite, un utilisateur de Vim bénéficie déjà
  des fonctionnalités de l'IS dans son éditeur de texte sans avoir recours à
  l'installation très particulière d'extension par son EDI. On dit souvent que
  l'IS constitue en réalité l'environnement de développement d'un utilisateur de
  Vim.
* une capacité d'intégrer des **greffons** (*plugins* en anglais);
* et une **communauté de développeurs** très investie dans le partage de code et
  d'outils qui rendent l'intégration d'outils de développement aisée et
  facilement personnalisable.

Le tout fait de Vim le choix idéal. Dans ce qui suit, je prends le temps de
développer concrètement mon point de vue en m'attardant à des préoccupations
très importantes de tout développeur, mais selon ma perspective, bien entendu.
Je compte donc explorer le mode Normal de Vim, l'intégration avec l'IS plus en
détail, l'intégration de [GDB][gdb] (depuis Vim 8) et les différents greffons
permettant une sensation d'EDI complet.

**N.B**: Cet article ne vise pas à vous apprendre les bases de Vim, mais
vraiment à convaincre sur le fait qu'il constitue un incontournable pour tout
développeur.

[editeur]: https://fr.wikipedia.org/wiki/%C3%89diteur_de_texte
[gdb]: https://fr.wikipedia.org/wiki/GNU_Debugger

## Langage de touches

Vim comporte plusieurs modes:

* Normal;
* Insertion (équivalent à une boîte de texte usuelle);
* Visuel;
* Visuel en bloc;
* Ligne de commande (pas de l'IS, mais bien de Vim);
* ...

Le langage de touche est le celui du mode Normal. C'est là que s'opère la magie
des doigts permettant l'édition aisée du texte. Je ne ferai pas un cours complet
sur ce mode, mais je vous invite à lire plus amplement sur le sujet. Pour ce
faire, référez-vous à la [liste de références au bas de cet article]({{< ref
"#références-additionnelles" >}}).

Ainsi, dans le mode Normal, les touches de l'alphabet n'insèrent pas simplement
les lettres correspondantes, mais exécutent des fonctions élémentaires de Vim.
On peut catégoriser ces fonctions en trois (3) types:

* **un mouvement**: la touche déplace le curseur.
* **une modification**: la touche supprime, déplace, coupe ou colle du texte.
* des fonctions variées...

### Mouvements

Afin de se déplacer dans le fichier, on utilise tout le temps le mode normal
puisque celui-ci comporte des fonctions très efficaces à cette fin. Voici
quelques unes de celles-ci:

* `h`: déplace le curseur à gauche d'une case;
* `j`: déplace le curseur sur la ligne inférieure;
* `k`: déplace le curseur sur la ligne supérieure;
* `l`: déplace le curseur à droite d'une case.

*Oui, c'est bien la raison derrière l'icône du poing `hjkl` comme logo de mon
blog. C'est en quelque sorte la signature de Vim.*

![logo](/images/main/logo.png)

Comme on peut le voir, ces touches remplacent complètement les flèches du
clavier. Il y a une raison très pertinente pour motiver l'utilisation de ces
touches plutôt que les flèches: les mains restent en place là où elles ont
besoin d'être afin d'utiliser toutes les fonctionnalités de Vim. Voici encore
d'autres touches de mouvement utiles:

* `w`: avance le curseur jusqu'au début du prochain *mot*;
* `e`: avance le curseur jusqu'à la fin du prochain mot;
* `b`: recule le curseur jusqu'au début du dernier mot;
* `ge`: recule le curseur jusqu'à la fin du dernier mot.

Tous ces mouvements ont leur équivalent pour des *gros mots* (un mot séparé par
des espaces blancs). Il y a donc les touches `W`, `E`, `B` et `gE` qui exécutent
les fonctions correspondantes.

![vim-f](/images/vim/vim-peut-tout-faire/vim-f-barre-oblique-url.gif)

La touche `f` est une touche capitale. Elle est utilisée conjointement avec `;`
et `,` afin de naviguer sur les différentes occurrences d'une même lettre. On
utilise la touche `f`, qui attend un argument, afin de trouver la prochaine
occurrence d'une lettre. Dans l'exemple ci-haut, `f/` déplace le curseur jusqu'à
la prochaine occurrence de `/` sur la ligne. Et si on souhaitait plutôt aller à
la seconde ou la troisième occurrence? Eh bien, il suffit de taper la touche `;`
et le curseur ira à la prochaine occurence. Cette procédure se répète
indéfiniment. Si on connait le rang du caractère qu'on cherche, disons `4`, alors
on peut simplement faire `4f/`.

**Remarque**: Plusieurs commandes prennent des compteurs en préfixe. Par
exemple, pour avancer de 10 mots, on pourrait faire `10w`.

Bien sûr, il y a plusieurs autres touches de mouvements utiles, mais encore une
fois cet article n'est pas un tutoriel en soi. Pour une liste exhaustive,
référez-vous aux [références plus bas]({{< ref "#références-additionnelles"
>}}). Poursuivons avec les touches de modification du texte.

### Modification du texte

Ci-après, quelques fonctions de modification de texte qui reviennent souvent:

* `d`: fonction de suppression. Attend un argument de mouvement;
* `c`: fonction de changement (suppression et propulsion dans le mode
  *Insertion*). Attend un argument de mouvement;
* `y`: copie du texte. Attend un argument de mouvement;
* `p`: colle du texte.

Ainsi, on compose les fonctions de mouvement avec les fonctions de modification
afin de modifier le texte.

![vim-f](/images/vim/vim-peut-tout-faire/vim-cip.gif)

Par exemple, afin de changer l'intérieur d'une parenthèse dans une ligne de
code comme dans l'exemple ci-haut, on procède en tapant sur les touches `ci)`.
La touche `c` est la commande de changement et `i)` est un mouvement qui
signifie *à l'intérieur de la parenthèse* (*inside parenthesis* en anglais).

### Le point sur le mode normal

Il s'agit là d'une parcelle de tout ce que Vim offre. Une fois mémorisées, ces
commandes permettent de propulser la modification de texte de manière
considérable.

Bien sûr, je ne mène pas un combat idéologique contre la souris. Celle-ci a son
utilité, mais ce n'est bien sûr pas dans la modification de texte.

## Intégration de l'interface système

Par exemple, on peut facilement ordonner les lignes d'un fichier en faisant
simplement

```vim
:%!sort
```

Ici, c'est le programme `sort` de l'IS qui est appelé directement avec en entrée
toutes les lignes du fichier (`%` est un intervalle et signifie tout le fichier)
et `!` signifie un appel à l'IS. Définissons un exemple en appelant `seq`. Pour
ce faire, on écrit `:r!seq 10`:

```
1
2
3
4
5
6
7
8
9
10
```

Ici `:r` est un diminutif de `:read` et permet donc de lire un fichier et
l'écrire après le curseur. Dans ce cas-ci, on lit la sortie standard de la
commande `seq 10` lancé à l'IS. On peut alors mêler les nombres avec `shuf`
en écrivant `:%!shuf`:

```
3
10
7
6
1
8
5
2
4
9
```

Les nombres sont alors placés dans un ordre aléatoire. On peut ordonner le tout
avec `sort -n`. Encore une fois, on écrit `:%!sort -n` pour obtenir la liste de
départ ordonnée.

Un autre programme très connu de l'IS est `grep`. Eh bien, on peut aisément
l'utiliser pour affecter le tampon mémoire courant de la même manière que dans
l'exemple précédent. Disons qu'on ait le tampon mémoire suivant:

```
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
no sea takimata sanctus est Lorem ipsum dolor sit amet.
```

et qu'on ne veuille garder que les lignes contenant le sous-mot `du`, alors on
peut simplement écrire `%!grep '\<\S*du\S*\>'` pour obtenir:

```
tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At
vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,
```

Personnellement, l'exemple que je préfère est celui du presse-papier web (ou
*pastebin*). Plusieurs outils en ligne de commande (IS) existent comme
`pastebinit` ou encore [`dpaste`](https://github.com/sim590/dpaste/), un
programme que j'ai moi-même écrit qui fonctionne sur une table de hachage
distribuée. Ainsi, afin de partager un fichier sur un presse-papier web, on n'a
qu'à écrire:

```vim
:w !dpaste
```

et on obtient alors le PIN (ou l'URL dans le cas de `pastebinit`) à partager à
quelqu'un par notre moyen préféré. Ici, `:w` est un diminutif de `:write` qui
permet d'écrire le tampon mémoire dans un fichier. En l'occurrence, il s'agit de
l'entrée standard de la commande `dpaste`. On voudra nécessairement copier le
PIN (ou l'URL) qui sera retourné par le programme. On peut le faire d'un coup en
utilisant les tubes de l'IS:

```vim
:w !dpaste | xsel -b
```

Ici, `xsel` est un programme lisant son entrée standard et redirigeant celle-ci
vers le presse-papier du système.

Il est important de comprendre que toutes ces notions sont importées directement
depuis l'interface système, c.-à-d. qu'il est suffisant de connaître l'IS afin
de tirer avantage de ces fonctionnalités dans Vim. Puissant, n'est-ce pas?

## GDB

Comme l'IS est l'EDI d'un utilisateur de Vim, il est courant d'utiliser
directement GDB par l'intermédiaire d'une seconde fenêtre comme l'illustre
l'image ci-après.

![debug-gdb](/images/vim/vim-peut-tout-faire/debug-gdb.png)

Bien que cela fonctionne convenablement, depuis Vim 8, il est maintenant
possible d'utiliser GDB directement depuis Vim (voir `:help :Termdebug`). Voici
ce à quoi cela ressemble:

![termdebug](/images/vim/vim-peut-tout-faire/termdebug.png)

En plus de fournir un aperçu en direct du débogage dans le tampon mémoire,
différentes commandes sont intégrées afin de communiquer directement avec GDB.
À ce sujet, si quelqu'un s'intéresse à obtenir une configuration de touches
effective dès, et seulement, lorsque `:Termdebug` est lancé, [voir ma
configuration][conftermdebug].

[conftermdebug]: https://github.com/sim590/dotfiles/blob/master/vim/mappings.vim#L87-L123

## Greffons

GDB c'est bien pour le débogage, mais qu'en est-il de l'assistance à l'écriture
du code. À cet effet, je propose la découverte de différents greffons que je
décris dans le reste de ce billet de blog. En particulier, je survolerai les
greffons suivants:

* [UltiSnips][ultisnips]
* [YouCompletMe][youcompletme]
* [Haskell IDE Engine][hie]

### UltiSnips

URL: https://github.com/SirVer/ultisnips

Ce greffon permet de développer des bouts de code prédéfinis (*snippet* en
anglais) dans le tampon mémoire en fonction du type de fichier qu'on ouvre. Par
exemple, dans un fichier de type `cpp`, on peut transformer le texte suivant:

```cpp
main
```

en le bout de code ci-après:

```cpp
int main(int argc, char *argv[]) {

    return 0;
}
```

**N.B**: Ultisnips ne contient pas de bouts de code par défaut. Il faut donc les
écrire soi-même ou utiliser un greffon de bouts de code comme
[vim-snippets][vim-snippets] initié par honza. Les bouts de code offerts sur ce
dépôt sont nombreux et j'invite fortement à utiliser ce greffon en pair avec
Ultisnips.

[vim-snippets]: https://github.com/honza/vim-snippets

### Analyseur syntaxique et complétion de mots

Un analyseur syntaxique est un composant important d'un EDI moderne. En effet,
la vitesse à laquelle les analyseurs syntaxiques permettent de communiquer
l'information sur l'exactitude de ce qu'écrit le développeur est un facteur
important à considérer. De plus, la complétion des mots est un incontournable
dans différents langages où il est coutume d'écrire de longs mots pour décrire
les variables ou fonctions du programme.

À la base, Vim prend en charge un outil s'apparentant à la complétion de mots.
Il s'agit de `ctags` (voir [ctags-universal][]). Ceci dit, cette solution est
limitée puisqu'elle n'effectue pas une analyse du programme comme tel, mais se
contente de simplement relever les mots sans tenir compte de la syntaxe. Ces
mots sont ensuite stockés dans un fichier qu'on doit par la suite fournir à Vim
par l'option `'tags'`. Par exemple, si on un projet avec une structure comme
celui-ci:

```plain
.
├── Makefile
├── README
└── src
    ├── interface.cpp
    ├── interface.h
    ├── main.cpp
    ├── tools.cpp
    └── tools.h
```

On peut configurer le tout en appelant `ctags`:

```sh
$ ctags -R src/
```

Ceci génère le fichier `tags`. Ainsi, on indique finalement à Vim la présence du
fichier en configurant l'option appropriée: `:set tags=./tags`.

Bien que cette approche soit limitée, elle est souvent complémentaire lorsqu'on
cherche à sauter à la définition d'un mot (la définition d'une fonction par
exemple). Les solutions décrites plus bas permettent normalement déjà cela, mais
dans les cas où un certain langage n'est pas pris en charge par les différents
analyseurs syntaxiques décrits plus bas, l'utilisation de ctags-universal
peut-être appropriée.

[ctags-universal]: https://github.com/universal-ctags/ctags

#### YouCompletMe (C++, Python, Java, Go, Rust, JavaScript, C#, ...)

URL: https://github.com/SirVer/ultisnips

*Aux grands problèmes, les grandes solutions!*

Oui, ce greffon n'est pas léger, mais fait un très bon travail. Il prend en
charge de nombreux langages (tout dépend de l'analyseur syntaxique configuré
selon le langage) et s'exécute en tâche de fond sans importuner le développeur
(depuis Vim 8). Une fois installé et configuré (voir [la
documentation][ycm-doc], [FAQ][ycm-faq] et le [wiki][ycm-wiki]), il suffit
d'ouvrir un fichier source de votre projet afin de se lancer.

Dans le cas de Python, le tout devrait fonctionner directement. Cependant, pour
C++, il est nécessaire de faire une étape supplémentaire afin de faire
fonctionner YouCompleteMe avec les bons drapeaux de compilation. Pour ce faire,
on doit donc ouvrir Vim dans le répertoire du projet (vérifier que `:pwd` donne
bien la racine de votre projet) et lancer `:YcmGenerateConfig`. Cette commande
détectera l'outil de compilation utilisé (Makefile par exemple) et lancera la
compilation afin de récupérer les drapeaux.  Cette étape générera un fichier
nommé `.ycm_extra_config.py`. Le mieux est de placer ce fichier à la racine de
votre projet si celui-ci n'y apparaît pas à cet endroit directement, une fois
généré.

Il est aussi pertinent de considérer l'utilisation d'un fichier
`~/.ycm_extra_config.py`. Comme ce fichier est placé dans votre répertoire
personnel `~`, il servira de configuration de base au cas où aucun fichier de
configuration n'est présent dans votre projet ou si vous modifiez un fichier
seul. Faites attention à n'y inclure que des drapeaux pertinents pour tout
fichier de base sans configuration particulière. On pense notamment à des
drapeaux comme `-std=c++17`.

[ycm-doc]: https://github.com/ycm-core/YouCompleteMe#user-guide
[ycm-faq]: https://github.com/ycm-core/YouCompleteMe#faq
[ycm-wiki]: https://github.com/ycm-core/YouCompleteMe/wiki

#### HIE / LanguageClient (Haskell)

URL: https://github.com/haskell/haskell-ide-engine

Pour les amoureux de Haskell, ce programme est un incontournable. Il rend
l'écriture beaucoup plus aisée comme c'est attendu pour la plupart des langages.

![hie](https://github.com/haskell/haskell-ide-engine/raw/master/logos/HIE_logo_512.png)

L'utilisateur doit se référer à la page principale du projet afin de trouver
**toutes** les instructions d'installation et de configuration.

**Remarque**: Afin d'installer le tout avec `cabal` et non pas avec `stack`
comme suggéré sur leur page, il était suffisant de rouler la commande suivante à
partir de la racine du dépôt:

```sh
$ bash cabal-hie-install hie-8.6.5
```

Une fois que c'est complété, il est obligatoire d'ajouter le greffon pour Vim en
particulier, il s'agit de [LanguageClient][vim-languageclient]. Encore une fois,
il est nécessaire de suivre les instructions de configurations que je ne liste
pas complètement ici.

[ultisnips]: https://github.com/SirVer/ultisnips
[youcompletme]: https://github.com/ycm-core/YouCompleteMe
[hie]: https://github.com/haskell/haskell-ide-engine
[vim-languageclient]: https://github.com/autozimu/LanguageClient-neovim

## Autres greffons

Afin d'avoir plus d'idées de greffons à installer en fonction de vos besoins, je
vous suggère de vous référer à [ma configuration Vim][dotfiles] disponible sur
Github. En particulier, vous pouvez consulter la liste de mes greffons
[ici][greffons-sim590].

[greffons-sim590]: https://github.com/sim590/dotfiles/blob/master/vimrc#L3-L72
[dotfiles]: https://github.com/sim590/dotfiles

## En conclusion

La particularité première de Vim est sa conception des différents modes
d'édition (Normal, Insertion, Visuel, etc.). Ces modes ne s'arrêtent vraiment
pas à la parcelle que j'ai exposée dans cet article. Ils sont vastes. Il y a
beaucoup à découvrir. Ce faisant, il n'est pas si simple de dire qu'on pourrait
aussi bien utiliser un greffon pour Visual Studio afin d'intégrer Vim car dans
la majeure partie des cas, il ne s'agit que d'un sous-ensemble très restreint de
fonctionnalités qui sont incluses dans ce genre de greffon. Ainsi, je préfère
largement utiliser Vim avec ses greffons que l'inverse susmentionné. C'est
pourquoi j'encourage quiconque à prendre le temps de découvrir Vim.

### La courbe d'apprentissage

*Comme on dit si bien ces temps-ci, tout est dans l'aplatissement de la courbe.*
;)

![courbe-vim](/images/vim/vim-peut-tout-faire/courbe-vim.png)

Oui, la courbe est à pic (pas autant que le suggère l'image :P), mais elle
vaut la peine (comme l'indique l'image cette fois-ci :P). En travaillant petit à
petit, on y arrive.

## Références additionnelles

Je renvois le lecteur vers les référence suivantes afin qu'il en apprenne plus
sur Vim:

* `vimtutor`: sur la ligne de commande (après avoir installé Vim sur votre
  système).
* `VIM(1)`: la page de manuel pour Vim (encore une fois après avoir installé Vim).
* [Learn Vim the hard way](https://learnvimscriptthehardway.stevelosh.com/). Un
  livre web sur VimScript. Cela donne beaucoup d'informations pertinentes sur la
  structure de Vim et de VimScript.
* Des viédos tutoriel sur Vim sont disponible sur YouTube à profusion. Il n'y a
  qu'à chercher un peu.
* Si vous êtes plus du genre à jouer, [Vim Adventures][vimadv] est une très
  bonne option pour débuter.

[vimadv]: https://vim-adventures.com/

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

