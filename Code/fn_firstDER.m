function [List_new]=fn_firstDER(List_2,List_1,Score_2,Score_1)
% fn_index
%
%   [List_new]=fn_firstDER(List_2,List_1,Score_2,Score_1)
%
%Input:
%       List_2 - List of names of sequences. Member of group.
%       List_1 - List of names of all sequences.
%Output:
%       List_new - the List of groups +1
%
%
% FN_fistDER - 
%List_1=['a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i'];
%Score_1=[10 10 9  6 2 1 1 1 1];
%List_2=['a' 'b' 'c'];
%Score_2=[5 4 3];

Derivada=diff(Score_1,1);
Mayor_der=min(Derivada);
I_mayor_der=find(Derivada==Mayor_der);
Umbral=Mayor_der/2;
for i=1:I_mayor_der
    if (Derivada(i))<= Umbral
        Index_first_der=i;
        break,
    elseif i==I_mayor_der;
        Index_first_der=i;
    end
end

List_new=List_1(1:Index_first_der);

Elem_group=length(List_2);
Contador=1;
Index_group=[];
Index_add=[];

% Identify each group element in the list of selected sequences.
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
