---
tags:              ['Maybe', 'Monad', "Gestion d'erreurs", 'Générécité']
categories:        ['Haskell', 'Programmation', 'Monade']
title:             "La monade Maybe"
date:              2020-10-16T01:17:31-04:00
description:
draft:             false
hideToc:           false
enableToc:         true
enableTocContent:  false
meta_image:        "images/haskell.png"
---

Dans cet article, je souhaite introduire le programmeur à la monade `Maybe`. Je
compte le faire en utilisant le langage Haskell puisqu'il s'agit du langage
fonctionnel que je maîtrise le mieux et que je le considère très expressif et
accessible. Afin de démontrer les bénéfices de la monade et des concepts
d'Haskell, je vais comparer ceux-ci aux méthodes usuelles du langage C++.

En une phrase, la monade `Maybe` peut être vue comme un _design pattern_ de
gestion des cas d'erreur ou d'exception. Je vais donc utiliser un exemple fictif
et peu réaliste, mais simple, qui permet de capturer l'idée générale. Disons
qu'on a une liste de contacts pour lesquels on souhaite exécuter un traitement.
Cependant, on décide que, dans la région du programme où on implémente le code
associé à cette liste de contact, une opération qui échoue sur un contact
devrait arrêter le fil d'exécution du programme.

Pour débuter, définissons quelques bases:

```cpp
struct Contact {
  std::string nom {};
  std::string numero {};
};

using PaireNomNum = std::pair<std::string, std::string>;

std::vector<std::pair<std::string, std::string>> numeros {
  {"Jean",     "5143482387"}
, {"Michaël",  "5143522489"}
, {"Roger",    "5143732279"}
, {"Charles",  "5143783211"}
};
```

Les définitions ci-haut peuvent être réécrites en Haskell comme suit:

```haskell
type Nom               = String
type NumeroDeTelephone = String

data Contact = Contact { nomContact    :: Nom
                       , numeroContact :: NumeroDeTelephone
                       }
                       deriving Show

numeros :: [(Nom, NumeroDeTelephone)]
numeros = [ ("Jean",     "5143482387")
          , ("Michaël",  "5143522489")
          , ("Roger",    "5143732279")
          , ("Charles",  "5143783211")
          ]
```

On va utiliser ces définitions tout au long de cet article.

## Contexte

Disons qu'on souhaite premièrement retrouver un numéro dans la liste de
contacts. Bien sûr, il faut prendre en compte que le nom passé en paramètre
permettant de retrouver le numéro pourrait ne pas exister dans la liste. Il
s'agit là d'un cas d'erreur. En C++, on pourrait écrire:

```cpp
std::vector<PaireNomNum>::iterator
retrouverNumero(const std::string& nom) {
    return std::find_if(numeros.begin(), numeros.end(), [nom](const auto& nomnum) {
        return nomnum.first == nom;
    });
}
```

Ici, on remarque que le retour de la valeur `std::end(numeros)` se traduit par
la non-présence d'un nom dans la liste de contacts.

En Haskell, on écrirait plutôt:

```haskell
retrouverNumero :: Nom
                -> Maybe NumeroDeTelephone
retrouverNumero nom0 = snd <$> find (\ (nom, _) -> nom == nom0) numeros
```

Ici, `find :: Traversable t => (a -> Bool) -> t a -> Maybe a` retrouve un
élément depuis un type «traversable» (comme une liste) en utilisant le prédicat
`a -> Bool` pour décider si l'élément correspond. Dans notre contexte, `find`
prend la signature concrète suivante:

```haskell
   ((Nom, NumeroDeTelephone) -> Bool)
-> [(Nom, NumeroDeTelephone)]
-> Maybe (Nom, NumeroDeTelephone)
```

Notre fonction `retrouverNumero` parcourt donc la liste des numéros en cherchant
la paire dont le premier élément correspond. Sans `find`, on pourrait réécrire
le code plus haut comme suit:

```haskell
retrouverNumero :: Nom
                -> Maybe NumeroDeTelephone
retrouverNumero nom0 = parcourir numeros
  where
    parcourir [] = Nothing     -- on ne retrouve pas le nom
    parcourir ((nom, num) : resteDesNumeros)
      | nom0 == nom = Just num -- on a retrouvé le nom
      | otherwise   = parcourir resteDesNumeros
```

Ici, quand on ne retrouve pas le nom, on renvoie `Nothing`. Sinon, si on le
retrouve, on renvoie `Just num`, ce qui est simplement le numéro enveloppé par
le constructeur `Just`.

Pour mieux comprendre, regardons la définition du type `Maybe`:

```haskell
data Maybe a = Just a
             | Nothing
```

On voit donc qu'un type `Maybe` est un type de données qui admet deux états: un
premier admissible comportant une donnée abstraite de type `a` et un second
nommé `Nothing` et sans paramètre. Ce second état traduit une valeur non
admissible. C'est analogue au concept de la valeur `nullptr` dans C++, mais en
bien plus puissant et ce en raison du concept même de monade.

## Propagation des erreurs

Il est commun de propager un cas d'erreur depuis le haut d'une pile d'appels de
fonctions jusqu'à l'endroit où on souhaite gérer l'erreur comme tel. Par
exemple, dans notre contexte des contacts, on pourrait vouloir construire une
structure `Contact` après avoir retrouvé le numéro du contact. En C++, on
écrirait donc maintenant:

```haskell
Contact*
retrouverContact(const std::string& nom) {
    auto nomnum = retrouverNumero(nom);
    if (nomnum != std::end(numeros)) {
        return new Contact {nom, nomnum->second};
    } else return nullptr;
}
```

Encore une fois, on doit gérer le cas où le numéro n'est pas retrouvé. Ceci se
traduit par la vérification à savoir si `retrouverNumero` a retourné
`std::end(numeros)` ou non. On gère donc ici explicitement ce cas. En Haskell,
pas du tout!! On peut simplement demander à la monade Maybe de le faire pour
nous:

```haskell
retrouverContact :: Nom
                 -> Maybe Contact
retrouverContact nom = do
  numero <- retrouverNumero nom
  return $ Contact nom numero
```

En effet, ce bout de code est complètement équivalent au bout de code C++,
c'est-à-dire que nous retrouvons un numéro associé au nom et si on ne le
retrouve pas, alors on propagera plus bas dans la pile d'appels de fonction la
valeur signifiant le cas d'erreur. Or, ici le développeur Haskell n'a écrit
aucune instruction de gestion d'erreur. _Le tout est propagé par la monade
Maybe_.

## La monade Maybe

Je rappelle maintenant la définition d'une classe `Monad`:

```haskell
class Applicative m => Monad m where
  (>>=) :: m a -> (a -> m b) -> m b
```

Une monade traduit l'enchaînement d'exécution de fonctions. L'opérateur `>>=`
est nommé _bind_ en anglais, ce qui revient au concept d'enchaînement ou de
tuyautage en séquence de fonctions. Pour la simplicité de l'article, omettons de
remarquer la présence de la restriction `Applicative m`. Si cela intéresse le
lecteur, celui-ci peut lire à ce sujet [ici][applicative].

[applicative]: http://lyah.haskell.fr/foncteurs-foncteurs-applicatifs-et-monoides#foncteurs-applicatifs

On peut voir une monade comme une classe de type permettant de transformer un
état en un second état par l'application d'une fonction. Dans la signature, le
premier état est `m a`. L'opérateur `>>=` se charge d'appliquer la fonction `a
-> m b` sur le contenu du premier état `m a` pour dériver le dernier état `m b`.

Dans notre cas, la monade `Maybe` est définie comme suit:

```haskell
(>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
Nothing >>= _ = Nothing
Just x  >>= f = f x
```

Ceci veut donc dire que si le premier état correspondait à l'état d'erreur
`Nothing`, alors la fonction de transition d'état `a -> Maybe b` ne sera jamais
exécutée et on renverra `Nothing`. Ceci fournit une abstraction de la gestion
d'erreur très utile afin de réduire les occurrences d'écriture d'instructions
redondantes par le développeur.

### Les blocs «do»

Le bloc `do` est du simple sucre syntaxique permettant d'écrire une succession
d'opérations dans une monade sans écrire `>>=`. Au fond, un bloc de la forme
suivante:

```haskell
do
  a <- ma
  fa a
```

correspond exactement à `ma >>= fa`, ce qui mène au type `m b` dans la monade
`m`. Ce faisant, l'exemple de `retrouverContact` aurait pu être réécrit comme:

```haskell
retrouverContact :: Nom
                 -> Maybe Contact
retrouverContact nom = retrouverNumero nom >>= creerContact
  where
    creerContact :: NumeroDeTelephone -> Maybe Contact
    creerContact numero = return $ Contact nom numero
```

Ici, j'ai utilisé un bloc `where` pour nommer la fonction `creerContact` et j'ai
aussi apposé la signature de celle-ci afin de fournir un maximum de détails
utiles à la compréhension.

## Propagation d'erreur au sein d'une même fonction

Lorsqu'on propage une erreur, on peut vouloir empêcher l'exécution du reste
d'une fonction en plus de renvoyer l'erreur plus bas dans la pile d'appels.
Disons qu'on souhaite effectuer deux tâches lors du traitement d'un contact. On
pourrait premièrement vouloir afficher le contact et ensuite changer son numéro
de téléphone.

```cpp
bool afficherContact(const std::string& nom) {
    auto contact = retrouverContact(nom);
    if (contact) {
        std::cout << "Nom: " << contact->nom << std::endl;
        std::cout << "Numero: " << contact->numero << std::endl;
        return true;
    } else
        return false;
}
```

Ici, on recherche le contact et si on le retrouve, on affiche le contact. On
écrit explicitement la gestion des deux cas duaux.

```cpp
bool changerNumero(const std::string& nom, const std::string& numero) {
    auto nomnum = retrouverNumero(nom);
    if (nomnum != numeros.end()) {
        nomnum->second = numero;
        return true;
    } else
        return false;
}
```

Idem pour le cas où on change le nom: les cas d'erreurs sont traités et on
change le nom si possible.

En Haskell:

```haskell
afficherContact :: Nom
                -> MaybeT IO ()
afficherContact nom = do
  contact <- MaybeT $ pure $ retrouverContact nom
  lift $ print contact
```

Ici, on retrouve le contact puis on l'affiche à l'écran. Il est à noter que nous
avons passé maintenant du type `Maybe` à `MaybeT IO`. Le lecteur peut ignorer ce
détail et considérer que la monade `MaybeT IO` se comporte exactement comme
`Maybe`. Pour plus de détail, consultez mon article sur les transformateurs qui
sortira bientôt. Finalement, le lecteur peut voir les instructions `MaybeT`,
`pure` et `lift` que comme de la colle syntaxique qui permet d'obtenir les bons
types. Ceci est nécessaire afin d'exécuter des instructions de la monade `IO`
dans la monade `Maybe`.

**NOTE**: Comme `Contact` est un type pour lequel on a utilisé l'instruction
`deriving Show`, le compilateur nous fournit déjà des fonctions de base pour
afficher le contact.

```haskell
changerNumero :: Nom
              -> NumeroDeTelephone
              -> Maybe (Nom, NumeroDeTelephone)
changerNumero nom nouvnum = do
  void $ retrouverContact nom
  return (nom, nouvnum)
```

Quoi qu'il en soit, le lecteur peut très bien voir qu'aucune instruction en
rapport à la gestion d'erreur n'est faite, mais il doit se rappeler aussi que
c'est la monade `Maybe` (et `MaybeT IO`) qui s'en charge pour le développeur!

Maintenant, si on souhaite traiter ces fonctions pour un contact, on pourrait
écrire la fonction suivante:

```cpp
bool traiterContact(const std::string& nom, const std::string& nouv_numero) {
    bool succes = true;
    if (succes) {
        succes = afficherContact(nom);
    }
    if (succes) {
        succes = changerNumero(nom, nouv_numero);
    }
    return succes;
}
```

Ici, si on veut empêcher l'exécution de la seconde fonction `changerNumero` dans
le cas d'une erreur rencontrée dans `afficherContact`, on doit écrire tout ce
code qui éloigne le lecteur des détails importants lors de sa lecture. On aurait
aimé pouvoir écrire quelque chose comme:

```cpp
afficherContact(nom);
changerNumero(nom, nouv_numero);
```

puisque c'est bien ce qui importe ici. Or ce n'est pas possible si on veut
encoder le comportement désiré. En Haskell, c'est automatique grâce à la monade
`Maybe` (ici `MaybeT`):

```haskell
traiterContact :: Nom
               -> NumeroDeTelephone
               -> MaybeT IO (Nom, NumeroDeTelephone)
traiterContact nom nouvnum = do
  afficherContact nom
  MaybeT . pure $ changerNumero nom nouvnum
```

## Des erreurs en boucle

Et si on souhaitait exécuter notre traitement pour une liste de contacts? Par
exemple, si on souhaitait changer le numéro de téléphone pour la chaîne de
caractères vide, alors on écrirait possiblement:

```cpp
void numeros_a_vide(const std::vector<std::string>& noms) {
    bool succes = true;
    for (const auto& nom : noms) {
        if (succes) {
            succes = traiterContact(nom, "");
            if (not succes) {
                std::cout << "Erreur!! Un contact est introuvable.." << std::endl;
            }
        }
    }
}
```

Le lecteur voit tout de suite comment on est forcé d'écrire du code redondant
sur traduisant la gestion d'erreur. En Haskell ?

```haskell
numerosAVide :: [Nom]
             -> IO [(Nom, NumeroDeTelephone)]
numerosAVide noms = do
  mcontacts <- forM noms $ \ nom -> do
    mc <- runMaybeT $ (`traiterContact` "") nom
    when (isNothing mc) $
      putStrLn "Erreur!! Un contact est introuvable.."
    return mc
  return . catMaybes $ takeWhile isJust mcontacts
```

Et bien, on ne fait qu'exécuter `traiterContact` pour tous les noms dans la
liste `noms`, on récupère le résultat dans `mcontacts`. Décortiquons...

```haskell
forM noms $ \ nom -> do
  mc <- runMaybeT $ (`traiterContact` "") nom
  when (isNothing mc) $
    putStrLn "Erreur!! Un contact est introuvable.."
  return mc
```

Ce bloc effectue un traitement pour chaque nom dans la liste. Il exécute le
traitement pour le contact et récupère le résultat de type `Maybe (Nom,
NumeroDeTelephone)`. Si le résultat est dans l'état `Nothing`, alors on affiche
un message d'erreur. Finalement, on retourne le résultat.

```haskell
takeWhile isJust mcontacts
```

Cette dernière instruction parcourt la liste `mcontacts` de type `[Maybe (Nom,
NumeroDeTelephone)]`. Il s'agit du retour d'exécution pour chaque nom. Par
contre, `takeWhileM (return . isJust)` stoppe l'itération dès qu'une des valeurs
dans la liste est `Nothing` (c.-à-d. que `isJust` retourne FAUX). Ce faisant, on
ne va pas plus loin dans la liste dès qu'on rencontre un résultat `Nothing`.
De plus, comme Haskell est [paresseux][], les itérations de `forM` plus haut ne
seront pas exécutées pour tous les éléments suivant le premier où on a rencontré
`Nothing`.

```haskell
return . catMaybes
```

Finalement, on développe tous les résultats de la forme `[Just a, Just b, ...]`
en la forme `[a, b, ...]`. Il s'agit d'un détail technique nécessaire afin de
retrouver les valeurs en dehors du type `Maybe`.

[paresseux]: https://fr.wikipedia.org/wiki/%C3%89valuation_paresseuse

## Conclusion

Haskell est un langage du paradigme fonctionnel contrairement à C++ dont le
paradigme principal qui n'est pas partagé avec Haskell est le paradigme
impératif. Ces deux méthodes de penser la programmation ont mené à des
évolutions conceptuelles différentes. Le paradigme fonctionnel a plusieurs
bonnes contributions en matière de bonnes pratiques à partager avec les autres.
On voit depuis quelques temps les concepts fonctionnels faire leur chemin jusque
dans les langages n'étant à la base pas fonctionnels. On peut penser à toutes les
fonctions standards comme `map`, `filter`, `fold`, etc. Les monades sont une
abstraction puissante et sont essentielle dans le paradigme fonctionnel afin de
traduire le séquençage d'états de manière réellement utilisable. La monade
`Maybe` est un exemple parmi plusieurs de concepts visant à simplifier
l'écriture du code par la généricité. Heureusement, il y a différents efforts
exercés dans le but de faire cheminer ces concepts vers des langages comme C++
et d'autres. J'encourage donc à découvrir Haskell car c'est en quelque sorte une
manière d'apprendre les fonctions standards de demain qui deviendront dès lors
incontournables.

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

