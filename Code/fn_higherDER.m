function [List_new]=fn_higherDER(List_2,List_1,Score_2,Score_1)
% fn_index
%
%   [List_new]=fn_higherDER(List_2,List_1,Score_2,Score_1)
%
%Input:
%       List_2 - List of names of sequences. Member of group.
%       List_1 - List of names of all sequences.
%Output:
%       List_new - the List of groups +1
%
%
% FN_higherDER - 

%List_1=['a' 'b' 'c' 'd' 'e'];
%Score_1=[5 4 3 1 1];
%List_2=['a' 'b' 'c'];
%Score_2=[5 4 3];


Derivada=diff(Score_1,1);
Mayor_der=min(Derivada);
Index_mayor_der=find(Derivada==Mayor_der);

Limite=Score_1(Index_mayor_der);
List_new=List_1(1:Index_mayor_der);

Elem_group=length(List_2);
Contador=1;
Index_group=[];
Index_add=[];

%Identify each group element in the list of selected sequences.
for j=1:Elem_group
    for k=1:length(List_new)
         if (strcmpi(List_new(k),List_2(j))==1)
             Index_group(j)=k;
             break
         end
    end
end
 
if Elem_group < length(Index_group)
	disp('Caution, Lose the group');
end
