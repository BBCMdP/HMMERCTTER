function [FP, SeqAssig] = test_Application(FolderClustering,Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button,pt_horizontal)

% Iteration 1:
% Calculate hmmr_search with ApSeqFile against training profiles. 
% The new seq that are above the last belonging to the profile, include 
% them to the group. Complete the folder -> Appl / Groups

Folder_Group = [Folder_Application '/Groups'];
Folder_in_1 = [Folder_Application '/Hmmr-Build'];
FP=1;
SeqAssig = 'No';

if isempty(Index) 
 
    %%%%%%%%%%%%% Original Sequences %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Folder_OriginalGroup = [FolderClustering '/Training_Output/Groups'];
    %Dir_training = dir([Folder_OriginalGroup '/' Prefix '*.txt']);
    
    Groups_originales =  {};
    
    Dir = dir([Folder_Application '/Hmmr-Build/hmm_' Prefix '*.txt']);


   Num_Growing_Groups = zeros(length(Dir),1);
 while sum(Num_Growing_Groups) ~= length(Dir)  %Crecer en paralelo.
     
     for i=1:length(Dir)
         if Num_Growing_Groups(i) == 0
                %File_hmmrB_out = [Folder_Application '/Hmmr-Build/hmm_' Prefix num2str(i) '.txt'];
                %File_hmmrS_out = [Folder_Application '/Hmmr-Search/hmmS_all_' Prefix num2str(i) '.txt'];
                %fn_run_hmmrS(Folder_in_1,ApSeqFile,File_hmmrB_out,File_hmmrS_out);

                myFileName=[Prefix num2str(i) '.txt'];

                File_1= [Folder_Application '/Hmmr-Search/hmmS_all_' myFileName];
                [Score_1,List_1]=fn_graphic_score(File_1);

                File_2= [Folder_Application '/Hmmr-Search/hmmS_' myFileName];
                [Score_2,List_2]=fn_graphic_score(File_2);

                [List_new]=fn_masFP(List_2,List_1,Score_2,Score_1);
 
                [SeqAssig, Seq_duplicate] = fn_verification_SeqAssignment(Folder_Group, List_new,i);
                
                % Now it is not an exit criterion that there are sequences assigned to other 
                % groups, because those sequences are not going to be considered.
               
                if isequal(SeqAssig,'Yes')  
                    FP = 0;   
                    
                    %%% Conflicting sequences are marked in the
                    %%% Problematic_Seq.txt file
                    
                    File = ([Folder_Group '/Problematic_Seq.txt']);
                    File_dup = fopen(File,'a+');     
                    
                    Aux = lib_loadtext(File);
                    Filter = ones(length(List_new),1);
                    
                    myFileName_org =[Folder_OriginalGroup '/' Prefix num2str(i) '.txt'];
                    Groups_originales=lib_loadtext(myFileName_org);           
                    
                    % Filter
                    for j=1:length(List_new)
                        index = (find(strcmp(List_2, List_new{j})));
                          if ~isempty(index)
                              %If it is not the originals of the current group, check if it is marked as duplicate.
                              if isempty((find(strcmp(Groups_originales, List_2{index(1)})))) 
                                %If it is marked as duplicate seq
                                if ~isempty(find(strcmp(Aux, List_new{j})))
                                    Filter(j)=0;
                                end
                              end
                              % If it is new in this iteration, 
                              %this iteration is not considered, 
	                      %it is also eliminated from the group, and it is recorded as a problematic sequence.
                            elseif isempty(find(strcmp(List_2, List_new{j}))) 
                                    fprintf(File_dup, [List_new{j} '\n']);
                                    Filter(j) = 0;
                           end
                    end
                    List_new = List_new(Filter==1); % Do not add sequences, conflicting sequences are not considered;
                    
                    File_group=([Folder_Application '/Groups/' Prefix num2str(i) '.txt']);
                    File_group=fopen(File_group,'w+');
                    for j=1:length(List_new)
                             fprintf(File_group, [List_new{j} '\n']);
                    end
                    fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,i,[]);
                else
             
                    File_group=([Folder_Application '/Groups/' Prefix num2str(i) '.txt']);
                    File_group=fopen(File_group,'w+');
                    for j=1:length(List_new)
                        % Save it if it is not duplicated in more than one group.
                        %if  isempty(find(strcmp(Seq_duplicate, List_new{j})))
                             fprintf(File_group, [List_new{j} '\n']);
                        %end
                    end
  
                    fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,i,[]);
    
    %%%%%%%%%%%%%%%%% Verification False Positive %%%%%%%%%%%%%%%%%%%%%%%%%
                    [Score_1,Derivada_1,Index_2,Score_2,List_1,List_2]=fn_graphic_index(Folder_Application,Prefix,i);
                    [FP]=fn_verificationFP(List_2,List_1,Score_2,Score_1);                
                end   
            
            if FP==0
                Num_Growing_Groups(i) = 1;
                File_temp=([Folder_Application '/Groups/Temp_' Prefix num2str(i) '.txt']);
                File_temp=fopen(File_temp,'a');  
                for j=1:length(List_new)
                     fprintf(File_temp, [List_new{j} '\t']);
                end
                fprintf(File_temp,'\n');      
            end
            FP = 0;
         end
     end
  end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
elseif isequal(Button,'Original') || isequal(Button, 'FPositive') % For Original or For include FP.
            while FP == 1
                myFileName=[Prefix num2str(Index) '.txt'];

                File_1= [Folder_Application '/Hmmr-Search/hmmS_all_' myFileName];
                [Score_1,List_1]=fn_graphic_score(File_1);

                File_2= [Folder_Application '/Hmmr-Search/hmmS_' myFileName];
                [Score_2,List_2]=fn_graphic_score(File_2);

                [List_new]=fn_masFP(List_2,List_1,Score_2,Score_1);
                
                [SeqAssig] = fn_verification_SeqAssignment(Folder_Group, List_new,Index);
                
                if isequal(SeqAssig,'Yes')   
                    break,
                else
                    File_group=([Folder_Application '/Groups/' Prefix num2str(Index) '.txt']);

                    File_group=fopen(File_group,'w+');
                        for j=1:length(List_new)
                            fprintf(File_group, [List_new{j} '\n']);
                        end
        
                    fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,Index,[]);

                   %%%%%%%%%%%%%%%%% Verification False Positive %%%%%%%%%%%%%%%%%%%%%%%%%
                [Score_1,Derivada_1,Index_2,Score_2,List_1,List_2]=fn_graphic_index(Folder_Application,Prefix,Index);
                [FP]=fn_verificationFP(List_2,List_1,Score_2,Score_1);
                end
            end       
            FP=0;
        File_temp=([Folder_Application '/Groups/Temp_' Prefix num2str(Index) '.txt']);
        File_temp=fopen(File_temp,'a+');  
        for j=1:length(List_new)
             fprintf(File_temp, [List_new{j} '\t']);

         end
        fprintf(File_temp,'\n');       

elseif  ~isequal(Button,'Previous')
    myFileName=[Prefix num2str(Index) '.txt'];

    File_1= [Folder_Application '/Hmmr-Search/hmmS_all_' myFileName];
    [Score_1,List_1,Derivada_1]=fn_graphic_score(File_1);
 
    File_2= [Folder_Application '/Hmmr-Search/hmmS_' myFileName];
    [Score_2,List_2]=fn_graphic_score(File_2);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if isequal(Button,'masUNO')
        [List_new]=fn_masUNO(List_2,List_1,Score_2,Score_1);
    end
    if isequal(Button,'masDIEZ')
        [List_new]=fn_masDIEZ(List_2,List_1,Score_2,Score_1);
    end
    if isequal(Button,'higherDER')
        [List_new]=fn_higherDER(List_2,List_1,Score_2,Score_1);
    end
    if isequal(Button,'manualSELECTION')
        [List_new]=fn_manualSelection(List_2,List_1,Score_2,Score_1,pt_horizontal);
    end
    
    [SeqAssig] = fn_verification_SeqAssignment(Folder_Group, List_new,Index);
    if isequal(SeqAssig,'Yes')  
       return,
    else
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    File_temp=([Folder_Application '/Groups/Temp_' Prefix num2str(Index) '.txt']);
    File_group=([Folder_Application '/Groups/' Prefix num2str(Index) '.txt']);

    File_group=fopen(File_group,'w');
        for j=1:length(List_new)
                fprintf(File_group, [List_new{j} '\n']);
        end
        
     fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,Index,[]);
     
    %%%%%%%%%%%%%%%%% Verification False Positive %%%%%%%%%%%%%%%%%%%%%%%%%
    [Score_1,Derivada_1,Index_2,Score_2,List_1,List_2]=fn_graphic_index(Folder_Application,Prefix,Index);
    [FP]=fn_verificationFP(List_2,List_1,Score_2,Score_1);
    
    % If there is NO FP in the new group I write it in temporary.
    if FP == 0
    File_temp=fopen(File_temp,'a+');
        for j=1:length(List_new)
                fprintf(File_temp, [List_new{j} '\t']);
        end
         fprintf(File_temp, '\n');
    end
    
    end
else %  if isequal(Button,'Previous')
    FP=0;
    File_temp=([Folder_Application '/Groups/Temp_' Prefix num2str(Index) '.txt']);
    File_group=([Folder_Application '/Groups/' Prefix num2str(Index) '.txt']);

    fn_Previous(File_temp,File_group);
    
    fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,Index,[]);
      
end

fclose ('all');



