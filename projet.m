clear all
close all

%Matrice pas bonne car contient que des 0 et donc les pop disparaissent 
[L,val] = DataImporter('asterix_char1.json')
% L = [0 0.5 0 0 0;
%     0 0 0 0 0;
%     1 0.5 0 0 0;
%     0 0 0 0 1;
%     0 0 0 1 0]


%parametres
alpha = 0.85

[l,c] = size(L);
mat1 = ones(l);
prob = 1/c;
N = c;
%-------------

v = ones(c,1)*prob;

S = L;

%on remplace les colonnes contenant que des 0 par prob de 1/nbC
for i=1:l
    if (sum(S(:,i)) == 0)
        S(:,i) = v;
    end
end

%on calcule M la matrice google qui permet de repartir sur les pages les
%plus populaires

M=alpha*S+(1-alpha)*(mat1/N);

%graphes

nmax = 24%nb total de pas deplacement de site en site
N = zeros(l,nmax);
N(1,1)= 0.1;
N(5,1)= 0.2;

for n =2 : nmax
    N(:,n)=(M^n)*N(:,1);
end

characters = {val.character_name};

p = plot(transpose(N));

legend(characters(1:10));
%legend('Site1','Site2 ','Site3','Site4','Site5')

%size(characters)
%c= ones(71,24)'

%row = dataTipTextRow('Site=',characters)

for i=1:l
    C = cell(1, l);
    C(:) = {characters(i)};
    sadf = dataTipTextRow('ID =',C);
    p(i).DataTipTemplate.DataTipRows(end+1:end+1) = sadf;
end

nbTop = 10;
[bigvalues, bigidx] = sort(N(:,nmax), 'descend');

disp('ranking :');
for i=1:nbTop
    fprintf('%d) %s with %d ranking.\n',i,val(bigidx(i)).character_name,bigvalues(i));
end


%p.DataTipTemplate.DataTipRows(end+1) = row;
%p.DataTipTemplate.DataTipRows = [p.DataTipTemplate.DataTipRows,row];



%s = [1 2 2 4 5];
%t = [3 1 3 5 4];
%weights = [1 0.5 0.5 1 1];

%G = digraph(s,t,weights)
%figure;
%plot(G,'EdgeLabel',G.Edges.Weight)
