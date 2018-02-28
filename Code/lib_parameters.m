function Params = lib_parameters(List,LowCase)
% lib_parameters    -   Check list of parameters in vargin
%
%   Params = lib_parameters(List)
%
% Input:
%    
%    List   - Cell Array. List of pairs (Name, Value)
%   
% Output
%
%    Params - Structure. Parameters and their values
%
% LIB_PARAMTERIS receives a cell array containing a list of paremeters in
% the form {'name1',Value1,'name2',Value2,...} and returns an structure
% with each field named by the <name#> parameters and its value defined by 
% the <Value#> parameter.

% Changes April 12 2006, by Marcel Brun
% a) Now accepts a unique string with a file name containing the
%    information

if nargin<2
   LowCase = 1;
end

Params = [];
if iscell(List)
   if length(List)==1 && isstr(List{1})
      Type = 'struct';
      if exist(List{1},'file')==2
         Params = lib_loadparam(List{1});
         if isempty(Params)
            error('Could not find specification file');
         end
      end
   elseif length(List)==1 && isstruct(List{1})
      Type = 'struct';
      Params = List{1};
   else
      Type = 'cell';
   end
   
elseif isstruct(List)
   Type = 'struct';
   %Params = List;
    % % % %    Names = fieldnames(List);
    % % % %    Params = [];
    % % % %    for i=1:length(Names)
    % % % %        Params = setfield(Params,lower(Names{i}),getfield(List,Names{i}));
    % % % %    end
   Params = List;


elseif isstr(List)
   Type = 'struct';
   if exist(List)==2
      Params = lib_loadparam(List);
      if isempty(Params)
         error('Could not find specification file');
      end
   end

else
   error('The list must be a cell list, a cell containing a cell list, or an structure');
end

if strcmp(Type,'cell')
    
   if length(List)==1 
      List = List{1};
   end
 
   for i=1:2:(2*fix(length(List)/2)-1)
       Param = List{i};
       if ~ischar(Param)
          error('Firs element of each pair must be a string with the parameter name');
       end
       Value = List{i+1};
       if LowCase==1
          Params = setfield(Params,lower(Param),Value);
       else
          Params = setfield(Params,Param,Value);
       end
   end

elseif strcmp(Type,'struct')
   List = Params;
   Names = fieldnames(List);
   Params = [];
   for i=1:length(Names)
       Params = setfield(Params,lower(Names{i}),getfield(List,Names{i}));
   end

end
