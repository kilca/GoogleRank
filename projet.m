clear all
close all

%Matrice pas bonne car contient que des 0 et donc les pop disparaissent 
L = [0 0.5 0 0 0;
    0 0 0 0 0;
    1 0.5 0 0 0;
    0 0 0 0 1;
    0 0 0 1 0]


%parametres
alpha = 0.85

[l,c] = size(L);
mat1 = ones(l);
prob = 1/c;
N = c
%-------------

v = ones(c,1)*prob

S = L

%on remplace les colonnes contenant que des 0 par prob de 1/nbC
for i=1:l
    if (sum(S(:,i)) == 0)
        S(:,i) = v;
    end
end

%on calcule M la matrice google qui permet de repartir sur les pages les
%plus populaires

M=alpha*S+(1-alpha)*(mat1/N)

%graphes

nmax = 24%nb total de pas deplacement de site en site
N = zeros(l,nmax);
N(1,1)= 0.8;
N(5,1)= 0.2;

for n =2 : nmax
    N(:,n)=(M^n)*N(:,1)
end



plot(transpose(N))
legend('Site1','Site2 ','Site3','Site4','Site5')
 


s = [1 2 2 4 5];
t = [3 1 3 5 4];
weights = [1 0.5 0.5 1 1];

G = digraph(s,t,weights)
figure;
plot(G,'EdgeLabel',G.Edges.Weight)








