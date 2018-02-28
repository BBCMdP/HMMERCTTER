function [Flag_S,Index_analyzed]=fn_silohuette(FileTree,Output_Folder,varargin)
% fn_silohutte - Calculates groups and Silhoutte index.
%
%
%       fn_silhouette(FileTree,Output_Folder)
%       fn_silohuette(FileTree,Output_Folder,'OptionRank',Value,
%                       'Save_Index',Value,'Prefix',Value,'Num_elem_min',Value)
%
%Input:
%       FileTree - File Name. Format:Newick.
%       Output_Folder - Path to files.
%       Prefix - String. Prefix for file name with groups.
%       Num_elem_min - Number. Minimum number of items per group
%       List_acept - vector of string.
% Output:
%       Flag_1 -  'End' all possible group had just been analyzed or 
%                       there are not group generated.


Output_Folder=[Output_Folder '/Groups'];
if ~exist(Output_Folder,'dir') 
    mkdir(Output_Folder);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%     Parameters     %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Spec = lib_parameters(varargin)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%     Default values     %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isfield(Spec,'prefix');  Spec.prefix='Group_';end
if ~isfield(Spec,'num_elem_min');  Spec.num_elem_min=8;end
if ~isfield(Spec,'alfa');  Spec.alfa=0;end
if ~isfield(Spec,'list_acept');  Spec.list_acept=[];end

Prefix=Spec.prefix;
Num_elem_min=Spec.num_elem_min;
Alfa=Spec.alfa;
List_acept=Spec.list_acept;

%%%%%%%%%%%%%%%%%%%%%%%%
%%% Checks Version   %%%
%%%%%%%%%%%%%%%%%%%%%%%%
a = version;
[BigVersion,a] = strtok(a,'.');
[SmallVersion,a] = strtok(a,'.');
if str2num(BigVersion)<7 && str2num(SmallVersion)<6
   error('Matlab 7.6 or higher needed for correct computation of distances');
   close all;
   return,
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%
%%% File Input %%%%%
%%%%%%%%%%%%%%%%%%%%

% Reads Tree
r=phytreeread(FileTree);

Name_H=get(r,'LeafNames');


%%%%%%%%%%%%%%%%%%%% File 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /Seq_Index.txt
% Id_Seq   Index
% Seq_1     1
% Seq_2     2
% Seq_3     3
% Seq_4     4
% Seq_5     5
% Seq_6     6

FileName_Index_Seq = [Output_Folder '/Seq_Index.txt'];

if ~exist(FileName_Index_Seq,'file')
    File_Index_Seq = fopen (FileName_Index_Seq,'w');
    fprintf(File_Index_Seq, ['Id_Seq' '\t' 'Index' '\n']);
  for j=1:length(Name_H)
        fprintf(File_Index_Seq, [Name_H{j} '\t' num2str(j) '\n']);
  end 
    fclose(File_Index_Seq);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
File_group01_sort= [Output_Folder '/Group01_all.mat'];
File_group_sortNoAnalyzed= [Output_Folder '/Group01_NoAnalyzed.mat'];

if exist(File_group01_sort,'file') ~= 2
    % Compute groups
    Grupos_01=fn_calculate_group(r,Num_elem_min);

    % Remove duplicate groups (see example in fn_calculate_group)
    Grupos_01=unique(Grupos_01,'rows');
    
    %Calculate Silhoutte
    Order_IndSil = fn_calculate_sil(r, Grupos_01,Alfa, File_group_sortNoAnalyzed, Output_Folder);
    
    % Save them in file - with no duplicates
    Grupos_01=Grupos_01(Order_IndSil,:);
    save(File_group01_sort, 'Grupos_01');
    
   % Auxiliar=load(File_group_sortNoAnalyzed);
   % Grupos_01=Auxiliar.Group01_NoAnalyzed;
else
    % Loads the groups if the exist
    Auxiliar=load(File_group_sortNoAnalyzed);
    Grupos_01=Auxiliar.Group01_NoAnalyzed;
 end

%%%%%%%%%%% I verified if Seq has been assigned to an accepted group %%%%%%%%

% Converts list of groups (sequence identifiers) in a list (index in tree list)
Indice_acept=[];
if ~isempty(List_acept)
    for k=1:size(List_acept,1)
        for h=1:length(Name_H)
            if strcmpi(List_acept(k,:),Name_H{h})
                Indice_acept=[Indice_acept h];
            end
        end
    end 
end


%%%%%%%%%%%%%%%%%%%%%%%%%% Filter Groups %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Removes groups with "accepted" sequences
% An "accepted" sequence is a sequence that belongs to
% a group already processed, and accepted.
% They cant belong to two groups, so once a sequence is accepted
% (in a group) all other groups with such sequence are killed.
Grupos_01_restrict=fn_restriccion_sil(Grupos_01,Indice_acept);
Num_Leaves=get(r,'NumLeaves');
Flag_S=[];
if isempty(Grupos_01_restrict) %% All sequences has been assigned
    Flag_S='End';
    Index_analyzed = [];
else
   %%%%%%%%%%%%%%%%%%%%% File preGroup to Analyze %%%%%%%%%%%%%%%%%%%%%%%%%%%%
   i=1;
   C=Grupos_01_restrict(i,:);
   aux=(Name_H(find(C)))';
   
   if sum(C)<Num_Leaves && sum(C)>1 

     FileName_group=strcat(Output_Folder,'/',Prefix,num2str(i),'.txt');
     File_group = fopen (FileName_group,'w');

     for j=1:length(aux)
         fprintf(File_group, [aux{j} '\n']);
     end
     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%% Saved Group No analyzed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   Group01_NoAnalyzed = [];
   [fil, col] = size(Grupos_01_restrict);
   if fil >=2
   Group01_NoAnalyzed=Grupos_01_restrict(2:fil,:);
   else
       Group01_NoAnalyzed=[];
   end
   
   if isempty(Group01_NoAnalyzed)
        Flag_S='End'; % There are not group generated - Finish
   else
        save(File_group_sortNoAnalyzed,'Group01_NoAnalyzed');
   end

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
%%%%%%%%%%%%%%%%%% Index Group analyzed %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Loads the all groups if the exist
    Auxiliar=load(File_group01_sort);
    Grupos_01_all=Auxiliar.Grupos_01;
    for i=1:size(Grupos_01_all,1)
        if Grupos_01_all(i,:) == C
        Index_analyzed=i;
        break,
        end
    end

%%%%%%%%%%%%%%% Saved Seq without assigned group %%%%%%%%%%%%%%%%%%%%%%%%%%
    FileName_orfan=strcat(Output_Folder,'/Orfan_Elements.txt');
    File_orfan = fopen (FileName_orfan,'w');

    for g=1:length(Name_H)
        if (sum(strcmp(aux,Name_H(g)))+sum(strcmp(List_acept,Name_H(g)))) == 0
                fprintf(File_orfan, [Name_H{g} '\r\n']);
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

   end
end

fclose all

