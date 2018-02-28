function Order_IndSil = fn_calculate_sil(r, Grupos_01, Alfa, File_Group_sort, Output_Folder);


%%%%%%%%%%%%%%%%%%%%%%%%%
%% Computes Distances %%%
%%%%%%%%%%%%%%%%%%%%%%%%%
Mat_distancia = pdist(r,'Squareform',true);
[MATRIX, ID, DIST] = getmatrix(r); 

[fil1,col1]=size(Grupos_01);
NumEl = size(Mat_distancia,1);
valor_sil = zeros(1,fil1);
Num_Leaves=get(r,'NumLeaves');
Indice=zeros(1,fil1);

for i=1:fil1
    C=Grupos_01(i,:);
    if sum(C)<Num_Leaves && sum(C)>1 %&& (size(Sc,1)==2)
	valor_sil(i)= 0;%Sc(2,1);
        S_prima=(valor_sil(i)+1)/2;
        N_prima=sum(C)/Num_Leaves;
        Indice(i)= Alfa*log(S_prima)+ (1-Alfa)*log(N_prima);     
    else
        valor_sil(i)=-1;
        Indice(i)=-1;
    end
end

    % Sorts Groups by Rank Index
    [Temp,Order_IndSil] = sort(Indice(:),1,'descend');

    Vector_filter=[];
    Index_group_Analyzed=[];
    Num=0;
    Contador=0;
    [f_grupos_01,c_grupos_01]=size(Grupos_01);
    
    Group01_NoAnalyzed = Grupos_01(Order_IndSil,:);
    save(File_Group_sort,'Group01_NoAnalyzed');

%%%%%%%%%%%%%%%%%%%% File All Groups %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /Seq_Index.txt
% Id_Group  Score Indexes
% Group_1     2     1 2 3 4  
% Group_2     1.5   2 3 4
% Group_3     1     3 4
% Group_4     0.5   3
% Group_5     0.25  5
% Group_6     0.1   6
 
FileName_All = [Output_Folder '/IDgroup_Index.txt'];

if ~exist(FileName_All,'file')
    File_All = fopen(FileName_All,'w');
    fprintf(File_All,['Id_Group' '\t' 'Score' '\t' 'Indexes' '\n']);
    for h=1:f_grupos_01
        %C=Grupos_01(Order_IndSil(h),:);
        C= Group01_NoAnalyzed(h,:);
        aux=((find(C)))';
        Sil = Temp(h);
        
        fprintf(File_All, ['G_' num2str(h) ' ' num2str(Sil) ' ' num2str(find(C)) '\r\n']);
    end
    fclose(File_All);
end
