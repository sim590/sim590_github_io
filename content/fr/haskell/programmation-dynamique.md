+++
categories = ['Algorithmique', 'Haskell', 'Mémoïsation', 'Programmation', 'Programmation dynamique']
tags       = ['Séquence de Collatz', 'Data.Array', 'nombre triangulaire']
title      = "Haskell: programmation dynamique"
date       = 2020-03-02T04:06:13-05:00
meta_image = "images/haskell.png"
+++
<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

L'approche de programmation dynamique est souvent associée au remplissage d'un
tableau à deux dimensions et à l'écriture explicite de ce procédé sous forme
itérative. Dans un langage fonctionnel comme Haskell, on bénéficie de quelques
avantages d'expressivité de haut niveau et de lisibilité qu'on ne retrouve pas
autrement.

Dans cet article, je commence par explorer deux exemples triviaux de
programmation dynamique. Ensuite, je passe sur un problème tout aussi
accessible, mais dont l'achèvement optimal demandera l'utilisation d'une
structure `Data.Array` plutôt que la liste conventionnelle.

## Évaluation paresseuse

La particularité principale d'Haskell est qu'il s'agit d'un [langage
paresseux][], c'est-à-dire que l'évaluation d'une expression ou d'une valeur est
faite de manière paresseuse. Plus précisément, on peut formuler ce concept par
*la propriété d'un langage à garantir l'évaluation de la valeur d'une expression
donnée que si celle-ci est bien nécessaire à un calcul subséquent.* Par exemple,
considérons l'expression `repeat 0`. Cette expression correspond à une liste de
taille virtuellement infinie. Cependant, `head (repeat 0)` correspond à une
valeur de taille finie, en l'occurence `0`. Comme Haskell est paresseux, il ne
tente d'évaluer `repeat 0` « complètement » que si c'est ce qui lui est demandé.
Or, en passant `repeat 0` en argument à `head`, on indique à Haskell qu'on n'est
intéressé que par le premier élément, alors la liste `repeat 0` ne sera jamais
générée au complet, mais seul le premier élément sera calculé.

[langage paresseux]: https://fr.wikipedia.org/wiki/%C3%89valuation_paresseuse

## Diviser pour régner et calculs en double

Lorsqu'on souhaite résoudre un problème complexe, il est commun d'employer une
approche où on réduit un problème à des sous-problèmes permettant ainsi de
converger éventuellement en une solution finale. Cette approche s'appelle
« diviser pour régner » et permet l'écriture de solutions élégantes (voir
l'algorithme de [tri fusion][]).

L'indicateur premier de la pertinence d'investiguer pour une approche de programmation
dynamique est celui de l'occurrence de calculs faits en double. Comme la méthode
« diviser pour régner », l'approche de programmation dynamique se base sur un
principe de division d'un problème en sous-problèmes suivant le principe
d'optimalité de Bellman:

> Une solution optimale à un problème s'obtient en combinant des solutions
> optimales à des sous-problèmes.

En d'autres termes, pour que le principe s'applique, il est nécessaire que la
combinaison des solutions aux sous-problèmes soit optimale, lorsque les
solutions aux sous-problèmes sont elles-mêmes optimales.

## Suite de Fibonacci

```haskell
import Numeric.Natural
```

Considérons le problème de déterminer le \\(n^{\text{ème}}\\) terme de la [suite
de Fibonacci][fibo]. La récurrence très connue, définie sur les entiers
naturels, est la suivante:

$$
f(n) =
\begin{cases}
  0               & \text{si}\ n=0\\\\
  1               & \text{si}\ n=1\\\\
  f(n-1) + f(n-2) & \text{sinon}
\end{cases}
$$

L'écriture de cette fonction, suivant cette relation, est évidente:

```haskell
fib :: Natural -> Natural
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)
```

Cet algorithme est cependant non optimal puisqu'il est facile de voir que
celui-ci effectue plusieurs calculs en double. Par exemple, pour \\(f(5)\\) on
doit calculer \\(f(3)\\) et \\(f(4) = f(2) + f(3)\\). On voit bien qu'au moment
de calculer \\(f(4)\\), il serait pertinent de récupérer la valeur déjà calculée
\\(f(3)\\) afin d'éviter de la recalculer. Malheureusement, l'algorithme décrit
plus haut ne fait pas cela. Il vaut la peine de noter que plus la valeur de
\\(n\\) est élevée, plus le nombre de redondance augmente, ce qui gonfle ainsi
la gravité du problème.

### Fibonacci: optimisation

La programmation dynamique nous permet de régler ce problème. Par exemple, on
pourrait écrire la chose suivante:

```haskell
mfib :: Int -> Natural
mfib = (map fib [0..] !!) -- (ii)
  where fib 0 = 0
        fib 1 = 1
        fib n = mfib (n-2) + mfib (n-1) -- (i)
```

Le changement apporté au code plus haut devrait être analysé en plusieurs
parties. Premièrement, on retrouve la définition de `fib` qui ressemble pas mal
à la première écriture. Cependant, on remarque que la définition du cas général
\\((i)\\) ne fait plus directement appel à `fib`, mais à `mfib`. Deuxièmement,
on remarque que la définition principale de `mfib` \\((ii)\\) fait un appel à
`fib`. On a donc deux fonctions s'appellant en chaîne, ce qui ferme la boucle
d'appels:

$$\texttt{fib} \rightarrow \texttt{mfib} \rightarrow \texttt{fib} \rightarrow \dots$$

Ainsi, le tout correspond à une fonction récurisve convergeant vers les cas de
base tout comme c'était le cas dans [la première approche]({{< ref
"#suite-de-fibonacci">}}). Ceci dit, l'entrelacement entre `mfib` et `fib` forme
justement la différence majeur entre les deux approches. En effet, `mfib` est
défini comme l'accès `(!!)` au \\(n^{\text{ème}}\\) élément de la liste

```haskell
map fib [0..] -- (ii)
```

Cette liste correspond bien sûr à la liste abstraite suivante:

<div align=center>
  <code align=center>[fib 0, fib 1, fib 2, ...]</code>
</div><br>

Notons premièrement que la liste `map fib [0..]` est une expression
correspondant à une liste infinie. Mais comme Haskell est un [langage
paresseux]({{<ref "#%C3%A9valuation-paresseuse">}}), seuls les éléments
nécessaires au calcul demandé par l'appel initial de `mfib` seront calculés.

Regardons de plus près ce qui se passe avec un exemple sur `mfib 5`.
Premièrement, l'accès au \\(5^\text{ème}\\) élément de la liste sera demandé, ce
qui engendrera l'appel à `fib 5` qui en retour correspond à `mfib 3` et `mfib
4`. L'expression partielle correspondant au calcul demandé initialement est
donc `mfib 3 + mfib 4`. Or, `mfib 3` est le \\(3^\text{ème}\\) élément de la
liste \\((ii)\\). On déduit une chose similaire pour `mfib 4`.

On pourrait croire un instant qu'Haskell pourrait calculer `mfib 3` une fois, le
stocker dans le tableau et que, le moment venu, `mfib 4` provoque le même
calcul, mais il s'avère qu'Haskell partage la liste \\((ii)\\) entre les
différents appels de `fib`. Ainsi, le premier fil d'exécution permettant de
calculer `fib 3` provoquera l'inscription de cette valeur dans la liste afin que
les appels subséquents n'aient qu'à réutiliser la valeur dans la liste. Il
s'agit là de la forme la plus évidente et intuitive de l'écriture de cet
algorithme sous une approche de programmation dynamique. Autrement, il est
possible aussi d'écrire une expression remplissant la même fonction en une
ligne:

```haskell
fibs :: [Natural]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)
```

Cett expression correspond bien sûr à la liste de tous les nombres de Fibonacci.
Il suffit maintenant d'accéder à l'élément qu'on souhaite, par exemple le
\\(5^\text{ème}\\), avec `fibs !! 5`. Ici encore, on emploie une approche de
programmation dynamique puisque la liste est progressivement construite en
réutilisant les deux derniers éléments de la liste pour les additionner afin de
former le prochain élément *ad infinitum*.

[fibo]: https://fr.wikipedia.org/wiki/Suite_de_Fibonacci
[tri fusion]: https://fr.wikipedia.org/wiki/Tri_fusion

## Nombres triangulaires

```haskell
import Numeric.Natural
```

Considérons maintenant le problème de générer les [nombres
triangulaires][triangulaire]. On sait que \\(t_n\\), le \\(n^{\text{ème}}\\)
nombre triangulaire, est donné par l'expression suivante:

$$ t_n = \sum_{i=1}^n i = 1 + 2 + \dots + n$$

Une première approche vient rapidement en tête:

```haskell
triangs :: [Natural]
triangs = [sum [1..n] | n <- [1..]]
```

Cependant, cette première approche est absolument affreuse. On refait clairement
plusieurs fois les mêmes calculs. On pourrait aussi tirer avantage du fait que
\\(t_n\\) trouve l'expression équivalente suivante:

$$ t_n = \frac{n(n+1)}{2} $$

Ainsi, on pourrait alors écrire:

```haskell
triangs' :: [Natural]
triangs' = [n * (n + 1) `div` 2 | n <- [1..]]
```

Bien que cette stratégie, reposant sur un astuce analytique, apporterait là une
amélioration substantielle, cela ne ferait pas de cette approche une voie tout à
fait optimale. En effet, on remarque qu'on effectue une multiplication, une
division et une addition pour chaque élément généré. Il est possible de faire
mieux en utilisant la programmation dynamique. De façon similaire à la dernière
solution pour Fibonacci, on peut écrire:

```haskell
triangs'' :: [Natural]
triangs'' = 1 : zipWith (+) triangs'' [2..]
```

Ici, on créé encore une fois une liste qui se joint à une seconde liste, la
liste infinie `[2..]`, par l'addition des éléments de chaque liste deux à deux.
On peut développer l'expression comme suit:

```plain
1 : zipWith (+) [1,...] [2,3,4...]         correspond à [1, 3, ...]
1 : 3 : zipWith (+) [3,...] [3,4,5...]     correspond à [1, 3, 6, ...]
1 : 3 : 6 : zipWith (+) [6,...] [4,5,6...] correspond à [1, 3, 6, 10, ...]
```

Évidemment, une méthode plus intuitive (mais plus verbeuse) est aussi possible.

[triangulaire]: https://fr.wikipedia.org/wiki/Nombre_triangulaire

## Séquences de Collatz

```haskell
import Numeric.Natural
import Data.Array
```

Bien que ce prochain problème n'est pas d'un ordre différent de difficulté, nous
allons prendre une avenue qui diffère légèrement afin de garantir encore un
rendement optimal.

Une séquence de Collatz est une séquence de nombres générée suivant un nombre en
entrée, appelons cet élément « racine ». Soit \\(g: \mathbb{N} \longrightarrow
\mathbb{N}\\) définie comme:

$$
g(m) =
\begin{cases}
  \frac{m}{2} & \text{si}\ m\ \text{est pair}\\\\
  \\\\ % Nécessaire car autrement, l'équation n'arrive pas à se dessiner (trop serré)
  3m + 1      & \text{sinon}
\end{cases}
$$

Une séquence de Collatz, pour une racine \\(r\\), est définie comme la suite

$$(g(r), (g \circ g)(r), (g \circ g \circ g)(r), \dots, 1).$$

où \\(\circ\\) représente la composition de fonction.

### Problème

Pour \\(n \in \mathbb{N}\\), on souhaite déterminer la taille de la plus longue
séquence de Collatz pour tout \\(1 \le r \le n\\).

Une approche naïve pourrait ressembler à la suivante. Définissons premièrement
une fonction calculant la prochaine valeur de la séquence. Appelons la `step`:

```haskell
step :: Natural -> Natural
step 1 = 1
step m
  | even m    = m `div` 2
  | otherwise = (3 * m + 1) `div` 2
```

Remarquons que le cas où \\(m\\) est impair n'est plus \\(3m+1\\), mais
maintenant \\(\frac{(3m+1)}{2}\\). Ceci est possible sans perte de généralité
puisque si \\(m\\) est impair, alors \\(m=2k+1\\) pour \\(k\in\mathbb{N}\\).
Ainsi,

$$ 3m+1 = 3(2k+1)+1 = 2(3k +2) \quad \text{est pair}. $$

Ce faisant, le traitement où l'argument de `step` est pair peut tout de suite
s'appliquer sur l'image de \\(3m+1\\). On sauve ainsi une étape à chaque nombre
impair rencontré.

Ensuite, l'algorithme bête pour déterminer la longueur d'une séquence de Collatz
avec pour racine `m` pourrait ressembler au suivant.

```haskell
dumbSeq :: Natural -> Int
dumbSeq m = (+1) $ length $ takeWhile (/=1) $ iterate step m
```

La lecture est assez directe. On itère sur les appels successifs de `step` avec
comme premier argument `m` jusqu'à ce qu'on tombe sur `1`. Ici, `iterate` créé
la liste de tous les résultats d'applicaiton de `step`. On n'a donc qu'à prendre
la taille de cette liste et additionner 1 (pour compter le nombre 1). Afin de
calculer la valeur maximale pour \\(1 \le r \le \text{n}\\), on peut alors
calculer comme suit:

```haskell
maxDumb :: Natural -> Natural
maxDumb 1 = 0
maxDumb n = snd $ maximum $ map (\ m -> (dumbSeq m, m)) [1..n]
```

Ici, on créé une liste de paires ordonnées \\((g^i(m), m)\\). On trouve le
maximum de cette liste en comparant le premier élément de chaque paire ordonnée
(le comportement par défaut de `compare` tel que défini pour l'instance `(,) a`
de la classe `Ord`).

Clairement, pour \\(n\\) suffisamment grand, le problème peut devenir couteux en
temps. On remarque bien sûr que certaines séquences se croisent. Par exemple:

```plain
r = 3 => g(3) = g(5) = g(8) = g(4) = g(2) = 1
r = 4 =>                      g(4) = g(2) = 1
```

Ce faisant, si on avait à calculer la longueur de la séquence pour \\(g(3)\\)
avant \\(g(4)\\), alors le calcul à l'itération \\(r=4\\) serait gratuit si nous
employions une approche de programmation dynamique.


Supposons qu'on soit intéressé à trouver la réponse pour \\(n\\) très grand. Il
serait d'abord nécessaire de fixer une taille maximale pour l'antémémoire
utilisée pour stocker les valeurs déjà calculées. Disons que \\(10^6\\) est
raisonnable:

```haskell
bigN :: Natural
bigN = 10 ^ (6 :: Natural)
```

Ensuite, nous définissons la structure `seqArray`  servant d'antémémoire ainsi que la
routine de comptage des itérations `seq'` à travers `step`:

```haskell
seq' :: Natural -> Natural
seq' 1 = 1
seq' i = 1 + next
  where i' = step i
        next | i' > bigN = seq' i'
             | otherwise = seqArray ! i'

seqArray :: Array Natural Natural
seqArray = listArray bounds' [ seq' i | i <- range bounds']
  where bounds' = (1, bigN)
```

Nous avons grandement avantage ici à utiliser un tableau permettant un accès
\\(\mathcal{O}(1)\\) pour chaque valeur. Bien que c'était autant le cas pour les
deux problèmes précédents, nous n'avons pas introduit l'utilisation de
`Data.Array` jusqu'ici afin de simplifier les choses.

### Fonctionnement

Comme précédemment, remarquons la liaison entre `seq'` et `seqArray`. On voit
bien que `seq'` est défini en fonction de `seqArray` et vice versa. D'un côté,
on peut le voir comme le fait que `seq'` utilise les valeurs inscrites dans le
tableau afin de faire ses calculs. De l'autre côté, on peut interpréter que
`seqArray` n'est défini que pour les valeurs que `seq'` prend. Il y a là une
*différence majeur* avec l'écriture dans un langage impératif comme ceux
s'apparentant au langage C, par exemple.

*Il n'y a aucune exigence à l'endroit du programmeur à déterminer les indices
admissibles pour indexation dans le tableau.* **La paresse d'Haskell s'occupe de
tout**.

### Séquence de taille maximale

Finalement, la fonction suivante évalue la taille maximale d'une séquence pour
une racine \\(1 \le r \le \texttt{n}\\).

```haskell
maxSeq :: Natural -> Natural
maxSeq 1 = 0
maxSeq n = l
  where (_, l) = maximum $ map swap $ genericTake n $ assocs seqArray
```

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

