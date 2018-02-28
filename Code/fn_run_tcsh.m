function fn_run_tcsh(Output_Folder,File_in)

if ispc
   Separator = '&';
else
   Separator = ';';
end


Command1=['cd ' Output_Folder];
%Command2 = ['chmod 777 ' File_in];
%Command = [Command1 Separator Command2]
          
%[Status,Result]=system(Command);

Command2=['tcsh ' File_in];
Command=[Command1 Separator Command2]
[Status,Result]=system(Command);

if Status==0
    disp(['Dendroscope on ' File_in ' executed!!']);
else
    disp(['Error executing Dendroscope on ' File_in ' - ' Result]);
end