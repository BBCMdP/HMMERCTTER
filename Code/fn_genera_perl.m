function fn_genera_perl(Output_Folder,FileSeq,Prefix)

Folder_in=[Output_Folder '/Group_S'];
Folder_Out=[Output_Folder '/Fetching'];
if ~exist(Folder_Out,'dir') 
    mkdir(Folder_Out);
end


Dir = dir([Folder_in '/' Prefix '*.txt']);
if isempty(Dir)
   disp(['There are no files "' Prefix '*.txt" in the folder ' Output_Folder ' - Fetching script will not be generated !!'])
else
     disp(['Saving Fetching Scripts in folder ' Output_Folder]);
    for Index = 1:length(Dir)
         myFileName = Dir(Index).name;

         File = [Folder_in '/' myFileName];
         %List = lib_loadtext(File);

         %Text = test_genera_perl_sub_text(List,[Output_Folder '/' FileSeq],myFileName);
         Text = fn_subtext_cFetching(File, FileSeq,myFileName);
         Text = Text(:);

         File_Script = [Folder_Out '/fetching_' strrep(myFileName,'.txt','.pl')];
         lib_savetext(File_Script,Text);
         disp(['Fetching Script ' File_Script ' saved!!']);
    end
end
