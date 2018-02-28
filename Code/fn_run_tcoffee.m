function fn_run_tcoffee(Folder_in_1,File_Fetching,File_TCoffee_out);
% fn_run_tcoffee - run command tcoffee
%
%       fn_run_tcoffee(Folder_in_1,File_Fetching,File_TCoffee_out);
%
%Input:
%       Folder_in_1 - String. Path to the input file.
%       File_Fetching - String. Filename. File with the sequences for align.
%       File_TCoffee_out - String. Output filename.
%
% FN_RUN_TCOFFEE - run tcoffee. Tcoffee aligns the input sequences (File_Fetching)

if ispc
   Separator = '&';
else
   Separator = ';';
end

Command1 = ['cd ' Folder_in_1];
Command2 = ['t_coffee ' File_Fetching ' -outfile=' File_TCoffee_out ' -output=fasta_aln'];
Command = [Command1 Separator Command2];
[Status,Result]=system(Command);

if Status==0
     disp(['t-coffe on ' File_Fetching ' executed!!']);
else
     disp(['Error executing t-cofee on ' File_Fetching ' - ' Result]);
end
