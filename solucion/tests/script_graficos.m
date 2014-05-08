feature('DefaultCharacterSet', 'UTF8');


%%
%Tiles


A = [3555837 3647772 3688119 2543661 3450150;
12865995 12673161 11248425 9350595 12444435;
56645631 58814946 39843630 38841345 40467168;
169241112 211321710 155923974 145265004 164419947];

%A = fliplr(A)


bar(A);

%legend('C -O3', 'C -O2', 'C -O1', 'C -O0', 'Assembler', 'Location','NorthWest')
legend('Assembler', 'C -O0', 'C -O1', 'C -O2', 'C -O3', 'Location','NorthWest');

set(gca,'XTickLabel',{'256x256', '512x512', '1024x1024', '2048x2048',''});

xlabel('Imagen');
ylabel('Numero de ciclos insumidos')

%%
%Popart

A = [3469050 4378545;
    12460716 16552656;
    52008426 67472694;
    190222317 247536054];

bar(A);
legend('Assembler', 'C', 'Location', 'NorthWest');

xlabel('Imagen');
ylabel('Numero de ciclos insumidos');
set(gca,'XTickLabel',{'256x256', '512x512', '1024x1024', '2048x2048',''});

%%
%Temperature

A = [3754809 4953006;
    14448852 19421100;
    61734987 79921107;
    237769821 300172968];

bar(A);
legend('Assembler', 'C', 'Location', 'NorthWest');

xlabel('Imagen');
ylabel('Numero de ciclos insumidos');
set(gca,'XTickLabel',{'256x256', '512x512', '1024x1024', '2048x2048',''});

%%
%LDR

A = [10643499 37766610;
    42923097 153595989;
    176557266 619221420;
    701040978 2469236202];

bar(A);
legend('Assembler', 'C', 'Location', 'NorthWest');

xlabel('Imagen');
ylabel('Numero de ciclos insumidos');
set(gca,'XTickLabel',{'256x256', '512x512', '1024x1024', '2048x2048',''});

%%
%Popart C vs Popart C No Jumps

A = [3107511 3754809;
    12194442 12919113;
    45938772 44203320;
    158648121 141643071];

bar(A);
legend('C -O1 con saltos', 'C -O1 sin saltos', 'Location', 'NorthWest');

xlabel('Imagen');
ylabel('Numero de ciclos insumidos');
set(gca,'XTickLabel',{'256x256', '512x512', '1024x1024', '2048x2048',''});

%%
%Tiles memmory intensive
A = [2508705 3541257;
    9833058 12846618;
    36131364 43634394;
    139478877 182067372];

bar(A);
legend('ASM normal', 'ASM con doble acceso a memoria', 'Location', 'NorthWest');

xlabel('Imagen');
ylabel('Numero de ciclos insumidos');
set(gca,'XTickLabel',{'256x256', '512x512', '1024x1024', '2048x2048',''});







