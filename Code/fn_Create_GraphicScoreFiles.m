function fn_Create_GraphicScoreFiles(Folder_Tr,Prefix)
%%%%%%%%% Gráfico del score - HmmerSearch Output %%%%%%%%
 
Folder_in= [Folder_Tr '/Hmmr-Search/'];
Folder_out =[Folder_Tr '/Score_Graphics/'];
 
 if ~exist(Folder_out)
 mkdir(Folder_out);
 end
 
File_out ='Score_hmmSearch_Group_';
File_in_1='hmmS_all_Group_'; 
Dir_1 = dir([Folder_in '/' File_in_1 '*.txt']);

Index=1;
if isempty(Dir_1)
   disp(['There are no files "' File_in_1 '*.txt" in the folder ' Folder_in ' - test_grafico_score script will not be run!!'])
else    
   for Aux =1:length(Dir_1)
      
      while ~exist([Folder_in File_in_1 num2str(Index) '.txt'],'file')
          Index= Index + 1;
      end
      
    [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Tr,Prefix,Index);
     
    Index_group=sort(Index_group);
    
    h=figure('visible','off');
    plot(Score_all,'*');
    hold on
    plot(Derivada_all,'r');
    hold on
    plot(Index_group,Score_group,'go');
    xPos = max(Index_group);
    yPos = min(Score_group);
    hold on
    plot(get(gca,'xlim'), [yPos yPos],'m'); % Adapts to x limits of current axes
    hold on
    plot([xPos xPos],get(gca,'ylim'),'m'); % 

    hold off
    titulo = title(['Score Group']);

    leyenda1 = 'Score';
    leyenda2 = 'Derivative';
    leyenda3= ['Score group ' num2str(Index)];
    leyenda = legend(leyenda1,leyenda2,leyenda3);

    set(titulo,'FontSize',16);
    set(leyenda,'FontName','arial','FontUnits','points','FontSize',16,...
              'FontWeight','normal','FontAngle','normal');
    

    print(h,'-djpeg',[Folder_out File_out num2str(Index) '.jpg']);
    print(h,'-depsc',[Folder_out File_out num2str(Index) '.eps']);
    Index = Index + 1;
  end
end
