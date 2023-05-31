syms b1
syms b2
syms kp
syms tp
(2-2*b2)*(1-b1+b2)
subs(ans, b2, exp(-tp))
subs(ans, b1, kp-exp(-tp)*kp-1-exp(-tp))
simplify(ans)