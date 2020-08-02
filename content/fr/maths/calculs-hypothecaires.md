---
title:            "Calculs hypothécaires"
date:             2020-07-31T21:18:20-04:00
description:
draft:            false
hideToc:          false
enableToc:        true
enableTocContent: false
tags:             ["Hypothèque", "Prêt", "Dette", "Intérêt", "Paiement bancaire", "Newton", "Pascal"]
categories:       ["Mathématiques", "Finance"]
meta_image:       images/maths/newton.jpg
---

<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

Je regarde les maisons et condos depuis un certain temps déjà, histoire de
sentir un peu ce que l'achat implique pour un emprunteur. J'ai pris la peine de
rechercher différentes informations comme les conditions et les options pour une
assurance hypothèque, les frais associés à l'habitation (charge de copropriété,
taxe scolaire, etc.) ainsi que les taux d'intérêt associé à un prêt. J'ai donc
voulu mettre tout cela en commun afin d'avoir un aperçu de mes paiements par
mois ainsi que ce que cela engendre sur une période plus longue comme 5, 10 ou
même 25 ans. J'ai ainsi eu l'occasion de faire certains calculs qui seront
utiles à plusieurs pour comprendre comment les paiements hypothécaires sont
calculés. En particulier, je veux exposer trois calculs clefs dans la prévision
des avantages et inconvénients d'acheter une propriété versus louer un logement:

* le paiement bancaire régulier (hypothèque et intérêt);
* le montant de prêt hypothécaire payée sur \\(n\\) années;
* et l'intérêt sur le prêt payé sur \\(n\\) années.

## Paiements bancaires

Admettons qu'on ait un prêt hypothécaire octroyé par une banque. Ce prêt
s'appelle «prêt hypothécaire». Celui-ci a une valeur qui varie dans le temps
puisqu'on fait des paiements mensuels afin de le réduire. Notons \\(H_k\\) le
montant du prêt hypothécaire courant après la \\(k^{e}\\) année, c.-à-d. ce qui
reste à payer après \\(k\\) années de paiement. Le montant du prêt sera donc
noté \\(H_0\\).  Notons maintenant \\(P\\) le paiement bancaire à faire par
année pour arriver à payer notre prêt au fil des années. Il faut bien sûr
considérer aussi finalement l'intérêt sur le prêt. Notons-le \\(i\\). De cela,
si on souhaitait payer notre prêt en une seule année, on pourrait alors écrire:

$$
H_0 + iH_0 = P
$$

Ici, on lit la relation comme «le paiement à faire est la somme du prêt en plus
des intérêts sur le prêt.

Cette relation peut se réécrire comme:

$$
H_0(i+1) - P = 0
$$

Pour le besoin de la cause, c'est la forme qu'on garde pour le reste du
document. Or, si on souhaitait payer en deux ans, on aurait alors:

$$
(H_0(i+1) - P)(i+1) - P = 0
$$

Bien sûr! Puisque la seconde année, le montant de prêt hypothécaire restante
était \\(H_0(i+1) - P\\). On voit bien que cette quantité a été multipliée par
\\((i+1)\\), comme c'était le cas pour \\(H_0\\) la première année. N.B: ici,
\\(P\\) ne vaut pas la même quantité que dans le scénario où on paie tout en une
année. Bien sûr, là le montant est un peu plus gros que la moitié de l'ancien
montant pour \\(P\\).  Bref, si on continuait le procédé jusqu'à \\(n\\) années,
on aurait alors:

$$
(...(H_0(i+1) - P)(i+1) - P ...)(i+1) - P = 0
$$

où \\(H_0\\) (ou \\(P, i\\)) apparaîtrait \\(n\\) fois dans l'expression.
Reprenons l'expression de départ et réordonnançons le tout comme:

$$
H_0 = \frac{P}{(i+1)}
$$

Faisons maintenant la même chose avec la seconde expression:

$$
H_0 = \frac{P}{(i+1)} + \frac{P}{(i+1)^2}
$$

Encore, une fois pour la bonne cause, avec \\(n=3\\):

$$
H_0 = \frac{P}{(i+1)} + \frac{P}{(i+1)^2} + \frac{P}{(i+1)^3}
$$

On voit maintenant apparaître un motif régulier! L'exposant du dénominateur
augmente sur chaque terme et le numérateur reste constant. Lorsque \\(n\\)
possède une valeur arbitraire, on peut donc réécrire comme:

$$
H_0 = P \left\(
    \frac{1}{(i+1)} + \frac{1}{(i+1)^2} + \frac{1}{(i+1)^3} + ... + \frac{1}{(i+1)^n}
  \right\)
$$

Notons maintenant l'expression \\(\frac{1}{i+1}\\) par \\(r\\).  La série qui se
trouve entre parenthèse est bien connue, il s'agit de la série géométrique. Il
est facile à démontrer qu'elle équivaut à l'expression suivante:

$$
\frac{r - r^{n+1}}{1 - r}
$$

Par conséquent, on peut écrire:

$$
H_0 = P \frac{r - r^{n+1}}{1 - r}
$$

Ce qui mène évidemment à ce que:

---

$$
P = H_0\frac{1 - r}{r - r^{n+1}}
$$

---

Et voilà! On a maintenant une formule exacte du paiement bancaire à effectuer à
la banque à chaque année si on souhaite régler le paiement de notre hypothèque
\\(H_0\\) après \\(n\\) années suivant le taux d'intérêt \\(i\\).

**Exemple!**

Si on a un hypothèque de 200000 dollars avec un taux d'intérêt de 2% par années
et qu'on souhaite régler le paiement de la dette en 25 ans, alors on aura un
paiement régulier par année à faire de:

$$
\begin{align}
  P &= 200000\frac{1 - (1.02)^{-1}}{(1.02)^{-1} - (1.02)^{-26}}\\\\
    &= 10244.43
\end{align}
$$

Si on rapporte ça sur 12 mois, on aura donc un paiement mensuel de 853.70.

Voilà qui est bien! Ceci dit, connaître le paiement bancaire ne donne pas la
totalité de l'information intéressante. En effet, soit \\(y_k\\) l'intérêt à
payer et \\(x_k\\) le montant de prêt hypothécaire payé, tous deux
respectivement la \\(k^{e}\\) année. On a bien sûr la relation suivante pour
tout \\(k\\):

$$
P = y_k + x_k
$$

Ce faisant, même si on connaît \\(P\\), on ne sait pas encore quelle portion va
dans les intérêts à payer et quelle portion va dans le montant de prêt
hypothécaire. Puisque le montant d'hypothèque réduit à chaque année, il est
clair que la portion d'intérêt dans le paiement régulier \\(P\\) va descendre au
fil du temps. Mais comment connaître \\(x_k\\) et \\(y_k\\)? Plus
particulièrement, les sommes payées après \\(n\\) années sont d'un grand intérêt
(sans jeu de mot :) )!

## Portion d'hypothèque du paiement bancaire

Dans la dernière section, nous avons déterminé le calcul pour le paiement
bancaire régulier à faire par année pour régler sa dette après \\(n\\) années.
Qu'en est-il de la somme d'hypothèque payée après \\(n\\) années? Bien sûr, si
on effectue notre paiement sur 25 ans et qu'on s'interroge à connaître
\\(\sum_{k=1}^25 x_k\\), il est clair que cela est équivalent à le montant de
prêt hypothécaire final \\(H_0\\) puisqu'on a réglé \\(P\\) de sorte qu'on ait
tout payé après 25 ans. Mais, si on s'intéressait plutôt à le montant de prêt
hypothécaire payée après 5 ans pour un paiement qui s'effectue sur 25 ans?

Premièrement, en reprenant le contexte de la section précédente, on peut écrire
que:

$$
x_1 = P - iH_0
$$

puisque \\(x_1\\) étant le montant de prêt hypothécaire payé la première année,
on trouve que le paiement bancaire total retranché de l'intérêt sur la première
année, c.-à-d.  l'intérêt appliquée sur le montant de prêt hypothécaire
\\(H_0\\), va nécessairement nous laisser avec la valeur d'hypothèque payée
cette année. Bien, mais on aimerait connaître \\(x_1, x_2, ..., x_n\\)...
Essayons de voir ce qui se passe avec \\(x_2\\):

$$
x_2 = P - iH_1
$$

Or, on sait que  \\(H_1 = H_0 - x_1\\) puisque \\(x_1\\) est la première portion
d'hypothèque payée la première année qu'on retranche à \\(H_0\\). On peut donc
écrire:

$$
x_2 = P - i(H_0 - x_1) = P - i(H_0 - P + iH_0)
$$

En réarrangeant le tout, on trouve:

$$
x_2 = P(1+i) - iH_0(1+i)
$$

Se peut-il qu'on tombera sur une formule récurrente cette fois-ci encore? :)
Essayons de voir ce que \\(x_3\\) nous réserve:

$$
x_3 = P - i(H_0 - x_2 - x_1)
$$

Évidemment, \\(H_0 - x_2 - x_1\\) est le montant de prêt hypothécaire la 3e
année, donc si on y multiplie le pourcentage d'intérêt et qu'on retranche cette
valeur à \\(P\\), on va trouver le montant de prêt hypothécaire payé la
\\(3^{e}\\) année. En faisant comme pour \\(x_2\\), on retrouve l'expression
suivante:

$$
x_3 = P - i (H_0 - (P(1+i) - iH_0(1+i)) - (P - iH_0))
$$

On peut alors réécrire tout comme:

$$
x_3 = P(1+2i+i^2) - iH_0(1+2i+i^2)
$$

Par le même procédé, on trouve:

$$
x_4 = P(1+3i+3i^2+i^3) - iH_0(1+3i+3i^2+i^3)
$$

et

$$
x_5 = P(1+4i+6i^2+4i^3+i^4) - iH_0(1+4i+6i^2+4i^3+i^4)
$$

Clairement, il y a un motif qui s'installe dans ces expressions et qui les lie
toutes entre elles. En effet, on peut remarquer deux choses liant \\(x_1, x_2,
x_3, x_4\\) et \\(x_5\\):

* l'exposant du polynôme de l'expression \\(x_k\\) est de degré \\(k-1\\).
* les coefficients de chacun des termes du polynôme respecte une certaine
  symétrie. D'abord, \\(1\\), ensuite \\(1 --- 1\\), puis \\(1 --- 2 --- 1\\),
  \\(1 --- 3 --- 3 --- 1\\) et enfin \\(1 --- 4 --- 6 --- 4 --- 1\\). La suite
  des coefficients constitue donc un palindrome, c.-à-d. qu'on peut la lire de
  gauche à droite ou de droite à gauche et elle est la même.

Généraliser le premier point est rapide, il s'agit d'une simple boucle, mais
pour ce qui est du second point, il s'agit là d'un motif connu! On le retrouve
dans le fameux [Triangle de Pascal][tripascal]:

```
1
1 1
1 2 1
1 3 3 1
1 4 6 4 1
```

Les coordonnées de ce triangle sont déterminées par une combinaison notée
\\(C(n, k)\\) ou \\(n \choose k\\) qui est définie par l'expression suivante:

$$
{n \choose k} = \frac{n!}{(n-k)!k!}
$$

pour \\(n \ge 0\\) et \\(0 \le k \le n\\). En effet, le premier terme de notre
suite, en haut du triangle, à la position \\((0,0)\\), est donc donné par:

$$
{0 \choose 0} = \frac{0!}{(0-0)!0!} = 1
$$

La seconde ligne est donc trouvée par:

$$
{1 \choose 0}\ --- {1 \choose 1}
$$

c.-à-d. \\(1 --- 1\\). On a ensuite les termes de la \\(3^{e}\\) ligne avec:

$$
{2 \choose 0}\ --- {2 \choose 1}\ --- {2 \choose 2}
$$

ou encore \\(1 --- 2 --- 1\\). Ce faisant, on peut donc réécrire notre
expression pour \\(x_5\\) comme:

$$
x_5 = (P - iH_0)\left(
  {4 \choose 0}+{4 \choose 1}i+{4 \choose 2}i^2+{4 \choose 3}i^3+{4 \choose 4}i^4
\right)
$$

où \\(P - iH_0\\) est la factorisation de \\(P\\) et \\(iH_0\\) tous deux
multipliés au même polynôme. Par conséquent, on a de façon plus succincte:

$$
x_5 = (P - iH_0)\sum_{k=0}^{4} {4 \choose k}i^{k}
$$

Plus généralement, on écrira donc:

$$
x_n = (P - iH_0)\sum_{k=0}^{n-1} {n-1 \choose k}i^{k}
$$

Or, l'expression \\(\sum_{k=0}^{n-1} {n-1 \choose k}i^{k}\\) est très connue! Il
s'agit d'un [binôme de Newton][binewton] qui correspond à l'expression
\\((i+1)^{n-1}\\). Ce faisant, on peut réécrire \\(x_n\\) comme suit:

---

$$
x_n = (P - iH_0)(i+1)^{n-1}
$$

---

**Exemple!**

En reprenant les hypothèses de l'exemple précédent, on a:

$$
\begin{cases}
H_0 &= 200000 \\\\
i &= 0.02 \\\\
P &= 10244.43
\end{cases}
$$

Le paiement d'hypothèque la première année serait donc:

$$
x_1 = (P - iH_0)(i+1)^{1-1} = P - iH_0 = 10244.43 - 0.02 \cdot 200000 = 6244.43
$$

Ce faisant, rapporté sur 12 mois, on trouvera un paiement d'hypothèque de
520.37. Pour comparaison, le paiement bancaire mensuel est de 853.70.

**Remarque**: dans le calcul de l'exemple, le lecteur devrait remarquer qu'à
droite de la seconde égalité, l'expression de \\(x_1\\) était ramenée à sa plus
simple forme, c.-à-d. tel que décrite au départ plus haut dans le document comme
\\(P - iH_0\\). Cette étape a explicitement été laissé afin qu'on remarque le
bon fonctionnement de la formule, du moins pour le cas \\(n=1\\).

Voilà qui est bien. Cependant, je dois rappeler au lecteur que cette expression
ne nous fournit que la valeur de le montant de prêt hypothécaire à payer la
\\(n^{e}\\) année. Il serait intéressant d'obtenir la somme d'hypothèque payée
au bout de \\(n\\) années. Notons cette somme au bout de \\(k\\) années
\\(X_n\\). Cela correspond donc à l'expression suivante:

$$
X_n = \sum_{k=1}^n x_k = (P - iH_0) \sum_{k=1}^n (i+1)^{k-1}
$$

Cette expression se résoud à finalement à:

---

$$
X_n = (P - iH_0) \frac{(i+1)^n - 1}{i}
$$

---

Vérifions! Avec les mêmes hypothèses que précédemment, on devrait arriver, pour
\\(n=25\\), à \\(H_0 = 200000\\) puisqu'après 25 ans, on aura tout payé:

$$
(10244.43 - 0.02\cdot 200000) \frac{(0.02+1)^25 - 1}{0.02} = 200010.96
$$

L'écart de 11$ ici s'explique par les chiffres que j'ai arrondis pour l'écriture.
En gardant une plus grande précision sur le nombre de chiffres après la virgule,
on arriverait évidemment à \\(H_0 = 200000\\). Faites le test!

Maintenant qu'on a le montant de prêt hypothécaire payé, on aimerait aussi avoir
la somme d'intérêt payé!

[tripascal]: https://fr.wikipedia.org/wiki/Triangle_de_Pascal
[binewton]: https://fr.wikipedia.org/wiki/Formule_du_bin%C3%B4me_de_Newton

## Portion d'intérêt du paiement bancaire

Le plus gros est déjà fait!!! En effet, comme j'ai dit au départ,

$$
P = y_k + x_k,\quad \text{pour tout}\ k
$$

Ce faisant, comme on connait \\(P\\) et \\(x_k\\), on a donc aussi \\(y_k = P -
x_k\\). Notons la somme d'intérêt payée au bout de \\(k\\) années \\(Y_n\\). Il
s'en suit que:

$$
\begin{align}
Y_n = \sum_{k=1}^n y_k &= \sum_{k=1}^n \left(P - x_k\right)\\\\
                       &= \sum_{k=1}^n P - \sum_{k=1}^n x_k\\\\
                       &= nP - \sum_{k=1}^n x_k\\\\
\end{align}
$$

Finalement, comme on connaît l'expression de la somme sur \\(x_k\\), c.-à-d.
\\(X_n\\), on écrit:

---

$$
Y_n = nP - (P - iH_0) \frac{(i+1)^n - 1}{i}
$$

---

**Exemple**

Selon les hypothèses faites plus haut:

$$
\begin{cases}
H_0 &= 200000 \\\\
i &= 0.02 \\\\
P &= 10244.43
\end{cases}
$$

le lecteur est invité à calculer la somme d'intérêt payée après 5 ans,
c'est-à-dire calculer \\(Y_5\\).

## Conclusion

Ces calculs sont déterminants dans l'examen de l'avantage à acheter une
propriété. Cependant, ces chiffres ne sont pas suffisants puisqu'il faut aussi
considérer les frais qui s'ajoutent à l'habitation comme j'ai mentionné plus
haut dans l'article. Bien sûr d'autres facteurs jouent comme la mise de fond
initiale disponible, les frais ponctuels à l'achat (notaire, taxe de bienvenue,
etc.), le coût d'un courtier lors de la vente de la propriété ainsi que
l'augmentation potentielle moyenne de la valeur de la propriété. En effet, afin
de calculer l'avantage d'un achat, il est primordial de calculer les frais de
vente puisqu'une habitation constitue un actif considérable qui pèse dans la
balance. Certains scénarios peuvent présenter des profits de plusieurs milliers
de dollars lors d'une vente qu'après 5 ans de possession. Par ailleurs,
l'acquisition d'une propriété amène aussi la capacité de louer le lieu
d'habitation, ce qui offre en soi une dimension de flexibilité.

<!-- vim: set sts=2 ts=2 sw=2 tw=80 et :-->

