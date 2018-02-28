function [Imagen_recortada]=fn_recortar_imagen(File)

Imagen=imread(File);
Aux=sum(Imagen,3);
Filas=sum(Aux,1);
Columnas=sum(Aux,2);

contador=0;
for i=1:length(Filas)
    if Filas(i) ~= Filas(1)
        if contador==0
            Indice_min_f=i-15;
        end
        contador=contador+1;
    end
end
Indice_max_f=Indice_min_f+contador+15;
contador=0;
for i=1:length(Columnas)
    if Columnas(i) ~= Columnas(1)
        if contador==0
        Indice_min_c=i-15;
        end
        contador=contador+1;
    end
end
Indice_max_c=Indice_min_c+contador+15;
Imagen_recortada=Imagen(Indice_min_c:Indice_max_c,Indice_min_f:Indice_max_f,:);
