function fn_run_hmmrS(Folder_in_1,FileSeq,File_hmmrB_out,File_hmmrS_out)
% fn_run_hmmrS - run command hmmsearch
%
%   fn_run_hmmrS(Folder_in_1,FileSeq,File_hmmrB_out,File_hmmrS_out)
%
%Input:
%       Folder_in_1 - String. Path to the input file.
%       FileSeq - String. Filename. File with the sequences.
%       File_hmmrB_out - String. Filename. File with the profile generates
%                         with hmmbuild.
%       File_hmmrS_out - String. Output filename.
%
% FN_RUN_HMMRS - run hmmsearch. This command calculates a score for each 
% sequence (FileSeq) against the profile (File_hmmrB_out)

if ispc
   Separator = '&';
else
   Separator = ';';
end


Command1=['cd ' Folder_in_1];
Command2=['hmmsearch --noali ' File_hmmrB_out ' ' FileSeq ' > ' File_hmmrS_out];
%Command2=['hmmsearch ' File_hmmrB_out ' ' FileSeq ' > ' File_hmmrS_out];
Command = [Command1 Separator Command2];
          
[Status,Result]=system(Command);
if Status==0
      disp(['hmmer search on ' File_hmmrB_out ' executed!!']);
else
      disp(['Error executing hmmer Search on ' File_hmmrB_out ' - ' Result]);
      %disp(Command2)
end
