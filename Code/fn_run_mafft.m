function fn_run_mafft(Folder_in_1,File_Fetching,File_Mafft_out);
% fn_run_mafft - run command mafft
%
%       fn_run_mafft(Folder_in_1,File_Fetching,File_TCoffee_out);
%
%Input:
%       Folder_in_1 - String. Path to the input file.
%       File_Fetching - String. Filename. File with the sequences for align.
%       File_Mafft_out - String. Output filename.
%
% FN_RUN_MAFFT- run MAFFT. MAFFT aligns the input sequences (File_Fetching)

if ispc
   Separator = '&';
else
   Separator = ';';
end
%system('unset MAFFT_BINARIES');

Command1 = ['cd ' Folder_in_1];
Command2 = ['mafft --anysymbol --auto ' File_Fetching ' > ' File_Mafft_out];
Command = [Command1 Separator Command2];
[Status,Result]=system(Command);

if Status==0
     disp(['mafft on ' File_Fetching ' executed!!']);
else
     disp(['Error executing mafft on ' File_Fetching ' - ' Result]);
end
