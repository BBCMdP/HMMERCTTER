function Grupos_01=fn_calculate_group(r,Num_elem_min)

Z = get(r,'Pointers');
Z = [Z ones(size(Z,1),1)];
[Num_elem]=size(Z,1)+1;
 
% Grupos(i,:) has values k,k+1,...,k+n   
% Grupos(i,j) = k means that the element j belongs to cluster k 
%               when using "i" cluster
%               To avoid repetition on indices, for level "i"
%               we start the labels from the latest one used in level "i-1"
% Example:
%   Grupos(1,:) = [1 1 1 1 1]
%   Grupos(2,:) = [2 2 3 3 3]
%   Grupos(3,:) = [4 4 5 5 6]
%   Grupos(4,:) = [7 7 8 9 10]
%   Grupos(5,:) = [11 12 13 14 15]
%  We have 15 possibles subsets of {1,..,5}, defined by different cuts
%  of the clustering tree. They are anidated. For example Groups 2 and 3
%  are subgroups of group 1. And so on.

for i=1:Num_elem 
        Grupos_ind(i,:) = cluster(Z,'maxclust',i)'+(i*(i-1)/2);
end
 
 [f1,c1]=size(Grupos_ind);

 Grupos_01=[];
 Grupos_01 = uint8(Grupos_01);

% Grupos_01(i,j) contains a binary indicator of Group "i"
% If there ara 5 objects, then we get 15 rows (one row per group)
% Example (from previous one)
%   Grupos_01(1,:) = [1 1 1 1 1]
%   Grupos_01(2,:) = [1 1 0 0 0]
%   Grupos_01(3,:) = [0 0 1 1 1]
%   Grupos_01(4,:) = [1 1 0 0 0]
%   Grupos_01(5,:) = [0 0 1 1 0]
%   Grupos_01(6,:) = [0 0 0 0 1]
%   ...
%   Grupos_01(15,:) = [0 0 0 0 1]
%

% Determine how many items you will have
  contador=0;
  inicio=1;
  for i= 1:f1
      if i==1
          fin=1;
      else
          inicio=fin+1;
          fin=(i*(i-1)/2)+i;          
      end
      for k=inicio:fin
          contador=contador+1;
      end
 end

% Initialize the empty matrix for best speed
Grupos_01(contador,size(Grupos_ind,2)) = 0;

% Make the matrix Grupos_01 

 contador=0;
 inicio=1;
 for i= 1:f1
         if i==1
             fin=1;
         else
             inicio=fin+1;
             fin=(i*(i-1)/2)+i;          
         end
         for k=inicio:fin
             indices=find(Grupos_ind(i,:)==k);
             contador=contador+1;
             Grupos_01(contador,indices)=1;
             pause(0)
         end
 end

 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% Remove groups with one element  %%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Remove groups with fewer items from min items  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Grupos_01=[1 1 1 1 1 1;1 1 1 1 0 0;0 0 0 0 1 1;0 0 0 0 1 0;0 0 0 0 0 1;1 1 1 0 0 0;0 0 0 1 0 0;0 0 0 0 1 0]
%Num_elem_min=2;

[f1,c1]=size(Grupos_01);
j=1;
Grupos_obs_aux=[];
for h=1:f1
    % Does not consider universal group or empty group
    if (isequal(sum(Grupos_01(h,:)==1),c1)==0 && isequal(sum(Grupos_01(h,:)==0),c1)==0) %%&& (sum(Grupos_01(h,:)==1)) < Num_elem_min
        if  (sum(Grupos_01(h,:)==1)) >= Num_elem_min
            Grupos_obs_aux(j,:)=Grupos_01(h,:);
            j=j+1;
        end
    end
end
Grupos_01=Grupos_obs_aux;

