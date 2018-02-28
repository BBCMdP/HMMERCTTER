function [SeqAssig, Seq_duplicated] = fn_verification_SeqAssignment(Folder_Group, List_new,Index)
% %%%%%%%%%%%%%%%% Update List_accept %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SeqAssig = 'No'; % Does not have sequences already assigned in the groups defined in training

List_accept=[];
Prefix = 'Group_';
Dir_training = dir([Folder_Group '/' Prefix '*.txt']);

Seq_duplicated={};

Num_Grupos_aceptados=length(Dir_training);
for i=1:Num_Grupos_aceptados
    if isempty(Index)
      myFileName=[Folder_Group '/' Prefix num2str(i) '.txt'];
      Aux=lib_loadtext(myFileName);           
      List_accept=[List_accept; Aux];
    elseif Index ~= i
      myFileName=[Folder_Group '/' Prefix num2str(i) '.txt'];
      Aux=lib_loadtext(myFileName);           
      List_accept=[List_accept; Aux];
    end
end


% Identify all sequences assigned to 2 or more groups.
 
for j = 1 :  length(List_new)
    if find(strcmp(List_accept,List_new{j})) 
        Seq_duplicated = [Seq_duplicated; List_new{j}]; 
    end
end


File = ([Folder_Group '/Problematic_Seq.txt']);

Seq_duplicated = unique(Seq_duplicated);

if ~isempty(Seq_duplicated)
      SeqAssig = 'Yes';
      
     % File = ([Folder_Group '/SeqDuplicated.txt']);
      File_dup = fopen(File,'a+');     
      Aux = lib_loadtext(File);
      
      for j=1:length(Seq_duplicated)
      %Save duplicate sequences in more than one group.
        if isempty(find(strcmp(Aux, Seq_duplicated{j})))
          fprintf(File_dup, [Seq_duplicated{j} '\n']);
        end
      end
      Seq_duplicated = [Aux; Seq_duplicated];
      
elseif exist(File,'file')
      Aux = lib_loadtext(File);
      % If there are one or more current sequences of the group 
      % that have been identified as problematic, the criteria for 
      % stopping the group is indicated by doing SeqAssig = 'yes'
       for j=1:length(List_new)
          if ~isempty(find(strcmp(Aux, List_new{j})))
            SeqAssig = 'Yes';
            break,
          end
       end
      Seq_duplicated = Aux;
end

