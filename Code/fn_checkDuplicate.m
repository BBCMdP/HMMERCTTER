function fn_checkDuplicate(Folder_In,Prefix)

Folder_Group=[Folder_In '/Groups'];
Dir_Application = dir([Folder_Group '/' Prefix '*.txt']);
Num_Grupos_aceptados=length(Dir_Application);  

List_accept=[];
List_index=[];
Index_group = 1;
for i=1:Num_Grupos_aceptados
     while ~exist([Folder_Group '/' Prefix num2str(Index_group) '.txt'],'file')
          Index_group= Index_group + 1;
     end
    
      myFileName=[Folder_Group '/' Prefix num2str(Index_group) '.txt'];
      Aux=lib_loadtext(myFileName);           
      List_accept{i}=Aux;
      List_index(i)=Index_group;
      Index_group = Index_group + 1;
end

contador=1;
Index=[];
Seq_duplicate=[];
Seq_analyzed=[];
for j=1:Num_Grupos_aceptados
        Group = List_accept{j};
        for h=1: length(Group)
            if sum(find(strcmp(Group(h),Seq_analyzed))) == 0 %Seq  no analizada.
                for k=j+1:Num_Grupos_aceptados
                    if sum(find(strcmp(Group(h), List_accept{k}))) > 1
                        Index=[Index k];
                    end
                end
                if ~isempty(Index)
                Index_actual=List_index(j);
                Index_repeat=List_index(Index);    
                Seq_duplicate {contador} = [Group(h) num2str(Index_actual) num2str(Index_repeat)];
                contador=contador+1;
                end
                Index= [];
            end
        end    
        Seq_analyzed=[Seq_analyzed;Group];
end
                
FileName_Duplicate=strcat(Folder_Group,'/checkDuplicate.txt');
File_Duplicate = fopen (FileName_Duplicate,'a+');

if isempty(Seq_duplicate)
       fprintf(File_Duplicate, 'There are not duplicate sequences  between the groups');
else
[f1,c1]=size(Seq_duplicate);
    fprintf(File_Duplicate, ['Sequence' '\t' 'Groups' '\r\n']);
[f1,c1]=size(Seq_duplicate);
  for i=1:c1
      for j=1:length(Seq_duplicate{i})
        fprintf(File_Duplicate, Seq_duplicate{i}{j});
        fprintf(File_Duplicate, '\t');
      end
     fprintf(File_Duplicate,'\r\n');
  end
end

fclose all;

