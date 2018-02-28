function [List_new]=fn_masUNO(List_2,List_1,Score_2,Score_1)

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

%a=sort(Index_group);
%b=sort(Index_add);
%if isequal(a,b)==1

%To know if the elements of the group and the elements to be added are the same:
Aux=0;
if length(Index_group)==length(Index_add)
    for i=1:length(Index_group)
        for j=1:length(Index_add)
            if strcmp(List_1(i),List_1(j))==1
                Aux=Aux+1;
                break,
            end
        end
    end
   
    if Aux==length(Index_add)
    One_next=length(Index_add)+1;
    if (One_next) <= length(Score_1)
        Index_add= [Index_add One_next];
    end 
    else 
        disp('fn_masUNO: It added all sequences with better score that worse score sequences in the group');
    end

end

List_new=List_1(Index_add);
