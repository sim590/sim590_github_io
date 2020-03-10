+++
categories = ['Cybersécurité', 'Cryptographie', 'Vie privée']
tags       = ['Chiffrement', 'Chiffrement de bout en bout', 'Confidentialité', 'Signal', 'WhatsApp', 'Protocole', 'Protocole de communication', 'Communication']
title      = "Comment bien assurer la vie privée du clavardage?"
date       = 2020-03-09
meta_image = "images/chiffrement-de-bout-en-bout.png"
+++

Lorsqu'on utilise les différents outils de communications habituels de nos
jours, il est commun de supposer la garantie de sa vie privée. L'utilisateur
moyen ne se pose aucune question lorsqu'il se connecte à des services comme
Facebook, Twitter ou Skype. Ou encore, on se rassure tout de suite à l'idée de
voir des symboles de "sécurité" comme le suivant.

![https](/images/chrome-sécu.png)

Tous les services susmentionnés sont effectivement munis de protections, mais
contre et pour qui? Et sous quelle(s) hypothèse(s)? Il s'avère que les mesures
de sécurité des logiciels communiquant sur les réseaux ne protègent réellement
que les entreprises derrière les services associés. La vie privée des individus
n'est, en majeure partie des cas, pas préservée d'aucune manière.

Afin de bien comprendre pourquoi, prenons un moment pour définir quelques termes
et concepts centraux.

## Définitions

Selon le standard [ISO 27000 (2018)][iso27000], on décrit les termes suivant:

* **Confidentialité**: « propriété selon laquelle l'information n'est pas rendue
  disponible ni divulguée à des personnes, des entités ou des processus non autorisés »;
* **Intégrité**: « propriété d'exactitude et de complétude »;
* **Authentification**: « moyen pour une entité d'assurer la légitimité d'une
  caractéristique revendiquée .»

La confidentialité est assurée par ce qu'on appelle le **chiffrement**. Ceci
correspond plus précisément à une action rendant inintelligible une information
par l'exécution d'un procédé irréversible, nommé **chiffre** ou **méthode de
chiffrement**, pour quiconque n'ayant pas l'information nécessaire.
L'information en question est appelée **clef** et permet de **déchiffrer** une
donnée chiffrée, c'est-à-dire de rendre cette information intelligible à
nouveau.

On assure ensuite l'authenticité d'un émetteur ou récepteur par des **signatures
numériques**. Celles-ci peuvent prendre plusieurs formes, comme des [codes
d'authentification de message (CAM)][cam] ou des [signature de clef
privée][chiffreclefpub].

[iso27000]: https://www.iso.org/obp/ui/#iso:std:iso-iec:27000:ed-5:v1:fr
[cam]: https://fr.wikipedia.org/wiki/Code_d%27authentification_de_message
[chiffreclefpub]: https://fr.wikipedia.org/wiki/Cryptographie_asym%C3%A9trique

## Sécurité par un tiers

Le modèle qu'on retrouve le plus souvent est celui d'une communication où les
procédures de sécurisation des communication s'effectuent dans un premier temps
entre un client et un serveur. Cette approche est représentée dans l'image
ci-après.

![communication sécurisée par un tiers](/images/communication_sécurisée_par_un_tiers.png)

On dépeint ici la communication entre le client `A` et le client `B` par
l'intermédiaire du serveur. On remarque, dans un premier temps, que le
chiffrement est dès lors opérationnel entre le client `A` et le serveur. Ceci est
représenté par la possession d'une clef `K_A` par `A` et le serveur ainsi que la
flèche verte. Les deux partis de cette communication peuvent donc échanger de
manière sûre par ce canal. Idem pour `B` et le serveur avec la clef `K_B`.

Ce modèle est celui de multiples services de communication comme: Facebook,
Twitter, Skype, Instagram, service de courriel (Outlook, GMail, etc.), ...

### Faille flagrante de ce modèle

Il faut rappeler que le diagramme veut représenter un échange entre `A` et `B`.
Or, lorsque `A` envoie un message à `B`, celui-ci passe par le serveur et est
protégé, c'est-à-dire qu'il est chiffré, jusqu'à ce qu'il atteigne le serveur.
Une fois rendu, le message est déchiffré. Du point de vue de `A` et de `B`, il
n'y a *aucun* moyen de savoir ce qui se passe sur le serveur avec les messages
qui sont transmis au serveur entre le moment où le serveur les reçoit et le
moment où il les relaye à son destinataire. En effet, le serveur peut très bien
stocker ces messages, les analyser, les propager avec un autre parti, les
vendre, etc.

Ce faisant, la sécurité de ce modèle fait une supposition très grave: vous devez
être en parfaite confiance avec le fournisseur du service pour que celui-ci ne
touche pas à vos données. Dans un monde où les données récoltées de manière
massive représentent un capital considérable, il est clair que cette hypothèse
devient de plus en plus difficile à faire tenir.

### Pourquoi est-ce important?

Nombreuses situations suggèrent le caractère sensible de
communications comme c'est le cas pour certains individus dont la profession demande de garantir
la vie privée de soi ou d'autrui. On peut penser à des journalistes qui
doivent assurer la confidentialité de leur communication, un psychologue qui ne
doit pas divulguer d'information sur son patient, [une personne nécessitant une
protection contre les démarches abusives d'un état][puigdemont] ou un simple
civil dont les droits peuvent être abusés au bon moment suite à l'accumulation
de données sur sa personne.

Il est facile de s'imaginer le danger que cela peut représenter pour une
population victime du totalitarisme de leur État. Cependant, il n'est pas
obligatoire d'être citoyen d'un tel État pour s'inquiéter. La menace que
constitue l'accumulation de données sur des individus est bien réel et ce n'est
pas un hasard si [la vie privée est reconnue formellement comme un droit depuis
1947 par la commission des droits de la personne][droitpersonne].

Il est trop facile de se laisser prendre et de considérer que cette faille n'est
pas assez majeure. Je ne peux pas insister assez sur le fait qu'il n’ya
**aucun** moyen de connaître le véritable traitement réservé à nos données dans
un tel modèle et que **la seule manière** d'éviter ce problème est d'opter pour
une formule différente qui respecte vraiment la vie privée de ses usagers, peu
importe ce qu'en disent les "politiques" d'utilisation des données affichées par
les fournisseurs de service.

*Leur parole n'est rien comparativement à l'assurance que promet le chiffrement
de bout en bout*.

[puigdemont]: https://www.amnesty.org/fr/latest/news/2019/11/spain-conviction-for-sedition-of-jordi-sanchez-and-jordi-cuixart-threatens-rights-to-freedom-of-expression-and-peaceful-assembly/
[droitpersonne]: https://dx.doi.org/10.1093/hrlr/ngu014

## Chiffrement de bout en bout

Quand on dit «sécurité», on entend l’aptitude d'un système à préserver diverses
propriétés dont nécessairement [la confidentialité, l'intégrité et
l'authentification]({{< ref "#d%C3%A9finitions" >}}). Lorsque le système est
capable de garantir les propriétés désirées, on dit qu'il est *sûr*. La *sûreté
de bout en bout* est l'exigence que les propriétés de sécurité du système soient
préservées pour tous ses participants *sans* l'existence d'un tiers parti
faisant exception et pouvant briser une (ou l'ensemble) des propriétés.
Autrement dit, un système sûr de bout en bout est un système atteignant toutes
les propriétés ci-haut alors que toute entité différente des interlocuteurs
d'une conversation est envisagée comme des ennemis dans le modèle d'adversaire.

![communication sécurisée par un tiers](/images/communication_sécurisée_beb.png)

La figure ci-haut illustre ce phénomène. De façon similaire à la figure
précédente, la communication est sécurisée entre `A` et `B`, mais le serveur n'a
aucune connaissance des clefs de chiffrement sur le canal de communication.
Ainsi, il peut relayer les données, alors que `A` et `B` sont tous deux certains
que le serveur (comme tout autre tiers) n'a aucune façon d'apprendre le contenu
des communications entre eux.

Cette formule se prête à un grand nombre d'applications, mais nous nous
limitons au cas du clavardage afin de fournir des exemples concrets. L'exemple
par excellence mettant en œuvre ce modèle est Signal.

## Signal

«L'axolotl, Ambystoma mexicanum, est une espèce de salamandre néoténique faisant
partie de l'ordre des urodèles et de la famille des Ambystomatidae [...] Une
particularité de cet animal est sa capacité à régénérer des organes endommagés
ou détruits.» (Wikipedia)

![axolotl](/images/axolotl.jpg)

Ce n'est pas un hasard si [Signal][signal] (son protocole du moins) a eu comme
premier nom «Axolotl». Moxie Marlinspike, le créateur de Signal, avait très bien
résumé la capacité de son modèle à garantir une *autorégénération* de la
confidentialité de ses utilisateurs au fil du temps d'une discussion. La
particularité première de Signal est qu'il permet de rétablir la
confidentialité d'une conversation entre deux personnes suivant la fuite
d'information éventuelle. Ce faisant, comme l'axolotl, Signal se *guérit* à
mesure qu'il subit des fuites et il le fait avec efficacité dans un contexte
asynchrone. C'est la raison principale qui fait du protocole de communication de
Signal l'exemple de ce qui se fait de mieux en matière de communication sûre de
bout en bout.

![signal](/images/signal-ap.jpg)

Pour une description détaillée du protocole, référez-vous à [mon
mémoire][mémoire] (pages 78-82).

De mon point de vue, Signal est la meilleure recommandation que je puis faire
pour quiconque souhaitant un haut niveau de vie privée. Une caractéristique
importante en ce qui a trait à la sécurité est qu'il s'agit d'un [logiciel
libre][llibre] (voir [la mise en garde]({{< ref "#mise-en-garde" >}}) contre les
[logiciels propriétaires][lprop] à la fin de cet article).

[mémoire]: /doc/[SimonD]mémoire-20190928-63a6fff.pdf
[signal]: https://www.signal.org/fr/
[llibre]: https://fr.wikipedia.org/wiki/Logiciel_libre

### Points faibles

Malgré son excellence, Signal souffre tout de même de points faibles non
négligeables.

**Couplage avec le téléphone**

En effet, Signal ne peut fonctionner sans un téléphone intelligent. Bien que
[l'application de bureau Signal existe][signal-desktop], il est obligatoire de la
lier à une instance installée sur son téléphone mobile. Cela rend donc difficile
l'utilisation de Signal par certains ne possédant pas téléphone. De plus, comme
les appareils mobiles utilisant Android ou iOS ne sont pas formellement sûrs par
leur nature propriétaire et puisqu'ils ne sont pas conçus en soi pour préserver
la vie privée des usagers, il est nécessaire de garantir la sécurité de son
appareil mobile afin de jouir des pleines capacités de Signal.

**Communication de groupe moins sûre que la communication en pair à pair**

En effet, le protocole de communication n'est pas le même lorsque plus d'un pair
souhaite échanger dans une même conversation sur Signal. Ce faisant, il faut
prendre ça en considération si notre priorité est de minimiser les fuites.

[signal-desktop]: https://support.signal.org/hc/en-us/articles/360008216551-Installing-Signal#install_desktop

## Autres possibilités

D'autres applications permettent de tirer un haut niveau de sécurité. Certaines
ont une étendue d’usages plus variée ou un objectif principal différent,
mais servent tout de même la fonction de clavardage.

* [**Matrix**][matrix]. Il s'agit d'un réseau décentralisé plutôt qu'une
  application. Il y a différents moyens de s'y connecter
  comme par [Riot][riot]. La liste complète des applications compatibles peut se
  trouver à l'adresse suivante:

  https://matrix.org/docs/projects/try-matrix-now

  La documentation pour le protocole pair à pair peut se trouver
  [ici](https://gitlab.matrix.org/matrix-org/olm/-/blob/master/docs/olm.md) et
  pour le protocole de groupe,
  [ici](https://gitlab.matrix.org/matrix-org/olm/blob/master/docs/megolm.md). Il
  s'agit d'une implémentation des idées de Signal, alors le niveau de sécurité
  est très semblable s'il n'est pas identique.
* WhatsApp et les conversations secrètes de Facebook sont des possibilités. Le
  lecteur est cependant averti de bien lire la mise en garde ci-après à ce
  sujet. En particulier, l'option de Facebook n'est pas optimale dans sa
  présentation visuelle, ce qui le rend encore moins intéressant.

[riot]: https://riot.im/
[matrix]: http://matrix.org/

## Mise en garde

Lorsqu'il vient le temps de parler sécurité et de confidentialité,
l'utilisation de [logiciel propriétaire][lprop] engendre un énorme déclin de
confiance sur l'effectivité de la garantie de confidentialité. En effet, on ne
peut assurer que le logiciel n'est pas truffé de code-espion. Bien que le
garantir pour une application libre n'est toujours pas chose triviale, c'est
toutefois possible. En résumé, il vaut bien mieux opter pour une solution libre
si la confidentialité est le souci principal.

[lprop]: https://fr.wikipedia.org/wiki/Logiciel_propri%C3%A9taire

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

