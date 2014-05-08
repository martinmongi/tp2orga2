%Tiles
'Corro tiles'
A = [3555837 3647772 3688119 2543661 3450150;
12865995 12673161 11248425 9350595 12444435;
56645631 58814946 39843630 38841345 40467168;
169241112 211321710 155923974 145265004 164419947]

%A = fliplr(A)


bar(A)

%legend('C -O3', 'C -O2', 'C -O1', 'C -O0', 'Assembler', 'Location','NorthWest')
legend('Assembler', 'C -O0', 'C -O1', 'C -O2', 'C-O3', 'Location','NorthWest')