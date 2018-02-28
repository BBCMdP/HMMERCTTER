function [Grupos_obs_new] = fn_restriccion_sil(Grupos_obs,Indices_acept)

% Only Delete group with sequences used.

[f1,c1]=size(Grupos_obs);
Index_eliminar=[];
Index_incluye=[];


if ~isempty(Indices_acept)
    for k=1:f1 %by rows the generated groups
        for j=1:length(Indices_acept)% look at each of the seq indexes to be filtered (Columns = 1)
            if Grupos_obs(k,Indices_acept(j))==1
                Indices_acept(j);
                Index_eliminar=[Index_eliminar k];
            end
        end
    end
end


Index_eliminar=sort(unique(Index_eliminar));

t=1;
Grupos_obs_new=[];
if isempty(Index_eliminar)
    Grupos_obs_new=Grupos_obs;
else
    for i=1:f1
        if (Index_eliminar==i)==0
        Grupos_obs_new(t,:)=Grupos_obs(i,:);
        t=t+1;
        end
    end
end
