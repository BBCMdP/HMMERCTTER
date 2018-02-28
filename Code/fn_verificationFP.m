function [FP]=fn_verificationFP(List_2,List_1,Score_2,Score_1)

Min_Score_2=min(Score_2);
Indice_min_score_g=find(Score_2==Min_Score_2);
%Lista_min_score_g=List_2(Indice_min_score_g);
All_indices=[];
      
for i=1:length(Indice_min_score_g)
    a=Indice_min_score_g(i);
    for k=1:length(List_1)
         if strcmpi(List_1(k),List_2(a))
            All_indices=[All_indices k];
         end
    end
end

Aux=max(All_indices);
       
if Aux==length(List_2)
    FP=0; %there are not FP
else
    FP=1;
end
