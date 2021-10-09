clear all
close all

T = readtable('WikiMainPage.csv');
nbLines = 20;

website = table2array(T(1:nbLines,2))
links = T(1:nbLines,5);

a = table2array(links);
expression = '\/wiki/\w*';
matchStr = regexp(a,expression,'match');

char(matchStr{1,1}) %get la liste des liens du premier site

m = char(matchStr{1,1})
m(m == '/wiki/Bill_of_Rights_1689')


for i=1:nbLines

end