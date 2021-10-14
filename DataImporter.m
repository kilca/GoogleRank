function [mat,v] = DataImporter(lien)

fname = lien; 
fid = fopen(fname); 
raw = fread(fid,inf); 
str = char(raw'); 
fclose(fid); 
val = jsondecode(str);

%val = val(randperm(length(val)));

taille = size(val,1);
m=zeros(taille,taille);

mapLinkToInd = containers.Map;

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
        char(mesLinks(l))
        colonneInd = mapLinkToInd(char(mesLinks(l)))
        m(colonneInd,i) = proba;
    end
end
        
mat =m;
v = val;
end

