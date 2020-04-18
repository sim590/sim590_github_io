+++
categories       = ["Techno", "Outil"]
tags             = ["GNU/Linux",  "Productivité", "Vim", "zsh", "ranger", "pass"]
title            = "fzf: comment optimiser son utilisation de la ligne de commande"
date             = "2020-04-11T00:42:27-04:00"
meta_image       = "images/fzf/fzf-logo.png"
+++

`fzf` est un programme filtrant le flux de son entrée standard par mots clefs
fournis par l'utilisateur de manière interactive. Le filtre est du type *fuzzy*
(d'où le nom *fzf* pour *fuzzy finder*), c'est-à-dire que les termes fournis au
programme sont décomposés en sous-mots afin de permettre des recherches
approximatives par l'utilisateur. Par exemple, prenons l'entrée suivante:

```plain
toto
titi
tutu
```

Si l'utilisateur fournissait le terme `tt`, toutes les lignes seraient
sélectionnées, puisque les sous-mots `t` et `t` se trouvent tous deux dans
toutes les lignes. Cependant, avec le terme de recherche `oo`, seul la première
ligne correspondrait avec le mot `toto` selon le même raisonnement.

## Les principales fonctionnalités

### Utilisation de base

Comme mentionné précédemment, `fzf` agit sur son entrée standard. Ainsi, on
l'utilise comme suit:

```sh
find . | fzf
```

Ceci donne donc toute la liste des fichiers dans le répertoire courant (et tous
ceux qui se trouvent sous celui-ci) et `fzf` démarre en permttant à
l'utilisateur de spécifier des mots-clefs:

![fzf1](/images/fzf/fzf-1.png)

Dans l'exemple de la figure ci-haut, si on ajoute le terme `Documents`, `fzf`
filtrera les lignes afin de n'afficher que celles qui contiennent ce mot. Les
résultats les plus hauts dans la liste (selon la sortie de `find`) sont
préservés au haut de la liste après le filtre:

![fzf2](/images/fzf/fzf-2.png)

On succède les termes en les séparant (ou non) par des espaces:

![fzf3](/images/fzf/fzf-3.png)

Ceci permet donc de filtrer une liste de fichiers afin de tomber très rapidement
sur les résultats qu'on souhaite. En ajoutant des espaces, on peut spécifier des
options à l'aide de caractères spéciaux (`!`, `$` et `'` par exemple). Le
caractère `$` indique que le mot qui le précède (délimité par des espaces) se
trouve à la fin de la ligne (ceci peut sonner familier aux connaisseurs des
expressions régulières). L'utilisation de l'apostrophe `'` au début du mot,
permet de ne sélectionner que les lignes contenant le mot tel quel (donc pas de
décomposition en sous-mots pour ce mot en particulier).

Afin de sélectionner un choix, l'utilisateur utilise `ctrl-j` pour descendre et
`ctrl-k` pour monter. Une fois la ligne sélectionnée avec le curseur, il suffit
d'appuyer sur la touche ENTRÉE afin de confirmer le choix.

Lorsque le choix est fait, `fzf` affiche la ligne sélectionnée à la sortie
standard.

#### Exemple

Un exemple typique d'utilisation est celui d'ouvrir un fichier avec son éditeur
de texte préféré:

```sh
vim $(fzf)
```

![vim-fzf](/images/fzf/fzf-vim-memoire.gif)

### Filtre par défaut

Comme l'utilisation première de `fzf` est de lister les fichiers, il est
possible de simplement appeler `fzf` tout court sans l'aide de `find` pour
obtenir le même résultat.

```sh
fzf
```

En particulier, le comportement par défaut peut être réglé par la variable
d'environnement `FZF_DEFAULT_COMMAND`. Personnellement, j'utilise la
configuration:

```sh
export FZF_DEFAULT_COMMAND="find ."
```

Peu importe l'outil d'interface système (IS) que vous utilisez, il suffit
d'utiliser l'instruction adéquate permettant la configuration de la variable
d'environnement. Personnellement, comme mon gestionnaire de bureau est `gdm`,
je configure cette instruction dans `~/.profile`. À vrai dire, j'utilise un
fichier séparé (nommé `~/.fzf_env`) qui est chargé par le fichier `~/.profile`
à l'aide de l'instruction `source`:

```sh
source ~/.fzf_env          # Contient le contenu listé précédemment.

export FZF_DEFAULT_COMMAND # Nécessaire afin de bien exposer la variable après
                           # l'avoir configuré dans ~/.fzf_env
```

### Choix multiples

Il arrive qu'on utilise des programmes permettant de lister plusieurs fichiers
sur une même ligne de commande. Heureusement, `fzf` admet l'option `--multi` et
permet donc de sélectionner plusieurs choix. Entre autres, pour sélectionner
plusieurs fichiers à ouvrir dans Vim, on peut écrire:

```sh
vim $(fzf -m)
```

![fzf-vim-multi](/images/fzf/fzf-vim-multi.gif)

L'utilisateur peut alors sélectionner les choix multiples à l'aide de la touche
`TAB`.

## Fonctionnalités du de l'interface système

Deux fonctionnalités principales sont fournies: des touches raccourcis ainsi que
des scripts de complétion.

### Complétion

**N.B**: l'utilisateur doit lui-même installer les scripts de complétion. Il
suffit simplement d'include une instruction `source` du scripts de complétion
dans sa configuration personnelle.

La complétion de la ligne de commande s'effectue pour toute commande à l'aide de
la chaîne de caractères dédiée `**`. Lorsque cette chaîne est reconnue par les
scripts de complétion (voir les procédures d'installation), les chemins sont
complétés à la ligne de commande et les choix ajoutés à celle-ci. Par exmeple,
si on souhaite se déplacer avec `cd` dans un répertoire très profond, on écrit:

```sh
cd **
```

suivi de la touche `TAB` et `fzf` se lance et permet de choisir le répertoire.
Une fois sélectionné, la ligne de commande de l'utilisateur sera changée par
`cd` suivi de son choix. Par exemple:

```sh
cd un/très/long/chemin/vers/le/répertoire/que/je/cherchais
```

Ce mode d'exécution permet donc de facilement modifier la ligne de commande
avant d'exécuter celle-ci au besoin. Dans le cas de `cd`, seuls les répertoires
seront listés par `fzf`. Sinon, avec Vim par exemple, en écrivant `vim **` et en
appuyant ensuite sur `TAB`, `fzf` affichera les fichiers et les répertoires.

Deux cas particuliers et intéressants sont aussi fournis. Il s'agit de ceux de
`ssh` et `kill`. Pour `ssh`, en écrivant `ssh **`, la liste des noms d'hôtes
connus (configurés dans `/etc/hosts`) sera fournis en complétion.

![fzf-ssh](/images/fzf/fzf-ssh-local.png)

Comme il est normalement possible de se connecter à un hôte en fournissant son
adresse BONJOUR (au format `nom-d-hôte.local`), il serait pertinent de fournir
la liste des noms d'hôtes sur le réseau local. Cependant, `fzf` ne le fait pas.
Ceci dit, il est trivial de surcharger la fonction de complétion relative à
`ssh`. Voir la [section à ce sujet]({{<ref "#ssh-et-les-adresses-local" >}}).

Maintenant, le cas de `kill`. Cette fonction est une des plus attrayantes.  Il
suffit d'écrire `kill` suivi d'un espace et appuyer sur `TAB` (sans `**` cette
fois-ci). La liste des processus est affichée avec les lignes de commande
exactes utilisées pour lancer chacun de ceux-ci. On peut donc rechercher parmi
chacun d'eux et même en sélectionner plusieurs. Le résultat sera que chacun des
identifiants de processus seront ajoutés à la ligne de commande afin que
l'utilisateur puisse tuer tous les processus d'un trait.

![fzf-kill](/images/fzf/fzf-kill.png)

Par exemple, suivant la capture ci-haut où les mots clefs `urxvt` et `vim` ont
été fourni, on peut sélectionner certains processus à tuer. Le résultat sera la
ligne de commande suivante:

```sh
kill 17292 17279 27346
```

### Touches raccourcis pour l'IS

#### ALT+C

En plus d'accélérer grandement le déplacement de l'utilisateur dans le système
par la ligne de commande, `fzf` va un cran plus loin en fournissant la touche
`ALT+C` (pour Bash et Zsh). Encore mieux: `fzf` fourni la possibilité de
configurer une fenêtre d'affichage qui donne un aperçu du répertoire devant le
curseur en temps réel:

![fzf-alt-c](/images/fzf/fzf_alt-c.png)

La simple sélection du répertoire enclanche toute suite le changement de
répertoire une fois la touche ENTRÉE appuyée. Afin d'obtenir cette belle fenêtre
d'affichage, l'utilisateur doit spécifier la commande à utiliser:

```zsh
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
```

#### CTRL+R

Comme la version de moi des jours précédants ma découverte de `fzf`, vous
utilisez possiblement `CTRL+R` pour rechercher les commandes précédemment
entrées afin d'éviter de les réécrire. Cela ressemble normalement à quelque
chose comme ceci:

![ctrlr](/images/fzf/ctrl-r.gif)

Malheureusement, pas beaucoup d'information est affiché et il n'est pas possible
de renchérir sur la recherche de manière très aisée et efficace. Fzf fournit un
remplacement pour cela et change complètement l'expérience.

![fzf-ctrlr](/images/fzf/fzf-ctrl-r.gif)

#### Finalement...

Pour plus de détails, voir la documentation de `fzf` à l'adresse suivante:

https://github.com/junegunn/fzf

La page Wiki est aussi une bonne ressource:

https://github.com/junegunn/fzf/wiki

## Extension de la complétion

### Exemple trivial

Afin de fournir la complétion pour le programme `toto`, il suffit d'écrire une
instruction comme celle-ci:

```zsh
_fzf_complete_toto() {
  _fzf_complete '' -- "$@" < <(
    echo tutu
    echo titi
    echo tata
    # On peut mettre toutes les instructions zsh qu'on veut ici afin de
    # bâtir la liste passée à fzf.
  )
)
```

**N.B**: Il est spécifié sur la page de documentation de Fzf que l'IPA est
instable et change de version en version. En particulier, cela concerne la
fonction `_fzf_complete`. Par exemple, la version du paquet Debian que j'utilise
est telle que la fonction `_fzf_complete` ne reconnaît pas l'argument
dédié `--`. Il faut donc simplement le retirer.

### ssh et les adresses "*.local"

Comme mentionné plus tôt, la complétion par les scripts de `fzf` pour `ssh` ne
fournissent pas les noms d'hôtes dans le réseau local, ce qui pourrait s'avérer
souvent utile. Afin de remédier à cela, il suffit d'inclure le bout de code
suivant dans sa configuration:

```zsh
# Dans le fichier: ~/.zshrc
_fzf_complete_ssh() {
  _fzf_complete +m -- "$@" < <(
    setopt localoptions nonomatch
    command cat <(cat ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?]') \
        <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
        <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
        awk '{if (length($2) > 0) {print $2}}' | sort -u
    command avahi-browse -atlr | grep -o '\<\S\+\.local' | sort -u
  )
}
```

Il s'agit du code exacte repris du script de complétion fourni par `fzf` avec la
dernière ligne ajoutée permettant de lister les noms d'hôte.

```zsh
command avahi-browse -atlr | grep -o '\<\S\+\.local' | sort -u
```

Ainsi, les noms d'hôtes présents dans le réseau local s'afficheront.

## Aptitude

Le gestionnaire de paquets de Debian est l'exemple parfait où `fzf` devient très
utile. Il est courrant de chercher un paquet sans connaître les mots clefs
exacts à utiliser. Une vue d'ensemble interractive de recherche facilite
énormément ce processus.

![apt-zsh](/images/fzf/apt-zsh.png)

Il suffit d'écrire `apt commande **` où `commande` est une commande valide
d'`apt` qui demande des noms de paquets en argument. Par la suite, on tape sur
la touche `TAB` et la magie se lance. La recherche s'effectuera sur la liste de
paquets jointe à leur description correspondante. Pour l'instant, la
configuration prend en charge les commandes `install`, `show`, `search`,
`remove`, `reinstall` et `purge`. Rien ne vous empêche de vous inspirer du code
pour ajouter des commandes. De plus, comme la configuration est en mode
multi-choix, (`fzf` se fait passer le drapeau `-m`), on peut choisir plusieurs
noms de paquets avec `TAB` et les touches pour monter et descendre le curseur
(`ctrl-k`, `ctrl-j`).

Le code que j'ai écrit pour rendre cela possible est
inspiré du bout de code trouvé [ici][fzf-apt].

```zsh
list_aptitude_packages() {
    if   [[ $@ =~ 'apt install'* ]] \
      || [[ $@ =~ 'apt show'*    ]] \
      || [[ $@ =~ 'apt search'*  ]]; then
    command apt list --verbose
    elif [[ $@ =~ 'apt remove'*    ]] \
      || [[ $@ =~ 'apt reinstall'* ]] \
      || [[ $@ =~ 'apt purge'*     ]] ; then
    command apt list --verbose --installed
  fi
}

_fzf_complete_apt() {
  IFS=' ' read -A ARGS <<< $@
  prg="${ARGS[1]}"
  setopt extendedglob
  if [[ "$prg" =~ "apt" ]]; then
    if   [[ $@ =~ 'apt install'*   ]] \
      || [[ $@ =~ 'apt show'*    ]] \
      || [[ $@ =~ 'apt search'*  ]] \
      || [[ $@ =~ 'apt remove'*    ]] \
      || [[ $@ =~ 'apt reinstall'* ]] \
      || [[ $@ =~ 'apt purge'*     ]] ; then
      _fzf_complete '--multi' "$@" < <(
        list_aptitude_packages $ARGS 2>/dev/null | \
        command tail --lines +2 | \
        command sed '/^ *$/d' | \
        command sed 'N;s/\n */^/;p' | \
        command column -t -s '^'
      )
    fi
  fi
}
_fzf_complete_apt_post() {
  cut --delimiter '/' --fields 1 | \
  xargs --max-args 1 --no-run-if-empty printf "%q "
}

```

**Remarque**: Cette configuration ne fonctionne que pour `apt` et pas pour
`apt-cache`, `apt-get`, etc. Ce n'est pas bien grave puisque la commande `apt`
vise à réduire le nombre de commandes différentes à utiliser de toute manière en
centralisant tout sous une seule. Ceci dit, le code serait plus intéressant s'il
prenait en charge les autres programmes. Je ferai possiblement une mise à jour
pour prendre en charge ces cas.

[fzf-apt]: https://github.com/krickelkrakel/fzf-apt

## pass (passwordstore)

https://passwordstore.org

Cet outil qui permet la gestion des mots de passe pour l'utilisateur de l'IS
possède déjà des fonctions de recherche (`pass grep` et `pass find`), mais
celles-ci n'arrivent pas à la hauteur de `fzf`. [La liste de courriel de
pass][courriels-pass] comporte un échange dans lequel on retrouve un échantillon
de configuration permettant de compléter les requêtes à `pass` avec `zsh` (la
même fonction peut être utilisée pour Bash, [voir la
documentation][fzf-custom-completion]).

```zsh
_fzf_complete_pass() {
  ARGS="$@"
  _fzf_complete '' "$@" < <(
    command find ~/.password-store/ -name "*.gpg" | sed -r 's,(.*)\.password-store/(.*)\.gpg,\2,'
  )
}
```

**N.B**: une erreur s'était glissée dans [la version originale][courriels-pass].
J'ai pris soin de la corriger dans l'échantillon de configuration ci-haut.

On peut ainsi accéder à ses mots de passe bien plus facilement!

![fzf-pass](/images/fzf/pass-zsh.png)

Comme pour les exemples précédents, on entre la touche `TAB` après les deux
étoiles et le menu ci-haut apparaît. On sélectionne et la ligne de commande est
complétée. Par exemple, en sélectionnant le premier élément, on obtiendrait la
ligne de commande résultante:

```sh
pass personnel/access-point/tp-link
```

Ceci est très utile lorsqu'on ne se souvient plus exactement du nom du fichier
contenant le mot de passe qu'on recherche.

[courriels-pass]: https://lists.zx2c4.com/pipermail/password-store/2015-September/001750.html
[fzf-custom-completion]: https://github.com/junegunn/fzf#custom-fuzzy-completion

## Ranger

![ranger](/images/fzf/ranger.png)

[Ranger][ranger] est un gestionnaire de fichiers en mode texte très versatile.
Par sa simplicité de conception, il permet à ses développeurs de se concentrer à
rendre possible de multiples fonctions en tirant avantage entre autres de l'IS.

Bien qu'il permette le déplacement entre les répertoires de manière assez rapide,
`fzf` peut l'aider à faire mieux! Il existe un [greffon][greffon-ranger]
permettant de sélectionner un répertoire (ou un fichier) pour y déplacer le
curseur. Il suffit de placer le fichier python du greffon sous
`~/.config/ranger/plugins/fzf.py` et on peut directement appeler la fonction en
appelant la commande `:fzf`. Il peut être commode de configurer une touche dans
`~/.config/ranger/rc.conf` pour un maximum de vitesse d'exécution.

[ranger]: https://github.com/ranger/ranger
[greffon-ranger]: https://github.com/cjbassi/ranger-fzf

## Greffon pour Vim

Bien sûr, il existe un greffon super puissant pour Vim. Je n'en donnerai pas de
détail ici. Ce sera pour un autre article possiblement. Je donne tout de même le
lien vers le greffon:

https://github.com/junegunn/fzf.vim

## Complétion avec sudo

Malheureusement, ce n'est pas possible pour le moment de faire fonctionner la
complétion avec `sudo` sur la ligne de commande. C'est un peu fâcheux puisque le
comportement usuel des fonctions de complétion pour ZSH prend normalement ce
détail en charge.

Voir https://github.com/junegunn/fzf/issues/1981 pour rester au fait de ce
problème.

## En conclusion

Il est pertinent de noter comment que `fzf` remplit parfaitement les critères
d'un programme de style UNIX. En effet, il répond adéquatement aux attentes
comme quoi *il fait une et une seule chose, mais le fait bien*. Il est impératif
de remarquer que cette qualité additionnée avec l'IS de conception UNIX permet
l'augmentation de tous les autres programmes communiquant par cette même
interface système. Fzf exprime très bien l'harmonie que rend possible entre les
différents programme un système comme GNU/Linux. En somme, ce programme augmente
considérablement la rapidité d'exécution des tâches à la ligne de commande par
l'utilisateur. C'est pourquoi je recommande à tous les curieux de prendre le
temps de jouer avec et de l'adopter.

Je remercie Jaël Gareau pour m'avoir fait part de cette découverte.

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

