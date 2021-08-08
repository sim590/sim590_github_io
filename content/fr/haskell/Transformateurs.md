---
tags:              ['Transformateur', 'Monade', 'Composition']
categories:        ['Haskell', 'Programmation']
title:             "Transformateurs: composition de monades"
date:              2021-07-23T04:03:00-04:00
description:
draft:             false
hideToc:           false
enableToc:         true
enableTocContent:  false
meta_image:        "images/haskell.png"
---

<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

Dès lors qu'on découvre les monades et leur utilité, on ne peut faire autrement
que de les étudier davantage et trouver les occasions pour les utiliser. Après
tout, ils sont des concepts clefs dans l'utilisation sérieuse d'un langage
fonctionnel comme Haskell. Par exemple, on ne peut pas faire d'opérations
d'entrée/sortie si on ne fonctionne pas dans la monade `IO`.

Une limitation importante prend forme très rapidement sous nos yeux: il devient
difficile d'utiliser plusieurs monades ensembles car on doit forcément les
développer pour passer d'une monade à l'autre. Ce faisant, on doit choisir entre
les propriétés d'une monade ou l'autre et on ne peut donc pas bénéficier des
différents monades en même temps. Les transformateurs de monades visent
justement à régler ce problème de manière à fournir une écriture finale
satisfaisante autant au niveau sémantique que pour l'organisation logique du
code.

## Cas typique de Maybe

Par exemple, admettons la fonction suivante récupérant un mot de passe:

```haskell
getPassWord :: IO String
getPassWord = do
  putStr "Entrez votre mot de passe: "
  getLine
```

Ici, on récupère un mot de passe simplement en lisant la ligne à l'entrée
standard. Qu'arrive-t-il si la fonction devait pouvoir retourner un résultat
d'erreur lorsque le mot de passe ne répond pas à un certain critère? Par
exemple, on pourrait demander que le mot de passe soit entre 6 et 8 caractères.
Dans un premier temps, on pourrait imaginer pouvoir écrire la chose suivante:

```haskell
getPassword :: IO (Maybe String)
getPassword = do
  putStr "Entrez votre mot de passe: "
  pwd_candidate <- getLine
  let n = length pwd_candidate
  if n >= 6 && n <= 8 then return (Just pwd_candidate)
                      else return Nothing
```

Dès lors, on se rend contre d'une chose: il est impossible d'utiliser ici des
fonctions telles que `guard :: Alternative f => Bool -> f ()` de façon à
court-circuiter l'exécution du code autrement qu'en exécutant directement
l'instruction dans la monade `Maybe`. Ceci est d'autant plus apparent si on
s'impose plusieurs conditions d'échec. Disons maintenant que le mot de passe
devrait aussi ne contenir que des lettres `[a-zA-Z]`, alors on aurait donc:

```haskell
letters :: [Char]
letters = ['a'..'z'] ++ ['A'..'Z']

getPassword :: IO (Maybe String)
getPassword = do
  putStr "Entrez votre mot de passe: "
  pwd_candidate <- getLine
  let n = length pwd_candidate
  s <- return $ do
    guard (n >= 6 && n <= 8)
    guard (all (`elem` letters) pwd_candidate)
    return pwd_candidate
  putStrLn "Success!"
  return s
```

Ici, le court-circuit de `guard` n'est pas effectif sur le reste de la fonction
comme il l'est à l'intérieur du bloc `do` lui-même:

```haskell
  -- ...
  -- n == 10
  s <- return $ do
    guard (n >= 6 && n <= 8) -- sera exécuté
    guard (all (`elem` letters) pwd_candidate) -- ne sera pas exécuté en
                                               -- vertue de la définition de la monade Maybe
    return pwd_candidate
  -- ...
```

Or, on aurait aimé que le message `Success!` ne s'affiche pas dans le cas d'un
échec. En d'autres termes, on aurait aimé ici bénéficier des propriétés de la
monade `Maybe` en plus des propriétés de la monade `IO`.

## Cas typique de State

Supposons qu'on veuille écrire une fonction faisant la génération d'un nombre
dans un intervalle tout en assurant que l'intervalle n'ait pas une taille plus
élevée qu'un certain maximum. On pourrait imaginer pouvoir écrire la chose
suivante:

<!-- TODO: ajouter  les "imports" -->
```haskell
generateRandomNumberInInterval :: Int -> Int -> State StdGen Int
generateRandomNumberInInterval a b = do
  g <- get
  let (r :: Int, ng) = randomR (a, b) g
  put ng
  return r

randomNumberInInterval :: Int -> Int -> Maybe (State StdGen Int)
randomNumberInInterval a b = do
  guard (a - b + 1 <= 256)
  return $ generateRandomNumberInInterval a b
```

Ceci dit, admettons maintenant qu'on veuille retrouver un nombre aléatoire dans
l'intervalle \\([a, x]\\) où \\(x\\) est un nombre aléatoire entre \\(a\\) et
\\(b\\). On devrait donc plutôt écrire `randomNumberInInterval` comme:

```haskell
randomNumberInInterval :: Int -> Int -> Maybe (State StdGen Int)
randomNumberInInterval a b = do
  guard (a - b + 1 <= 256)
  return $ do
    x <- generateRandomNumberInInterval a b
    generateRandomNumberInInterval a x
```

En ajoutant maintenant la restriction \\(x \neq \frac{a + b}{2}\\), alors nous
sommes bloqués. Il est impossible d'avoir accès à la valeur `x` à l'intérieur du
contexte de la monade `Maybe` (hors du contexte de la monade `State` du bloc
`do`). C'est-à-dire qu'on ne peut pas écrire:

```haskell
randomNumberInInterval :: Int -> Int -> Maybe (State StdGen Int)
randomNumberInInterval a b = do
  guard (a - b + 1 <= 256)
  x <- return $ generateRandomNumberInInterval a b -- Invalide!!!
  guard (x /= (a + b) `div` 2)
  return $ generateRandomNumberInInterval a x -- Invalide!!!
```

Car ici, `x` a le type `State StdGen Int` et non pas `Int`. C'est donc dire que
nous aurions ici préféré avoir un contexte d'exécution qui réunirait encore ici
une fois la monade `Maybe` et la monade `State`.

## Les transformateurs

Les transformateurs sont des monades visant à fournir la qualité principale de
_composition de monade_. Cela est fait en fournissant une instance pour la
classe suivante:

```haskell
class MonadTrans t where
lift :: Monad m => m a -> t m a
```

L'idée étant de permettre de faire vivre dans la monade `t` une opération
originant de la monade `m` (voir la [documentation][monadtrans-doc] pour plus
d'information).

[monadtrans-doc]: https://hackage.haskell.org/package/transformers-0.5.5.0/docs/Control-Monad-Trans-Class.html

Par convention, les transformateurs de monade sont notés selon leur monade
correspondante suivi du préfixe `T`. Par exemple, la monade `Maybe` possède le
transformateur de monade `MaybeT`. On retrouve aussi la même chose pour les
différentes monades usuelles suivantes:

| Monade | Transformateur |
|--------|----------------|
| Maybe  | MaybeT         |
| State  | StateT         |
| Reader | ReaderT        |
| Writer | WriterT        |
| ...    | ...T           |

Un transformateur est normalement défini comme un `newtype` paramétré
minimalement avec une variable `m` où `m` est une monade. Par exemple, le
transformateur `MaybeT` est défini comme:

```haskell
newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }
```

De façon standard, on nomme le contenu du type par `run{Monade}T` où `{Monade}`
est le nom de la monade pour laquelle on créé le transformateur. Ceci permet
donc de développer la monade au niveau de l'appelant.

Par exemple,

```haskell
theFilePath :: String
theFilePath = "/home/haskell/transformateurs.bizzbizz"

decode :: String -> Maybe String
decode = undefined -- La définition ici pourrait échouer et donc ne pas fournir
                   -- de chaîne de caractères en sortie, d'où le type `Maybe String`

decodeFile :: String -> MaybeT IO String
decodeFile path = do
  h <- lift $ openFile path ReadMode
  s <- lift $ hGetContents h
  MaybeT . return $ decode s

main :: IO ()
main = do
  mDecodedFileContent <- runMaybeT (decodeFile theFilePath)
  putStrLn $ fromMaybe "oops... Le fichier n'a pas pu être décodé..." mDecodedFileContent
```

Dans ce cas-ci, `runMaybeT (decodeFile theFilePath)` a le type précis `IO (Maybe
String)`. Le lecteur devrait remarquer maintenant qu'en spécifiant le type de
retour `MaybeT IO String` sur la fonction `decodeFile`, on a orchestré
l'exécution de `Maybe` par dessus la monade `IO`. En général, les
transformateurs permettent de créer des _piles de monades_. Ces piles sont
ensuite développées du haut vers le bas. Par exemple, le type suivant:

```haskell
MaybeT (StateT s (Reader r)) a
```

représente la pile de monades suivante:

```
Maybe
State s
Reader r
```

Afin de développer cette pile, on devrait donc appeler les fonctions
`runMaybeT`, `runStateT`, `runReaderT` dans l'ordre afin d'obtenir le type
suivant:

```haskell
((Maybe a), s)
```

(voir les définitions respectives pour `runReaderT` et `runStateT`).

### MaybeT

Rappelons la définition de `MaybeT`:

```haskell
newtype MaybeT m a = MaybeT { runMaybeT :: m (Maybe a) }
```

Naturellement, comme `MaybeT` est une monade, il fournit une instance aux
différentes classes de type `Functor`, `Applicative` et `Monad`. Voici la
définition de l'instance de `MonadTrans`:

```haskell
instance MonadTrans MaybeT where
  lift :: m a -> MaybeT m a
  lift = MaybeT . liftM Just
```

De cette définition, on comprend que toute opération dans une monade `m` peut
être enveloppée dans la monade `MaybeT`. Pour y voir encore plus claire,
regardons la définition de l'instance de la classe de type `Monad` pour
`MaybeT`:

```haskell
instance Monad (MaybeT m) where
  mbta >>= f = MaybeT $ do
    ma <- runMaybeT mbta
    case ma of
      Just a -> runMaybeT $ f a
      Nothing -> return Nothing
```

On voit que dans la monade `MaybeT`, la monade `m` s'exécute en premier en
prenant `mbta` et en le passant dans le bloc `do` pour le développer comme `ma`,
une variable de type `Maybe a`. Ce faisant, à ce point-ci, l'effet de la monade
`m` a déjà eu lieu. Ensuite, le reste de l'exécution du bloc `do` consiste en
l'effet contribué par la monade `MaybeT` dans la pile de monades:

```haskell
case ma of
  Just a -> runMaybeT $ f a
  Nothing -> return Nothing
```

Il s'agit effectivement de l'effet de `Maybe`, c.-à-d. un court-circuit
d'exécution dans le cas où la valeur `ma` est `Nothing`. Sinon, la suite
représentée par la fonction `f` est exécutée puis enveloppée à nouveau dans le
contexte de la monade `MaybeT`.

**Retour sur l'exemple initial pour MaybeT**

Rappelons premièrement l'état final que nous avions:

```haskell
letters :: [Char]
letters = ['a'..'z'] ++ ['A'..'Z']

getPassword :: IO (Maybe String)
getPassword = do
  putStr "Entrez votre mot de passe: "
  pwd_candidate <- getLine
  let n = length pwd_candidate
  s <- return $ do
    guard (n >= 6 && n <= 8)
    guard (all (`elem` letters) pwd_candidate)
    return pwd_candidate
  putStrLn "Success!"
  return s
```

Comme mentionné plutôt, nous aurions voulu que l'exécution de `guard` ait un
effet sur l'instruction `putStrLn`. Nous pouvons maintenant le faire comme suit:

```haskell
getPassword :: MaybeT IO String
getPassword = do
  lift $ putStr "Entrez votre mot de passe: "
  pwd_candidate <- lift getLine
  let n = length pwd_candidate
  guard (n >= 6 && n <= 8)
  guard (all (\ c -> elem c letters) pwd_candidate)
  lift $ putStrLn "Success!"
  return pwd_candidate
```

### StateT

<!-- TODO -->
Le transformateur correspondant à la monade `State` est défini comme suit:
```haskell
newtype StateT s m a = StateT { runStateT :: s -> m (a,s) }
```

Pour comparaison, observons la définition de la monde `State`:

```haskell
newtype State s m a = State { runState :: s -> (a,s) }
```

On voit tout de suite la similitude entre les deux. En fait, tout comme
`MaybeT`, la définition de la monade est la même à la différence prêt qu'on a
enveloppé le type de retour dans une monade arbitraire.

Comme `MaybeT`, le transformateur `StateT` possède une instance pour la classe
de type `MonadTrans`, ce qui permet donc d'appeler `lift` à l'intérieur de son
contexte d'exécution. Pour notre exemple initialisé plus haut, on a donc:

```haskell
randomNumberInInterval :: Int -> Int -> MaybeT (State StdGen) Int
randomNumberInInterval a b = do
  guard (a - b + 1 <= 256)
  x <- lift $ generateRandomNumberInInterval a b
  guard (x /= (a + b) `div` 2)
  lift $ generateRandomNumberInInterval a x
```

C'est exactement ce qu'on souhaite faire plus haut, à la différence près que les
instructions (fautives) `return` ont été remplacées par `lift`. On bénéficie
donc ici des effets des deux monades en simultané, c.-à-d. que le fil
d'exécution est régit par les effets de `Maybe` via les instructions `guard` et
finalement `lift` permet de récupérer la valeur `x`. De plus, l'état `s`
retourné par le premier appel de `generateRandomNumberInInterval` est fournit en
entrée au second appel. En d'autres termes, l'état `s` est partagé.

### Classes de types

La bibliothèques [MTL][mtllib] fournit certaines classes de type permettant
d'alléger l'écriture des piles de monades dans les signatures en remplaçant les
types concrets de transformateurs par des contraintes sur les classes de type.
Par exemple, la classe de type `MonadState` est analogue à `StateT`:

```haskell
class Monad m => MonadState s m | m -> s where
  get :: m s
  put :: s -> m ()
```

Ceci permet donc d'écrire la fonction de l'exemple sur `StateT` comme suit:

```haskell
randomNumberInInterval :: MonadState StdGen m => Int -> Int -> MaybeT m Int
randomNumberInInterval a b = do
  guard (a - b + 1 <= 256)
  x <- lift $ generateRandomNumberInInterval a b
  guard (x /= (a + b) `div` 2)
  lift $ generateRandomNumberInInterval a x
```

moyennant qu'on adapte la signature de `generateRandomNumberInInterval` comme
suit:

```haskell
generateRandomNumberInInterval :: MonadState StdGen m => Int -> Int -> m Int
```

On peut tester le résultat comme suit:

```haskell
test :: IO ()
test = do
  g <- newStdGen
  (mi, s) <- runStateT (runMaybeT $ randomNumberInInterval' 0 1) g
  print mi
```

La trace de plusieurs appels à cette fonction pourrait donner quelque chose
comme:

```
*Main> test
Nothing
*Main> test
Just 1
*Main> test
Nothing
*Main> test
Nothing
*Main> test
Just 0
*Main> test
Just 0
*Main> test
Just 0
*Main> test
Just 1
*Main> test
Nothing
*Main> test
Nothing
```

On voit bien qu'une fois sur deux (en moyenne), le retour de la fonction est `0`
puisqu'une fois sur deux, le premier appel de `generateRandomNumberInInterval`
retourne `0`.

**Les classes de types et les piles de monades**

On pourrait facilement arguer qu'il n'y a pas un grand avantage à utiliser la
classe de type dans l'exemple précédent. Par contre, il est à noter qu'au lieu
d'utiliser `StateT` pour satisfaire la contrainte `MonadState` il est possible
de fournir une monade quelconque fournissant une instance pour la classe.

En particulier, les différents transformateurs de la bibliothèque MTL
fournissent des instances conditionnelles à chacune des classes lorsque le
transformateur en question ne fournit pas une instance concrète. Une instance
conditionnelle est une instance qui se réalise si la monade sous-jacente fournit
une instance concrète. Par exemple, dans la bibliothèque MTL, on retrouve:

```haskell
instance MonadState s m => MonadState s (MaybeT m) where
  get = lift get
  put = lift . put
  state = lift . state

instance MonadState s m => MonadState s (ReaderT r m) where
  get = lift get
  put = lift . put
  state = lift . state

instance (Monoid w, MonadState s m) => MonadState s (Lazy.WriterT w m) where
  get = lift get
  put = lift . put
  state = lift . state
```

On voit donc que `MaybeT` et `ReaderT` satisfont la classe `MonadState`, mais
**seulement** si la monade sous-jacente `m` fournit elle-même une instance pour
`MonadState`. On voit donc qu'on peut facilement empiler `ReaderT`, `MaybeT`,
`WriterT` et d'autres transformateurs ensemble tout en satisfaisant la
contrainte. Notamment, dans notre exemple:

```haskell
randomNumberInInterval :: MonadState StdGen m => Int -> Int -> MaybeT m Int
```

`m` n'est pas contraint d'être `StateT` ni `State`. En fait, cela peut être une
pile arbitrairement élevée de monades fournissant une instance à `MonadState`.
Le tout fonctionnera tant et aussi longtemps qu'au moins _une monade dans la
pile fournit une instance **concrète**_ de la classe `MonadState`. Donc, ici `m`
pourrait aussi bien correspondre à `ReaderT r (WriteT w (StateT s m))` qu'à
simplement `StateT s m`.

[mtllib]: https://hackage.haskell.org/package/mtl-2.2.2/

## Conclusion

Les monades sont une pièce angulaire de la programmation fonctionnelle. Or, le
besoin se fait vite ressentir de combler le manque de composition des monades
lorsqu'on développe en Haskell. Les transformateurs permettent de combler ce
manque de façon à rendre l'écriture du code plus puissante. Les classes de type
de la bibliothèque MTL viennent compléter avec une touche de généricité ce qui
augmente considérablement les capacités des transformateurs. En somme, les
transformateurs sont un incontournable de la programmation en Haskell.

<!-- vim: set ft=pandoc.markdown.html.haskell sts=2 ts=2 sw=2 tw=80 et :-->

