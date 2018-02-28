function fn_run_program_index(Output_Folder,Prefix,FileSeq,Aligment_Program,TreeFile,Index) 
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
%RUN_PROGRAM - run fn_run_perl,fn_run_tcoffee (Realignment=True),
% fn_run_hmmrB, fn_run_hmmrS.

%%FileSeq->Completo el directorio!!!!!!!!!
%Output_Folder='/media/Intina/Doctorado/Proyectos/2010-Silhouette-Hernan/experimentos/2012-08-06-ConTCoffee/Resultados/arbolhernanshsp'
%Prefix='Group_';
%FileSeq_noGap='SupplData1-SecCompletas'
%Realignment='True';


Folder_in_1= [Output_Folder '/Fetching'];
Folder_in_2= [Output_Folder '/Grupo_S'];

if strcmp(Aligment_Program,'Mafft')
Folder_Out_1=[Output_Folder '/MSA_M'];
elseif strcmp(Aligment_Program,'T-coffee')
    Folder_Out_1=[Output_Folder '/MSA_T'];
end

Folder_Out_2=[Output_Folder '/Hmmr-Build'];
if ~exist(Folder_Out_2) 
    mkdir(Folder_Out_2);
end

Folder_Out_3=[Output_Folder '/Hmmr-Search'];
if ~exist(Folder_Out_3) 
    mkdir(Folder_Out_3);
end


Prefix_fetch=['fetching_' Prefix]; 

myFileName=[Prefix_fetch num2str(Index) '.pl']
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% PERL - fetching %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         
         File_Script = [strrep(myFileName,'.txt','.pl')];   
                  

         fn_run_perl(File_Script,Folder_in_1)
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%% Realignment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %t_coffee fetching_Group_1.txt -outfile='tt'
             File_Script = [strrep(myFileName,'.pl','.txt')];
             File_Fetching = [File_Script];% ' -multi_core no'];
             File_MSA_out=[Folder_Out_1 '/' strrep(File_Script,'fetching',Aligment_Program)];
             
             if strcmp(Aligment_Program,'T-coffee')
             fn_run_tcoffee(Folder_in_1,File_Fetching,File_MSA_out);
             elseif strcmp(Aligment_Program,'Mafft')
                 fn_run_mafft(Folder_in_1,File_Fetching,File_MSA_out);
             end

             File_hmmr_in=File_MSA_out;
         
                  
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% HmmBuild - Profiles %%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %    hmmbuild --informat afa hola fetching_Group_1.txt
          
          Command1=['cd ' Output_Folder];
          
          myFileName_out=strrep(myFileName,'fetching','');
          myFileName_out=strrep(myFileName_out,'.pl','.txt');          
          File_hmmrB_out =[Folder_Out_2 '/hmm' myFileName_out];
          
          fn_run_hmmrB(Output_Folder,File_hmmr_in,File_hmmrB_out);
          
        
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% HmmSearch - all sequences %%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %   hmmsearch hmmbuild_Group_2.txt secuencias_ultrachico.txt > G2H.out
          
          %FileSeq=[Output_Folder '/' FileSeq_unGap];
          File_hmmrS_out=[Folder_Out_3 '/hmmS_all' myFileName_out];
          
          fn_run_hmmrS(Output_Folder,FileSeq,File_hmmrB_out,File_hmmrS_out);

 
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% HmmSearch - Group's sequences %%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
         FileSeq_1=strrep(myFileName,'.pl','.txt'); 
         
         File_hmmrS_In=[Folder_in_1 '/' FileSeq_1]; 
         
         File_hmmrS_out_grupo=[Folder_Out_3 '/hmmS' myFileName_out];
        
         fn_run_hmmrS(Output_Folder,File_hmmrS_In,File_hmmrB_out,File_hmmrS_out_grupo);
         
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%% Dendroscope Analysis sequences %%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
         if ~isempty(TreeFile)
         fn_dendroscope_group(Folder_in_0,Folder_Out_4,TreeFile,Prefix,Index);
         end