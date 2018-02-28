function fn_Create_Orfan_file(TreeFile,Folder_Group,Prefix)

%%%%%%%%%%%%%%%% Reads Tree  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
r=phytreeread(TreeFile);

Name_H=get(r,'LeafNames');

%%%%%%%%%%%%%%%% Update List_accept %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
List_accept=[];

Dir_training = dir([Folder_Group '/' Prefix '*.txt']);
Num_Grupos_aceptados=length(Dir_training);
    
for i=1:Num_Grupos_aceptados
      myFileName=[Folder_Group '/' Prefix num2str(i) '.txt'];
      Aux=lib_loadtext(myFileName);           
      List_accept=[List_accept; Aux];
end

%%%%%%%%%%%%%%%% Generate File Orfan %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FileName_orfan=strcat(Folder_Group,'/Orfan_Elements.txt');
File_orfan = fopen (FileName_orfan,'w');

for g=1:length(Name_H)
   if sum(strcmp(List_accept,Name_H(g))) == 0
                fprintf(File_orfan, [Name_H{g} '\r\n']);
   end
end

fclose all;