function fn_run_perl(File_Script,Folder_in_1)
% fn_run_perl - run perl commands 
%
%   fn_run_perl(File_Script,Folder_in_1)
%
%Input:
%       File_Script - String. Filename to execute '*.pl'
%       Folder_in_1 - String. Path to the input file.
%
% FN_RUN_PERL - generates an output file with the result.

Command1 = ['cd ' Folder_in_1];

if ispc
   Separator = '&';
else
   Separator = ';';
end
         
Command2 = ['perl ' File_Script]
Command = [Command1 Separator Command2]
[Status,Result]=system(Command);

if Status==0
   disp(['Fetching Script ' File_Script ' executed!!']);
else
            disp(['Error executing Fetching Script ' File_Script ' - ' Result]);
end