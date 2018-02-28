function Text = lib_loadtext(File)
% lib_loadtext   -   Reads content of text file
%
%   Text = lib_loadtext(File);
%
% Input:
%    
%    File   - String. Name of the Text file
%   
% Output
%
%    Text - Cell. Cell list of strings containing each line of the text of
%           the file.
%
% LIB_LOADTEXT reads the content of a text file and into a cell list of
% strings. Each string contains a line of the text file.
%

%% Reads Text File
fFileName = fopen(File);
if isempty(fFileName)
   error(['Can not open ' File ' for reading']);
end
Text = textscan(fFileName,'%s','delimiter','\n','whitespace','');
fclose(fFileName);
Text = Text{1};

