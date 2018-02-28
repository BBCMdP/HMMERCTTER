function [Flag_S,Flag_FP,Index_analyzed]=test_Training(Folder_preTraining,TreeFile,TrSeqFile,...
                    Num_min_elem,Alfa,Aligment_Program,List_accept)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call to fn_silhoutte and fn_run program and fn_verificationFP
% If not FP save Group_#.txt, else delete preGroup_#.txt proposed by
% fn_silhoutte
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prePrefix='preGroup_';
Prefix='Group_';
Flag_S='';
Flag_FP=0;

Folder_Group = [Folder_preTraining '/Groups'];
Folder_Fetching = [Folder_preTraining '/Fetching'];
if isequal(Aligment_Program,'Mafft')
     Folder_MSA = [Folder_preTraining '/MSA_M']; 
elseif isequal(Aligment_Program,'T-coffee')
     Folder_MSA = [Folder_preTraining '/MSA_T']; 
end
Folder_HmmrB=[Folder_preTraining '/Hmmr-Build'];
Folder_HmmrS=[Folder_preTraining '/Hmmr-Search'];
Folder_Dendroscope=[Folder_preTraining '/Dendroscope'];
   

%%%%%%%%%%%%%% Create groups, and evaluate %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Flag_S, Index_analyzed]=fn_silohuette(TreeFile,Folder_preTraining,'alfa',Alfa,'num_elem_min', ...
            Num_min_elem,'prefix',prePrefix,'list_acept',List_accept);

%%%%%%%%%%%% For each group generated, run programs, and verified FP %%%%%%

Index_accept=0;
Dir = dir([Folder_preTraining '/Groups/' prePrefix '*.txt']);

if isempty(Dir)
   disp(['There are no files "' prePrefix '*.txt" in the folder ' Folder_preTraining ' - Fetching script will not be generated !!']);
else
    disp('Run analysis program');
    for i=1:length(Dir)
     fn_run_program(Folder_preTraining,prePrefix,TrSeqFile,Aligment_Program,i,TreeFile);
        
    %%%%%%%%%%%%%%%%% Verification False Positive %%%%%%%%%%%%%%%%%%%%%%%%%
    [Score_1,Derivada_1,Index_2,Score_2,List_1,List_2]=fn_graphic_index(Folder_preTraining,prePrefix,i);
    [FP]=fn_verificationFP(List_2,List_1,Score_2,Score_1);
    
    preFileName=[prePrefix num2str(i) '.txt'];
    
    if FP == 0 % Ther are not FP
        Index_accept = Index_accept + 1;
        FileName = [Prefix num2str(Index_accept) '.txt'];
        
        copyfile([Folder_Group '/' preFileName],[Folder_Group '/' FileName]);
        copyfile([Folder_Fetching '/fetching_' preFileName],[Folder_Fetching '/fetching_' FileName]);
        copyfile([Folder_MSA '/' Aligment_Program '_' preFileName],[Folder_MSA '/' Aligment_Program '_' FileName]);
        copyfile([Folder_HmmrB '/hmm_' preFileName],[Folder_HmmrB '/hmm_' FileName]);
        copyfile([Folder_HmmrS '/hmmS_' preFileName],[Folder_HmmrS '/hmmS_' FileName]);
        copyfile([Folder_HmmrS '/hmmS_all_' preFileName],[Folder_HmmrS '/hmmS_all_' FileName]);
        copyfile([Folder_Dendroscope '/Dendroscope_' prePrefix num2str(i) '.png'],[Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index_accept) '.png']);
        copyfile([Folder_Dendroscope '/Dendroscope_' prePrefix num2str(i) '.svg'],[Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index_accept) '.svg']);
        copyfile([Folder_Dendroscope '/Dendroscope_' prePrefix num2str(i) '.nexml'],[Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index_accept) '.nexml']);
        
    end
        %%%%%%%%%%%%%% Delete preGroup_*.txt in Dir_preTraining %%%%%%%%%%%
        delete([Folder_Group '/' preFileName]);
        delete([Folder_Fetching '/fetching_' preFileName]);
        delete([Folder_Fetching '/fetching_' prePrefix num2str(i) '.pl']);
        delete([Folder_MSA '/' Aligment_Program '_' preFileName]);
        delete([Folder_HmmrB '/hmm_' preFileName]);
        delete([Folder_HmmrS '/hmmS_' preFileName]);
        delete([Folder_HmmrS '/hmmS_all_' preFileName]);
        delete([Folder_HmmrS '/hmmS_all_' preFileName]);
        delete([Folder_Dendroscope '/Dendroscope_' prePrefix num2str(i) '.png']);
        delete([Folder_Dendroscope '/Dendroscope_' prePrefix num2str(i) '.svg']);
        delete([Folder_Dendroscope '/Dendroscope_' prePrefix num2str(i) '.nexml']);
        
    end
end

if Index_accept > 0
    Flag_FP=0; %There is no FP in at least one group
else
    Flag_FP=1;
end
