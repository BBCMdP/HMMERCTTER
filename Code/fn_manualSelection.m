function [List_new]=fn_manualSelection(List_2,List_1,Score_2,Score_1,pt_horizontal)

Limite=pt_horizontal;
Aux=1;
for k=1:length(Score_1)
    if Score_1(k) >= Limite
        Index_add(Aux)=k;
        Aux=Aux+1;
    end
end
List_new=List_1(Index_add);


