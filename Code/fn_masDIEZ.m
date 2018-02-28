function [List_new]=fn_masDIEZ(List_2,List_1,Score_2,Score_1)
% fn_masDIEZ
%
%   [List_new]=fn_masDIEZ(List_2,List_1,Score_2,Score_1)
%
%Input:
%       List_2 - List of names of sequences. Member of group.
%       List_1 - List of names of all sequences.
%Output:
%       List_new - the List of groups +1
%
%
% FN_masDIEZ - 

%List_1=['a' 'b' 'c' 'd' 'e' 'f' 'g'];
%Score_1=[5 4 3 2 1 1 1 1];
%List_2=['a' 'b' 'c' 'd'];
%Score_2=[5 4 3 2];

Elem_group=length(List_2);
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
    Next=10;
    if (Next)+Aux <= length(Score_1)
        a= length(Index_add);
        for k=a+1:a+Next
        Index_add= [Index_add k];
        end
    end 
    else 
        disp('fn_masDIEZ: It added all sequences with better score that worse score sequences in the group');
    end
end

List_new=List_1(Index_add);
