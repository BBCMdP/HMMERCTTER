function fn_run_hmmrB(Folder_in_1,File_hmmr_in,File_hmmrB_out)
% fn_run_hmmrB - run command hmmbuild
%
%   fn_run_hmmrB(Output_Folder,File_hmmr_in,File_hmmrB_out)
%
%Input:
%       Folder_in_1 - String. Path to the input file.
%       File_hmmr_in - String. Filename. File with the sequences.
%       File_hmmrB_out - String. Output filename.
%
% FN_RUN_HMMB - run hmmbuild. This command builds a profile of the
% sequences and save the result in File_hmmrB_out.

if ispc
   Separator = '&';
else
   Separator = ';';
end


Command1=['cd ' Folder_in_1];
Command2 = ['hmmbuild --informat afa ' File_hmmrB_out ' ' File_hmmr_in];
Command = [Command1 Separator Command2];
          
[Status,Result]=system(Command);
          
if Status==0
    disp(['hmmer build on ' File_hmmr_in ' executed!!']);
else
    disp(['Error executing hmmer build on ' File_hmmr_in ' - ' Result]);
 %   disp(Command2)
end
        