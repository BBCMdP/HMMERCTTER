function [Index_group,Index_add]=fn_index(List_2,List_1,Score_2,Score_1)
% fn_index
%
%   [Index_group,Index_add]=fn_index(List_2,List_1)
%
%Input:
%       List_2 - List of names of sequences. Member of group.
%       List_1 - List of names of all sequences.
%Output:
%       Index_group - Vector. 
%       Index_add - Number. Next to add.
%
%
% FN_INDEX - 

Elem_group=length(List_2);
Contador=1;
Index_group=[];
Index_add=[];

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

% To know if the elements of the group and the elements to be added are the same:
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
    end
end
