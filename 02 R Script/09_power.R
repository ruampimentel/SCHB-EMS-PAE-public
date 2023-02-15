library(pwr)

pwr.r.test(n=70,
           power=0.80,
           sig.level=0.05,
           alternative="two.sided")

pwr.r.test(n=70, power=0.80)
pwr.r.test(n=140, power=0.80)

pwr.t2n.test(n1 = 41, n2 = 29, power = 0.8)

pwr.t2n.test(n1 = 70, n2 = 70, power = 0.80)
round( 0.4768651, 2)


t test power calculation 

n1 = 70
n2 = 70
d = 0.4768651
sig.level = 0.05
power = 0.8
alternative = two.sided