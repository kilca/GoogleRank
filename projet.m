clear all
close all

%On import les donnes parses 
[L,val] = DataImporter('asterix_char2.json');
%  L = [0 0.5 0 0 0;
%      0 0 0 0 0;
%      1 0.5 0 0 0;
%      0 0 0 0 1;
%      0 0 0 1 0]


%=====parametres
alpha = 0.85;

[l,c] = size(L);
mat1 = ones(l);
prob = 1/c;
Nm = c %le N de M
%-------------

v = ones(c,1)*prob;

S = L;

%=====on remplace les colonnes contenant que des 0 par prob de 1/nbC
for i=1:l
    if (sum(S(:,i)) == 0)
        S(:,i) = v;
    end
end

%====on calcule M la matrice google qui permet de repartir sur les pages les
%====plus populaires

M=alpha*S+(1-alpha)*(mat1/Nm);

%===========Evolution des pages

nmax = 120;%nb total de pas deplacement de site en site
N = zeros(l,nmax);
%N(:,1)= 1/l%1*(100/l);%Chaque page commence avec un pourcentage equivalent
N(1:50,1)= 1/50;%Les 50 premiers ont 1/50 de pourcentage


for n =2 : nmax
    N(:,n)=(M^n)*N(:,1);
end


%================= On calcule les valeurs propres, équilibre et temps

a=2%pour determiner t sur 2
dt = 1;%l'intervale de chaque est pour chaque parcours

[V,D] = eig(M);%M = V*D*V-1
V2 = abs(diag(D));
ii = sort(V2);
sigma2 = ii([end-1])%on recupere la deuxieme plus grande valeur propre
T1s2 = (-log(a) * dt) / (log(sigma2)) % On calcule T de 1 sur 2

%===On Verifie le calcul

pi = N(:,80);

%On verifie que le pourcentage est correct
disp(['somme des pi (doit etre egale a 1):  ', num2str(sum(pi,1))])

ds= M * pi -  pi;

disp(['somme des M*pi-pi (doit etre proche de 0):  ', num2str(sum(abs(ds)))])

%============== Affichage de l'évolution des personnes sur les sites

characters = {val.character_name};

p = plot(transpose(N));
xlabel('Temps');
ylabel({'Proportion','d utilisateur par page'});
legend(characters(1:10));

for i=1:l
    C = cell(1, l);
    C(:) = {characters(i)};
    sadf = dataTipTextRow('ID =',C);
    p(i).DataTipTemplate.DataTipRows(end+1:end+1) = sadf;
end

%=================== Affichage des personnes les plus populaires à la fin
nbTop = l;
[bigvalues, bigidx] = sort(N(:,nmax), 'descend');


disp('ranking :');
for i=1:nbTop
    fprintf('%d) %s with %d ranking.\n',i,val(bigidx(i)).character_name,bigvalues(i));
end

%=============Affichage Bar Chart
topn = 20;

figure;
bar(bigvalues(1:topn));

xtl = {};

for i=1:topn
    xtl{end+1} = val(bigidx(i)).character_name;
end
set(gca, 'XTickLabel',xtl, 'XTick',1:numel(xtl));
ylabel({'Proportion','d utilisateur par page'});
xtickangle(90);


%============Affichage Cloud 
figure;
colors = rand(l,3);
wordcloud(characters,N(:,nmax),'Color',colors);
title("Characters page Word Cloud");


%============ Variation d'alpha
alphas = 0.05:0.1:1.0;
Ts = [];

for alp=alphas
    M=alp*S+(1-alp)*(mat1/Nm);
    [V,D] = eig(M);%M = V*D*V-1
    V2 = abs(diag(D));
    ii = sort(V2);
    sigma2 = ii([end-1]);%on recupere la deuxieme plus grande valeur propre
    T1s2 = (-log(a) * dt) / (log(sigma2)); % On calcule T de 1 sur 2
    Ts(end+1) = T1s2;
end
figure;
plot(alphas,Ts)
xlabel('alpha')
ylabel('t_{1/2}')

