function varargout = HMMerCTTer_Training(varargin)
% HMMERCTTER_TRAINING MATLAB code for HMMerCTTer_Training.fig
%      HMMERCTTER_TRAINING, by itself, creates a new HMMERCTTER_TRAINING or raises the existing
%      singleton*.
%
%      H = HMMERCTTER_TRAINING returns the handle to a new HMMERCTTER_TRAINING or the handle to
%      the existing singleton*.
%
%      HMMERCTTER_TRAINING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HMMERCTTER_TRAINING.M with the given input arguments.
%
%      HMMERCTTER_TRAINING('Property','Value',...) creates a new HMMERCTTER_TRAINING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HMMerCTTer_Training_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HMMerCTTer_Training_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HMMerCTTer_Training

% Last Modified by GUIDE v2.5 05-May-2014 13:34:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HMMerCTTer_Training_OpeningFcn, ...
                   'gui_OutputFcn',  @HMMerCTTer_Training_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HMMerCTTer_Training is made visible.
function HMMerCTTer_Training_OpeningFcn(hObject, eventdata, handles, varargin)
%HMMerCTTer_Training(Folder_Clustering,TreeFile,ApSeqFile,TrSeqFile,Num_min_elem,Alfa,Aligment_Program,Type_equation);
global Folder_Clustering;
global TreeFile;
global TrSeqFile;
global Num_min_elem;
global Alfa;
global Aligment_Program;
global Folder_preTraining;
global Folder_Training;
global Folder_Group;
global Folder_Fetching;
global Folder_MSA;
global Folder_Hmmr_Build;
global Folder_Hmmr_Search;
global Folder_Dendroscope;
global Index;
global Prefix;
global Index_accept;
global Index_analyzed;
global Flag_S;

Index_accept=0;

%Index_analyzed=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% make Directories %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Folder_preTraining=[Folder_Clustering, '/Training'];
mkdir(Folder_preTraining);
Folder_Training=[Folder_Clustering, '/Training_Output'];
mkdir(Folder_Training);
Folder_Group='Groups';              mkdir([Folder_Training '/' Folder_Group]);

Folder_Dendroscope='Dendroscope';     mkdir([Folder_Training '/' Folder_Dendroscope]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
List_accept=[];
Index=1;
Prefix='Group_';

ReCalculated(hObject, eventdata, handles,List_accept);

% Choose default command line output for HMMerCTTer_Training
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HMMerCTTer_Training wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HMMerCTTer_Training_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in bNo.
function bNo_Callback(hObject, eventdata, handles)
global TreeFile;
global Folder_preTraining;
global Folder_Training;
global Folder_Group;
global Index;
global Prefix;
global List_accept;
global Flag_S;

%%%%%%%%%%%%%%%% Disabled button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.bYes,'Enable','off');
set(handles.bNo,'Enable','off');

UserDecision = 'NO';
AnalysisFile(hObject, eventdata, handles,UserDecision);

%%%%%%%%%%%%%%%% Evaluated next group %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dir_preTraining = dir([Folder_preTraining '/' Folder_Group '/' Prefix '*.txt']);
Index=Index+1;

if Index <= length(Dir_preTraining)
  [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_preTraining,Prefix,Index);
  actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);  
elseif isequal(Flag_S,[])
     ReCalculated(hObject, eventdata, handles,List_accept); 
else
     close all;
     fn_dendroscope_ALLgroup([Folder_Training '/' Folder_Group], ...
                 [Folder_Training '/Dendroscope'],TreeFile,Prefix);
     fn_Create_Orfan_file(TreeFile,[Folder_Training '/' Folder_Group],Prefix);
     
     msgbox('The clustering phase finished successfully.','Analysis finished');
end

% --- Executes on button press in bYes.
function bYes_Callback(hObject, eventdata, handles)
global TreeFile;
global Aligment_Program;
global Folder_preTraining;
global Folder_Training;
global Folder_Group;
global Folder_Fetching;
global Folder_MSA;
global Folder_Hmmr_Build;
global Folder_Hmmr_Search;
global Folder_Dendroscope;
global Index;
global Prefix;
global Index_accept;
global List_accept;
global Flag_S;

%%%%%%%%%%%%%%%% Disabled button %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.bYes,'Enable','off');
set(handles.bNo,'Enable','off');

UserDecision = 'YES';
AnalysisFile(hObject, eventdata, handles,UserDecision);

%%%%%%%%%%%%%%%% Save Group Accepted %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Index_accept=Index_accept+1;
Actual_group=[Prefix num2str(Index) '.txt'];
Accept_group=[Prefix num2str(Index_accept) '.txt'];
copyfile([Folder_preTraining '/' Folder_Group '/' Actual_group],[Folder_Training '/' Folder_Group '/' Accept_group]);
copyfile([Folder_preTraining '/' Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index) '.png'],[Folder_Training '/' Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index_accept) '.png']);
copyfile([Folder_preTraining '/' Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index) '.svg'],[Folder_Training '/' Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index_accept) '.svg']);
copyfile([Folder_preTraining '/' Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index) '.nexml'],[Folder_Training '/' Folder_Dendroscope '/Dendroscope_' Prefix num2str(Index_accept) '.nexml']);

%%%%%%%%%%%%%%%% Evaluated next group %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Dir_preTraining = dir([Folder_preTraining '/' Folder_Group '/' Prefix '*.txt']);
Index=Index+1;

if Index <= length(Dir_preTraining)
  [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_preTraining,Prefix,Index);
  actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);  
elseif isequal(Flag_S,[])
%%%%%%%%%%%%%%% ReCalculated %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ReCalculated(hObject, eventdata, handles,List_accept);
else 
     close all;
     fn_dendroscope_ALLgroup([Folder_Training '/' Folder_Group], ...
                 [Folder_Training '/Dendroscope'],TreeFile,Prefix);
     fn_Create_Orfan_file(TreeFile,[Folder_Training '/' Folder_Group],Prefix);
     
    msgbox('The clustering phase finished successfully.','Analysis finished');
end


function ReCalculated(hObject, eventdata, handles,List_accept)
global Index;
global Index_accept;
global Prefix;
global Folder_preTraining;
global Folder_Training;
global Folder_Group;
global TreeFile;
global TrSeqFile;
global Num_min_elem;
global Alfa;
global Flag_S;
global Flag_FP;
global Index_analyzed;
global Aligment_Program;

Index= 1;
Flag_FP=1;

Dir_preTraining = dir([Folder_preTraining '/' Folder_Group '/' Prefix '*.txt']);

%%%%%%%%%%%%%%%% Delete all Group_*.txt in Dir_preTraining %%%%%%%%%%%%%%%%
if ~isempty(Dir_preTraining)
    delete([Folder_preTraining '/' Folder_Group '/' Prefix '*.txt']);
    delete([Folder_preTraining '/' Folder_Group '/Orfan_Elements.txt']);
    rmdir([Folder_preTraining '/Fetching'],'s');
    if strcmp(Aligment_Program,'Mafft')
        rmdir([Folder_preTraining '/MSA_M'],'s');
    elseif strcmp(Aligment_Program,'T-coffee')
    rmdir([Folder_preTraining '/MSA_T'],'s');
    end
    rmdir([Folder_preTraining '/Hmmr-Build'],'s');
    rmdir([Folder_preTraining '/Dendroscope'],'s');
end
%%%%%%%%%%%%%%%% Update List_accept %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    List_accept=[];
    Dir_training = dir([Folder_Training '/' Folder_Group '/' Prefix '*.txt']);
    Num_Grupos_aceptados=length(Dir_training);
    for i=1:Num_Grupos_aceptados
         myFileName=[Folder_Training '/' Folder_Group '/' Prefix num2str(i) '.txt'];
        Aux=lib_loadtext(myFileName);           
        List_accept=[List_accept; Aux];
    end

%%%%%%%%%%%%%%% ReCalculated %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while Flag_FP == 1
    [Flag_S,Flag_FP,Index_analyzed]=test_Training(Folder_preTraining,TreeFile,TrSeqFile,Num_min_elem,Alfa,Aligment_Program,List_accept); 
         %%%%%%%%% Verification if there are group generated %%%%%%%%%%%%%%
         %%%%%%%%%%%%%%%%%% in this iteration %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
     if (Flag_FP ==0)
             [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_preTraining,Prefix,Index);
             actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
             break;
     elseif (isequal(Flag_S,'End'))+(Index_accept > 0) ==2 %%% There are some group accepted %%%%%%%%
                close all;
                fn_dendroscope_ALLgroup([Folder_Training '/' Folder_Group], ...
                 [Folder_Training '/Dendroscope'],TreeFile,Prefix);                
                fn_Create_Orfan_file(TreeFile,[Folder_Training '/' Folder_Group],Prefix);
                %fn_Create_GraphicScoreFiles(Folder_Training,Prefix);
                msgbox('The clustering phase finished successfully.','Analysis finished');
                %HMMerCTTer_Application(Folder_Clustering,ApSeqFile,Aligment_Program,Prefix);
                break;
     elseif isequal(Flag_S,'End')
         errordlg('There are no more groups to analise','Analysis finished');
         pause(3),
         close all; clc;
         break;
     end
    %%%%%%%%%%%%% If Flag_FP == 1 -> There are FP in this group %%%%%%%%%%%
    %%%%%%%%%%%%% AnalysisFile
    AnalysisFile(hObject, eventdata, handles);
end

function actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group)
global Prefix;
global Folder_preTraining;
global Index_accept;
global Index;

cla reset;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Logo %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
handles.output = hObject;
axes(handles.axes3); 
handles.imagen=imread('LogoHMMerCTTer.png'); 
imagesc(handles.imagen); 
axis off 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Axes 1 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Folder_dendroscope=[Folder_preTraining '/Dendroscope'];
File_dendroscope_png=['Dendroscope_' Prefix num2str(Index) '.png'];

File_dendroscope_png=[Folder_dendroscope '/' File_dendroscope_png];
[Imagen_recortada]=fn_recortar_imagen(File_dendroscope_png);

axes(handles.axes1);
imshow(Imagen_recortada);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Axes 2 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Index_group=sort(Index_group);

axes(handles.axes2);
plot(Score_all,'*');
hold on
plot(Derivada_all,'r');
hold on
plot(Index_group,Score_group,'go');
xPos = max(Index_group);
yPos = min(Score_group);
hold on
plot(get(gca,'xlim'), [yPos yPos],'m'); % Adapts to x limits of current axes
hold on
plot([xPos xPos],get(gca,'ylim'),'m'); % 
hold off
titulo = title(['Score Group']);

leyenda1 = 'Score';
leyenda2 = 'Derivative';
leyenda3= ['Score group ' num2str(Index_accept+1)];
leyenda = legend(leyenda1,leyenda2,leyenda3);

set(titulo,'FontSize',16);
set(leyenda,'FontName','arial','FontUnits','points','FontSize',16,...
          'FontWeight','normal','FontAngle','normal');
       

set(handles.bYes,'Enable','on');
set(handles.bNo,'Enable','on');
      
handles.output = hObject;      
guidata(hObject, handles);   


function AnalysisFile(hObject, eventdata, handles,UserDecision)
%%%%%%%%%%%%%%%%%%%% File All Groups %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% /AnalysisFile.txt
% Id_Group  FP User
% G_1     NO    YES
% G_2     YES   
% G_3     NO    NO

global Folder_preTraining;
global Flag_FP;
global Index_analyzed;

Folder_Group = [Folder_preTraining '/Groups'];
FileName_Analysis = [Folder_Group '/AnalysisFile.txt'];

if ~exist(FileName_Analysis,'file')
    File_All = fopen(FileName_Analysis,'a+');
    fprintf(File_All,['Id_Group' '\t' 'FP' '\t' 'User' '\n']);
else
    File_All = fopen(FileName_Analysis,'a+');
end
if Flag_FP == 1
    fprintf(File_All, ['G_' num2str(Index_analyzed) '\t'  'YES \r\n']);
else
        fprintf(File_All, ['G_' num2str(Index_analyzed) '\t'  'NO' '\t' UserDecision '\r\n']);
end
fclose(File_All);
