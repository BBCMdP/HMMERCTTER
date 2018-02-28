function [Score_all,Derivada_all,Index_group,Score_group,List_all,List_group]=fn_graphic_index(Output_Folder,Prefix,Index)

myFileName=[Prefix num2str(Index) '.txt'];

File_1= [Output_Folder '/Hmmr-Search/hmmS_all_' myFileName];
[Score_all,List_all,Derivada_all]=fn_graphic_score(File_1);
 
File_2= [Output_Folder '/Hmmr-Search/hmmS_' myFileName];
[Score_group,List_group]=fn_graphic_score(File_2);

%%% Verify duplicates in multiple groups.
%%% If it is, these sequences are not plotted.


File = ([Output_Folder '/Groups/Problematic_Seq.txt']);
if exist(File,'file')
    All = ones(1,length(List_all));
    %Group = ones (1,length(List_group));
    
    %File_dup = fopen(File,'r');
    Aux = lib_loadtext(File);
    
    for i = 1: length(Aux)
       if isempty(find(strcmp(List_group, Aux{i})))
            if find(strcmp(List_all, Aux{i})) 
                idx = find(strcmp(List_all, Aux{i}));
                All(idx) = 0;
            end
%         if find(strcmp(List_group, Aux{i}))
%             idx = find(strcmp(List_group, Aux{i}));
%             Group(idx) = 0;
%         end
       end
    end
    Score_all = Score_all(find(All));
    List_all = List_all(find(All));
    Derivada_all = Derivada_all(find(All(2:end)));
    
%     Score_group = Score_group(find(Group));
%     List_group = List_group(find(Group));
end

Index_group=fn_index(List_group,List_all,Score_group,Score_all);
