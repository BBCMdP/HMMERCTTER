function [List_new]=fn_masFP(List_2,List_1,Score_2,Score_1)

Elem_group=length(List_2);
Contador=1;
Index_group=[];
Index_add=[];

%Identify each group element in the list of all sequences.
for j=1:Elem_group
    for k=1:length(List_1)
         if (strcmpi(List_1(k),List_2(j))==1)
             Index_group(j)=k;
             break
         end
    end
end
 

Limite=min(Score_2);
Aux=1;
for k=1:length(Score_1)
    if Score_1(k) >= Limite
        Index_add(Aux)=k;
        Aux=Aux+1;
    end
end

if length(Index_group)==Elem_group 
    if length(Index_add) >= length(Score_2)
        disp('fn_masFP: It added all sequences with better score that worse score sequences in the group');
        List_new=List_1(Index_add);
    else
        List_new=List_2;
    end
end
