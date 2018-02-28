function lib_savetext(File,Text)
% lib_savetext   -   Writes text into file
%
%   lib_savetext(File,Text);
%
% Input:
%    
%    File - String. Name of the Text file
%    Text - Cell.   Cell list of strings containing each line of the text 
%                   for the file.
%   
% LIB_SAVETEXT saves the content of a cell list of strings into a text
% file. Each string contains a line of the text file. To save disk write
% operations, the data is saved in chunks of 100K bytes.
%

%% Saves Output
fFileName = fopen(File,'w');
if isempty(fFileName)
   error(['Can not open ' File ' for writing']);
end

mmText = '';
for i=1:length(Text)
    mmText = [mmText sprintf('%s\n',Text{i})];
    %fprintf(fFileName,'%s\n',Text{i});
    if length(mmText)>=100000
       fprintf(fFileName,'%s',mmText);
       mmText = '';
    end
end
if length(mmText)>0
   fprintf(fFileName,'%s',mmText);
   mmText = '';
end
fclose(fFileName);

