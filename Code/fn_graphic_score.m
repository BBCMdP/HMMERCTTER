function [Score,List,Derivada]=fn_graphic_score(File_in)


Data=fopen(File_in); 

Score=[];
List=[];
Aux=0;
     for i=1:15 % 14 x 15
         tline = fgets(Data);
         if ~ischar(tline)
            break, 
         end
         Aux=Aux+1;
         j=0;
         if Aux==15  % 14 x 15
             k = [ ]; 
             while isempty(k) == 1
                 tline = fgets(Data);
                 aux_1=length(tline);
                 if aux_1==1
                    k = 1;
                    break,
                 else
                    [datouno,c]=strtok(tline);
                    [datodos,c]=strtok(c);
                    
                    j=j+1;
                    Aux_score=str2num(datodos);
                    if isempty(Aux_score)==1
                       Score(j)=0;
                       List{j}='umbral';
                    else
                    [datotres,c]=strtok(c);
                    [datocuatro,c]=strtok(c);
                    [datocinco,c]=strtok(c);
                    [datoseis,c]=strtok(c);
                    [datosiete,c]=strtok(c);
                    [datoocho,c]=strtok(c);
                    [datonueve,c]=strtok(c);
                    Score(j)=Aux_score;
                    List{j}=datonueve; % nombre secuencia
                    end
                    
                 end
              end
        end
     end
     
    %filtro por valores unicos.
    [List,ia] = unique(List);
    Score = Score(ia);
     
     [Score,Index]=sort(Score,'descend');
     Derivada=diff(Score,1);
    List=List(Index);