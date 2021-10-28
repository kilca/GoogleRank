function [mat,v] = DataImporter(lien)

%============= On lit le fichier
fname = lien; 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 

val = jsondecode(str);


taille = size(val,1);
m=zeros(taille,taille);

%on cree une map pour optimiser l'acces
mapLinkToInd = containers.Map;

%on prepare les personnages
characters = blanks(taille);

size(characters);

%on cree une map permettant de recuperer l'indice de la valeur a partir de
%l'url
for i=1:taille
    mapLinkToInd(val(i).character_url) = i;
end

%On remplie les valeur de la matrice
for i=1:taille
    mesLinks = val(i).links;
    for l=1:size(mesLinks)
        proba = 1.0/size(mesLinks,1);
        colonneInd = mapLinkToInd(char(mesLinks(l)));
        m(colonneInd,i) = proba;
    end
end

%on retourne les valeurs
mat =m;
v = val;
end

