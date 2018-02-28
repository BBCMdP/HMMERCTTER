function fn_run_program(Output_Folder,Prefix,FileSeq,Aligment_Program,Index,TreeFile) 
% test_run_program - 
%
%   test_run_program(Output_Folder,Prefix,FileSeq,Realignment)
%
%Input:
%       Output_Folder - Path to files.
%       Prefix - 
%       FileSeq - String. Path and Name of file with sequences.
%       Realignment - String. Indicates realignment.
%                   'True' - Tcoffee realignment (DEFAULT)
%                   'False'
%
%
% TEST_RUN_PROGRAM - run fn_run_perl,fn_run_tcoffee (Realignment=True),
% fn_run_hmmrB, fn_run_hmmrS.


%fn_genera_perl(Output_Folder,FileSeq,Prefix);

Folder_in_0= [Output_Folder '/Groups'];

Folder_Out_0= [Output_Folder '/Fetching'];
if ~exist(Folder_Out_0,'dir')
   mkdir(Folder_Out_0);
end


if strcmp(Aligment_Program,'Mafft')
Folder_Out_1=[Output_Folder '/MSA_M'];
elseif strcmp(Aligment_Program,'T-coffee')
    Folder_Out_1=[Output_Folder '/MSA_T'];
end

if ~exist(Folder_Out_1,'dir')
   mkdir(Folder_Out_1);
end

Folder_Out_2=[Output_Folder '/Hmmr-Build'];
if ~exist(Folder_Out_2,'dir') 
    mkdir(Folder_Out_2);
end

Folder_Out_3=[Output_Folder '/Hmmr-Search'];
if ~exist(Folder_Out_3,'dir') 
    mkdir(Folder_Out_3);
end

if ~isempty(TreeFile)
Folder_Out_4=[Output_Folder '/Dendroscope'];
if ~exist(Folder_Out_4,'dir') 
    mkdir(Folder_Out_4);
end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
         myFileName = [Prefix num2str(Index) '.txt'];                      %Group_1.txt     
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% PERL - fetching %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
         FileGroup = [Folder_in_0 '/' myFileName];
         FileFetching = ['fetching_' myFileName];                         %fetching_Group_1.txt 
         
         Text = fn_subtext_cFetching(FileGroup,FileSeq,myFileName);
         Text = Text(:);
         
         File_Script = ['fetching_' strrep(myFileName,'.txt','.pl')];      %fetching_Group_1.pl
         
         lib_savetext([Folder_Out_0 '/' File_Script],Text);
         

         fn_run_perl(File_Script,Folder_Out_0);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%% Realignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %t_coffee fetching_Group_1.txt -outfile='tt'
             
          File_MSA_out=[Folder_Out_1 '/' strrep(FileFetching,'fetching',Aligment_Program)]; %'Alignment_program'_Group_1.txt
             
             if strcmp(Aligment_Program,'T-coffee')
             fn_run_tcoffee(Folder_Out_0,FileFetching,File_MSA_out);
             elseif strcmp(Aligment_Program,'Mafft')
                 fn_run_mafft(Folder_Out_0,FileFetching,File_MSA_out)
             end

             File_hmmr_in=File_MSA_out;                                    %'Alignment_program'_Group_1.txt 
         
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% HmmBuild - Profiles %%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %    hmmbuild --informat afa hola fetching_Group_1.txt
          
          File_hmmrB_out =[Folder_Out_2 '/hmm_' myFileName];                %hmm_Group_1.txt 
          
          fn_run_hmmrB(Output_Folder,File_hmmr_in,File_hmmrB_out);
          
        
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% HmmSearch - all sequences %%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %   hmmsearch hmmbuild_Group_2.txt secuencias_ultrachico.txt > G2H.out
          
          File_hmmrS_out=[Folder_Out_3 '/hmmS_all_' myFileName];        %hmmS_all_Group_1.txt 
          
          fn_run_hmmrS(Output_Folder,FileSeq,File_hmmrB_out,File_hmmrS_out);

 
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% HmmSearch - Group's sequences %%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          

         File_hmmrS_In=[Folder_Out_0 '/' FileFetching];                      %Group_1.txt 

         File_hmmrS_out_grupo=[Folder_Out_3 '/hmmS_' myFileName];           %hmmS_Group_1.txt 
        
         fn_run_hmmrS(Output_Folder,File_hmmrS_In,File_hmmrB_out,File_hmmrS_out_grupo);
         
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% Dendroscope Analysis sequences %%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
         if ~isempty(TreeFile)
         fn_dendroscope_group(Folder_in_0,Folder_Out_4,TreeFile,Prefix,Index);
         end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%