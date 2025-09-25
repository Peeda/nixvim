= Lecture 3: Deviation Bounds, Intro to Learning Theory
== Learning Theory Definitions
$D$ is a distribution over $X times Y$, where $X$ is our input space and $Y$ is our output space, in the case of binary classification we take $Y={-1,1}$. For now we define $H$ as a set of hypotheses, where each $h in H$ is a function mapping $X$ to $Y$.

We define $L(h) = Pr_((x,y) ~ D)[h(x_i) != y_i]$ and $hat(L) (h) = Pr_((x,y) in S) [h(x_i) != y_1] = 1/n sum_(i=1)^n II[h(x_i) != y_i]$

Note that $ E_S [hat(L) (h)] = E_S [1/n sum_(i=1)^n II[h(x_i) != y_i]] = 1/n sum_(i=1)^n E_S [II[h(x_i) != y_i]] $

$ = Pr[h(x_i) != y_i] $
As each of the samples in $S$ are sampled from $D$. Therefore the loss over the whole distribution is an unbiased estimator for the loss over some choice of $S$.

In learning theory our goal is to find a good choice of $h$ to minimize loss. We can express this as minimizing $L(h) - L_"Bayes" (h)$, that is we want to minimize the extra loss our choice of $h$ gives. Let $hat(h)$ be our choice, let $h^star$ be the minimizer of $L$ in $H$, we can split this difference as
$ L(hat(h)) - L(h_"Bayes") = [L(hat(h)) - L(h^*)] + [L(h^*) - L(h_"Bayes")]  $
The first term is estimation error, the second is approximation error. As our model class gets more complex the first term grows and the second shrinks, as our models increasingly overfit but are more expressive.
== Generalization Bound in Realizable Case
Suppose that we have some perfect model in $H$, so that $L(h^star) = 0$. Letting $hat(h)$ be the minimizer of $hat(L)$, we claim that with probability $1-delta$, $ L(hat(h)) <= frac(ln(abs(H)) + ln(1/delta),n) $
Note that $hat(h)$ must have zero loss over our training set, as there exists some $h$ that gets zero loss over the whole distribution. The event we wish to upper bound is that such a choice gets error at least epsilon, so
$ Pr[L(hat(h)) > epsilon] <= Pr[exists h in H: L(h) > epsilon, hat(L)(h) = 0] $
This is the event that we have at least an $epsilon$ probability of getting an error, and yet in each of $n$ draws we avoided that.
$ <= abs(H)(1-epsilon)^n <= abs(H)(e^(-epsilon n)) <= delta $
And therefore we can take $epsilon = frac(ln(abs(H)) + ln(1/delta),n)$ to get our claim.
= Lecture 4: Learning Theory and VC-Dimension
== VC Dimension Definitions and Examples
We define the restricted hypothesis class $Pi_H|_S$ as the set of "hypotheses" restricted to acting on the $n$ points in $S$ (note that we're conflating some $h in H$, a function, with the vector that gives its outputs on the points in $S$. Therefore we consider two $h in H$ to be the same in our restricted class if they have the same outputs on $S$. Furthermore the space of possible functions is now finite, being bounded by $2^n$ whereas before it was infinite.

Growth function $Pi_H (n)$ is defined as the biggest that the restricted hypothesis class can be, in other words $Pi_H (n) := max_(S subset X, abs(S) = n) abs(Pi_H|_S)$.

VC Dimension is the biggest $n$ such that the growth function is maximized at $2^n$, in other words the size of the biggest set of inputs that we can shatter. So if you want to lower bound it you can pick any set of size $n$ and show that you can label arbitrarily. To say that it's less than some $n$ you need to show that for any set of $n$ points there exists some label that you can't do.
== Crazy Example from Test 1
Let's consider $X = {1,2,...,8}$ and let $H = 2^X$ (but $-1,1$ not $0,1$). So $H$ contains all of the possible functions from $X$ to ${-1,1}$ and so the growth function of $H$ is always $2^n$, and the VC dimension is $8$. Consider partitioning $H$ into the hypotheses with at most $3$ "yes" outputs and the hypothesis with at least $4$ "yes" outputs. This first partition can't shatter four points as for any four of these numbers we can simply pick the labeling that's always "yes", and therefore has VC dimension less than than four. The second partition can't shatter  a set of five as we can adversarially chose the labeling of five "no"s. You can verify the lower bounds match and so the respective VC dimensions are three and four, so $d = d_1 + d_2 + 1$!

TODO: I'm not sure this is what they were going for to be honest I forgot the question I think this is a bound matching a result from the test and the question was to prove $d < d_1 + d_2 + 2$. Pretty sure this analysis up here is correct though. This shows that we can achieve having the union be the sum of the individual dimensions plus one, while the result from the exam shows it can't be as big as the sum plus two.
= Lecture 5: Generalization Bounds via VC-Dimension
== Lemmas
=== Excess Risk in terms of Generalization:
We will use triangle inequality basically
$ L(hat(h)) - L(h^star) = [L(hat(h))-hat(L) (hat(h))] + [hat(L) (hat(h)) - hat(L)(h^star)] + [hat(L)(h^star) - L(h^star)] $
We're bringing in all these extra terms because we know that $hat(h)$ is the minimizer under $hat(L)$ and so we can make the second difference go away because it's at most zero, turning a difference under $L$ between $hat(h)$ and $h^star$ into two differences between $L$ and $hat(L)$
$ <= [L(hat(h))-hat(L) (hat(h))] + [hat(L)(h^star) - L(h^star)] $
$ <= abs(L(hat(h))-hat(L) (hat(h))) + abs(hat(L)(h^star) - L(h^star)) <= 2 max_(h in H) abs(hat(L) (h) - L(h)) $
=== Sauer-Shelah Lemma and Corollary
$ Pi_H (n) <= sum_(k=0)^d binom(n,k) $
$ Pi_H (n) <= (frac(n e, d))^d $
No proof. This is useful only because we need to bound the growth function, if we had a better way we wouldn't need this whole VC dimension stuff. When $n<=d$ the growth function is exactly characterized by definition so this really only shows that for $n>d$ we can give a sort of exponential growth but not quite $2^n$.
=== Symmetrization
#let normalhat = $hat(L)_S (h)$
#let primehat = $hat(L)_(S') (h)$
We claim that if $n epsilon^2 > 4$, so $epsilon > sqrt(2/n)$ we have
$ Pr_S [max_h abs(hat(L)_S (h) - L(h)) > epsilon] <= 2 Pr_(S,S') [max_h abs(normalhat - primehat) > epsilon/2] $

We will start with the RHS and successively lower bound, let $overline(h)$ be the maximizer of the generalization gap, that is that $overline(h) = max_h abs(hat(L) (h) - L(h))$.
$ Pr_(S, S') [max_h abs(normalhat - primehat) > epsilon/2] $
=== Union Bound and Hoeffding
We claim that 
$ Pr_(S,S') [max_h abs(normalhat - primehat) > epsilon] <= 2 Pi_h (2n ) e ^(- 2n (epsilon/2)^2) $
== Putting it all together
= Lecture 6: Intro to Rademacher Complexity
