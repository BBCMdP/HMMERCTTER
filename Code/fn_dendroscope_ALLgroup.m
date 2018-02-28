function fn_dendroscope_ALLgroup(Folder_in,Folder_Out,File_tree,Prefix)

if ~exist(Folder_Out,'dir') 
    mkdir(Folder_Out);
end


Colour_pref= [255	0	0; 0	0	255; 0	255	0; 255	0	255; 0	255	255; ...
192	192	192; 128	128	128; 128	0	0; 128	128	0; 0	128	0; 128	0	128; 0	128	128; 255	69	0; 255	215	0; 255	128	114; 75	0	130; 139	69	18; 255	20	147; 25	25	112];


File_Script='ArbolDendroscope_Final';
%File_Grafico=[Folder_Out '/Dendroscope_Final.pdf'];
%File_Grafico_PNG=[Folder_Out '/Dendroscope_Final.png'];
File_Grafico=[Folder_Out '/Dendroscope_Final'];
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Text = {};
Posi = 0;
Posi = Posi + 1; Text{Posi} = '#!/bin/csh';
Posi = Posi + 1; Text{Posi} = 'Dendroscope -g -E <<END';
Posi = Posi + 1; Text{Posi} = ['open file=''' File_tree ''''];
%Posi = Posi + 1; Text{Posi} = 'midpointroot';
Posi = Posi + 1; Text{Posi} = 'show nodelabels=false';
Posi = Posi + 1; Text{Posi} = 'show edgelabels=false';
Posi = Posi + 1; Text{Posi} = 'show edgeweights=false';


%%%%%%%%%%%%%%%%%%%%%%%%%% File Group %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir = dir([Folder_in '/' Prefix '*.txt']);
for Index=1:length(Dir)
    myFileName = [Prefix num2str(Index) '.txt'];
    File = [Folder_in '/' myFileName];
    if exist(File)==2 
       List= lib_loadtext(File);

        for i=1:length(List)
           Posi = Posi + 1; Text{Posi} = ['find searchtext=' List{i} ' target=Nodes'];
        end
       Posi = Posi + 1; Text{Posi} = 'select induced network';
       %%%%%%%%%%%%% Define colour of each group %%%%%%%%%%%%%%%%%%%%%%%%%%
       if Index <= size(Colour_pref,1)
           Color = Colour_pref(Index,:);
       else
           a=1;
           b=256;
           Color = [round((a + (b-36)-a).*rand(1,1)) round(a + (b-a).*rand(1,2))];
       end
       
       Posi = Posi + 1;Text{Posi} = ['set color=' num2str(Color)];
       Posi = Posi + 1;Text{Posi} = 'deselect all';     
    end
end
       Posi = Posi + 1;Text{Posi} = 'select all';
       Posi = Posi + 1;Text{Posi} = 'set drawer=RadialPhylogram';
       Posi = Posi + 1; Text{Posi} = 'show scalebar=false';
       Posi = Posi + 1;Text{Posi} = 'deselect all';
       
       %Posi = Posi + 1;Text{Posi} =  ['exportimage file=''' File_Grafico '''' 'format=PDF REPLACE=true'];
       %Posi = Posi + 1;Text{Posi} =  ['exportimage file=''' File_Grafico_PNG '''' 'format=PNG REPLACE=true'];
       Posi = Posi + 1;Text{Posi} =  ['exportimage file=''' [File_Grafico '.png'] '''' 'format=PNG REPLACE=true'];
       Posi = Posi + 1;Text{Posi} =  ['exportimage file=''' [File_Grafico '.svg'] '''' 'format=SVG REPLACE=true']; 
       Posi = Posi + 1; Text{Posi} = ['save format=nexml file=''' [File_Grafico '.nexml'] ''''];
       
       Posi = Posi + 1;Text{Posi} = 'quit';
       Posi = Posi + 1;Text{Posi} = 'END';
 
   lib_savetext([Folder_Out '/' File_Script],Text);
    
   fn_run_tcsh(Folder_Out,File_Script);

%#!/bin/csh
% dendroscope +g <<END
% open file='/home/inti/dendroscope/examples/trees.new'
% select taxa=AE007869
% set labelcolor=225 180 0
% deselect nodes
% exportgraphics format=PDF file='csh_dend_1.pdf'
% quit
% END
