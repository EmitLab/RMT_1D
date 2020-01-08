function Fib( n ) %{ // n >= 0
F(1) = 0;
F(2) = 1;
for k = 3: n
F(k) = F(k-1) + F(k-2);

end
F
%}