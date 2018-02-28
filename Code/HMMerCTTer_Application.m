function varargout = HMMerCTTer_Application(varargin)
% HMMERCTTER_APPLICATION MATLAB code for HMMerCTTer_Application.fig
%      HMMERCTTER_APPLICATION, by itself, creates a new HMMERCTTER_APPLICATION or raises the existing
%      singleton*.
%
%      H = HMMERCTTER_APPLICATION returns the handle to a new HMMERCTTER_APPLICATION or the handle to
%      the existing singleton*.
%
%      HMMERCTTER_APPLICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HMMERCTTER_APPLICATION.M with the given input arguments.
%
%      HMMERCTTER_APPLICATION('Property','Value',...) creates a new HMMERCTTER_APPLICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HMMerCTTer_Application_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HMMerCTTer_Application_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HMMerCTTer_Application

% Last Modified by GUIDE v2.5 14-May-2014 11:08:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HMMerCTTer_Application_OpeningFcn, ...
                   'gui_OutputFcn',  @HMMerCTTer_Application_OutputFcn, ...
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
end

% --- Executes just before HMMerCTTer_Application is made visible.
function HMMerCTTer_Application_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% varargin   command line arguments to HMMerCTTer_Application (see VARARGIN)
%HMMerCTTer_Training(Output_Folder,TreeFile,ApSeqFile,TrSeqFile,Num_min_elem,Alfa,Aligment_Program);
%HMMerCTTer_Application(Output_Folder,ApSeqFile,Aligment_Program,Prefix);
global FolderClustering;
global FolderClassification;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Folder_Application;
global Folder_Training;
global Folder_Group;
global Folder_Fetching;
global Folder_MSA;
global Folder_Hmmr_Build;
global Folder_Hmmr_Search;
global Dir;
global Index;
global Iter;
global FP;

%%%%%%%%%%%%%% The program indicates it enters the target phase. %%%%%%%%%%
prompt = ['The clusters have been succesfully determined and these will '...
    'now be used for screening of your target sequences. This will take '...
    'a while since the classifier will be iteratively updated until '...
    'convergence and since it requires fetching positive sequences, '...
    'alignment and HMMer profiling. Please be patient, HMMer-CTTer will be back!'];
dlg_title = 'Information';
h = warndlg(prompt,dlg_title); 

Folder_Training=[FolderClustering, '/Training_Output'];
rehash();
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% make Directories %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Folder_Application=[FolderClassification, '/Application'];
system(['mkdir ' Folder_Application]);

Folder_Group='Groups';              system(['mkdir ' Folder_Application '/' Folder_Group]');
Folder_Fetching='Fetching';          system(['mkdir ' Folder_Application '/' Folder_Fetching]');

if isequal(Aligment_Program,'Mafft')
Folder_MSA='MSA_M'; 
elseif isequal(Aligment_Program,'T-coffee')
    Folder_MSA='MSA_T'; 
end
   system(['mkdir ' Folder_Application '/' Folder_MSA]);
   
Folder_Hmmr_Build='Hmmr-Build';       system(['mkdir ' Folder_Application '/' Folder_Hmmr_Build]);
Folder_Hmmr_Search='Hmmr-Search';     system(['mkdir ' Folder_Application '/' Folder_Hmmr_Search]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Dir = dir([Folder_Training '/Groups/' Prefix '*.txt']);

%%%%%%%%%%%%%%%% Save Group Training %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rehash();
unix (['cp -r ' Folder_Training '/' Folder_Group ' ' Folder_Application]);

for i=1:length(Dir)
    fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,i,[]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FP = test_Application(FolderClustering,Folder_Application,ApSeqFile,Prefix,Aligment_Program,[]);
Iter=1;
Index=1;

 while ~exist([Folder_Application '/' Folder_Group '/' Prefix num2str(Index) '.txt'],'file') && Index < length(Dir)
          Index= Index + 1;
 end

[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);

actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);

set(handles.bPrevious,'Enable','off');
set(handles.bOriginal,'Enable','off'); 

% Choose default command line output for HMMerCTTer_Application
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HMMerCTTer_Application wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = HMMerCTTer_Application_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in bDiscard.
function bDiscard_Callback(hObject, eventdata, handles)
global Aligment_Program;
global Prefix;
global Folder_Application;
global Folder_Group;
global Folder_Fetching;
global Folder_MSA;
global Folder_Hmmr_Build;
global Folder_Hmmr_Search;
global Index;
global Iter;
global Dir;
b_discard = questdlg('Are you sure you want to discard this group?','Discard Group','No','Yes','Yes');


if strcmp(b_discard,'Yes')==1

   myFileName=[Prefix num2str(Index) '.txt'];
   File_Group = [Folder_Application '/' Folder_Group '/' myFileName];
   File_Group_temp = [Folder_Application '/' Folder_Group '/Temp_' myFileName];
   File_fetching = [Folder_Application '/' Folder_Fetching '/fetching_' myFileName];
        if isequal(Aligment_Program,'Mafft')
            File_MSA = [Folder_Application '/' Folder_MSA '/Mafft_' myFileName]; 
        elseif isequal(Aligment_Program,'T-coffee')
            File_MSA = [Folder_Application '/' Folder_MSA '/TCoffee_' myFileName]; 
        end
   File_hmmrB=[Folder_Application '/' Folder_Hmmr_Build '/hmm_' myFileName];
   File_hmmrS=[Folder_Application '/' Folder_Hmmr_Search '/hmmS_' myFileName];
   File_hmmrS_all=[Folder_Application '/' Folder_Hmmr_Search '/hmmS_all_' myFileName];
   
   %%%%%%%%%%%%%%%% Delete all Group_*.txt in Dir_preTraining %%%%%%%%%%%%%%%%
   if exist(File_Group,'file'), delete(File_Group); end
   if exist(File_Group_temp,'file'), delete(File_Group_temp); end
   if exist(File_fetching,'file'), delete(File_fetching); end
   if exist(File_MSA,'file'), delete(File_MSA); end
   if exist(File_hmmrB,'file'), delete(File_hmmrB); end
   if exist(File_hmmrS,'file'), delete(File_hmmrS); end
   if exist(File_hmmrS_all,'file'), delete(File_hmmrS_all); end    

Index=Index+1;
while ~exist([Folder_Application '/' Folder_Group '/' Prefix num2str(Index) '.txt'],'file') && Index < length(Dir)
          Index= Index + 1;
end
Iter=1;
    if Index <= length(Dir)
        set(handles.bPrevious,'Enable','off');
        set(handles.bOriginal,'Enable','off');
        [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
        actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
    else
        close all;
        fn_Create_GraphicScoreFiles(Folder_Application,Prefix);
        fn_checkDuplicate(Folder_Application,Prefix)
        msgbox('The classification phase finished successfully.','Analysis finished');
    end    
end
end

% --- Executes on button press in bAccept.
function bAccept_Callback(hObject, eventdata, handles)
global Folder_Application;
global Folder_Group;
global Prefix;
global Dir;
global Index;
global Iter;
global FP;

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Sure Accept Group %%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ans = questdlg('Are you sure you want to accept this group?','Accept group','No','Yes','Yes');  

if (strcmp(Ans,'Yes'))==1
    Index=Index+1;
    while ~exist([Folder_Application '/' Folder_Group '/' Prefix num2str(Index) '.txt'],'file') && Index < length(Dir)
          Index= Index + 1;
    end
    Iter=1;
    FP=0;

    if Index <= length(Dir)
        set(handles.bPrevious,'Enable','off');
        set(handles.bOriginal,'Enable','off');

        [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
        actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
    else
        close all;
        fn_Create_GraphicScoreFiles(Folder_Application,Prefix);
        fn_checkDuplicate(Folder_Application,Prefix);
        msgbox('The classification phase finished successfully.','Analysis finished');
    end
end
end

% --- Executes on button press in bMAS_uno.
function bMAS_uno_Callback(hObject, eventdata, handles)
global FolderClustering;
global Folder_Application;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Index;
global Iter;
global FP;

Iter=Iter+1;

set(handles.bPrevious,'Enable','on');
set(handles.bOriginal,'Enable','on');

Button='masUNO';
[FP, SeqAssig] = test_Application(FolderClustering, Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button);
if isequal(SeqAssig, 'Yes')
    Iter=Iter - 1;
    errordlg('This action cannot be done because the sequences to be added are already assigned to other groups.','Warning');
    if Iter == 1
        set(handles.bPrevious,'Enable','off');
        set(handles.bOriginal,'Enable','off');
    end
else
[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
end

end

% --- Executes on button press in bMAS_diez.
function bMAS_diez_Callback(hObject, eventdata, handles)
global FolderClustering;
global Folder_Application;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Index;
global Iter;
global FP;

Iter=Iter+1;

set(handles.bPrevious,'Enable','on');
set(handles.bOriginal,'Enable','on');

Button='masDIEZ';
[FP, SeqAssig] = test_Application(FolderClustering, Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button);
if isequal(SeqAssig, 'Yes')
   Iter=Iter - 1;
   errordlg('This action cannot be done because the sequences to be added are already assigned to other groups.','Warning');
   if Iter == 1
        set(handles.bPrevious,'Enable','off');
        set(handles.bOriginal,'Enable','off');
   end
else
[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
end

end

% --- Executes on button press in bHigher_Derivative.
function bHigher_Derivative_Callback(hObject, eventdata, handles)
global FolderClustering;
global Folder_Application;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Index;
global Iter;
global FP;

Iter=Iter+1;

set(handles.bPrevious,'Enable','on');
set(handles.bOriginal,'Enable','on');

Button='higherDER';
[FP,SeqAssig] = test_Application(FolderClustering, Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button); 
if isequal(SeqAssig, 'Yes')
    Iter=Iter - 1;
    errordlg('This action cannot be done because the sequences to be added are already assigned to other groups.','Warning');
    if Iter == 1
        set(handles.bPrevious,'Enable','off');
        set(handles.bOriginal,'Enable','off');
    end
else
[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
end

end

% --- Executes on button press in bManual_Sel.
function bManual_Sel_Callback(hObject, eventdata, handles)
global FolderClustering;
global Folder_Application;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Index;
global Iter;
global FP;
global pt_horizontal;

Iter=Iter+1;

set(handles.bPrevious,'Enable','on');
set(handles.bOriginal,'Enable','on');

Button='manualSELECTION';
[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
if isempty(pt_horizontal)  
    pt_horizontal = min(Score_group);
elseif  pt_horizontal > min(Score_group)
    errordlg('This action cannot be done because the group loses sequences.','Warning');
    return,
end

[FP, SeqAssig] = test_Application(FolderClustering,Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button,pt_horizontal);
if isequal(SeqAssig, 'Yes')
    Iter=Iter - 1;
    errordlg('This action cannot be done because the sequences to be added are already assigned to other groups.','Warning');
    if Iter == 1
        set(handles.bPrevious,'Enable','off');
        set(handles.bOriginal,'Enable','off');
    end
else
   [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
   actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
end

end

% --- Executes on button press in bPrevious.
function bPrevious_Callback(hObject, eventdata, handles)
global FolderClustering;
global Folder_Application;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Index;
global Iter;
global FP;

Iter=Iter-1;

Button='Previous';
if Iter <=1
    bOriginal_Callback(hObject, eventdata, handles);
    set(handles.bPrevious,'Enable','off');
    set(handles.bOriginal,'Enable','off');
else
    FP = test_Application(FolderClustering, Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button);
end

[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
end

% --- Executes on button press in bOriginal.
function bOriginal_Callback(hObject, eventdata, handles)
global FolderClustering;
global Folder_Training;
global Folder_Application;
global Folder_Group;
global Folder_Hmmr_Build;
global Folder_Hmmr_Search;
global ApSeqFile;
global Aligment_Program;
global Prefix;
global Index;
global Iter;
global FP;

Iter=Iter+1;
set(handles.bPrevious,'Enable','off');
set(handles.bOriginal,'Enable','off');

Group=[Prefix num2str(Index) '.txt'];


copyfile([Folder_Training '/' Folder_Group '/' Group],[Folder_Application '/' Folder_Group '/' Group]);
fn_run_program(Folder_Application,Prefix,ApSeqFile,Aligment_Program,Index,[]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Button='Original';
FP = test_Application(FolderClustering, Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button);

[Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);

actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);
end

function actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group)
global Folder_Training;
global Prefix;
global Index;
global Iter;
global FP;
global pt_horizontal;
global Dialogo;

cla reset;


handles.output = hObject;
handles.done=0;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Logo %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
axes(handles.axes2); 
handles.imagen=imread('LogoHMMerCTTer.png'); 
imagesc(handles.imagen); 
axis off 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Axes 3 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Folder_dendroscope=[Folder_Training '/Dendroscope'];
File_dendroscope_png=['Dendroscope_' Prefix num2str(Index) '.png'];

File_dendroscope_png=[Folder_dendroscope '/' File_dendroscope_png];
[Imagen_recortada]=fn_recortar_imagen(File_dendroscope_png);

axes(handles.axes3);
imshow(Imagen_recortada);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% Axes 1 %%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Index_group=sort(Index_group);
axes(handles.axes1);
setappdata(0,'figureHandle',gcf);
setappdata(gcf,'axesHandle1',handles.axes1);
figureHandle = getappdata(0,'figureHandle');
axesHandle1 = getappdata(figureHandle,'axesHandle1');

plot(Score_all,'*');
hold on
plot(Derivada_all,'r');
hold on
plot(Index_group,Score_group,'go')
xPos = max(Index_group);
yPos = min(Score_group);
hold on
h = line(get(gca,'xlim'), [yPos yPos],...
    'color', 'm', ...
    'linewidth', 2, ...
    'ButtonDownFcn', @startDragFcn);
hold on
i = line([xPos xPos],get(gca,'ylim'),...
    'color', 'm', ...
    'linewidth', 1, ...
    'ButtonDownFcn', @startDragFcn);    
hold off

titulo = title(['Score Group']);
leyenda1 = 'Score';
leyenda2 = 'Derivative';
leyenda3= ['Score group ' num2str(Index)];
leyenda = legend(leyenda1,leyenda2,leyenda3);

set(titulo,'FontSize',16);
set(leyenda,'FontName','arial','FontUnits','points','FontSize',16,...
    'FontWeight','normal','FontAngle','normal');   

set(gcf,'WindowButtonUpFcn',@stopDragFcn)
%%%%%%%%%%%%%%%%%%%%%%%%%% FP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if FP == 1 %There are FP for last buttom executed
        user_question(hObject, eventdata, handles);
end
%%%%%%%%%%%%%%%%%%%%%%%%%% Buttom %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
set(handles.bAccept,'Enable','on');
set(handles.bDiscard,'Enable','on');
set(handles.bManual_Sel,'Enable','on');
set(handles.bHigher_Derivative,'Enable','on');
set(handles.bMAS_diez,'Enable','on');
set(handles.bMAS_uno,'Enable','on');
if Iter <=1
set(handles.bPrevious,'Enable','off');
set(handles.bOriginal,'Enable','off');
end
%%%%%%%%%%%%%%%%%%%%%%%% Function Interactive %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startDragFcn(varargin)
set(gcf, 'WindowButtonMotionFcn',@dragginFcn)
end

function dragginFcn(varargin)
pt_horizontal = get(axesHandle1, 'CurrentPoint');
set(h, 'yData', pt_horizontal(:,2)');
pt_horizontal =  pt_horizontal(1,2);
pt_vertical = get(axesHandle1, 'CurrentPoint');
set(i, 'xData', pt_vertical(:,1)');
end

function stopDragFcn(varargin)
set(gcf, 'WindowButtonMotionFcn','')
end

handles.output = hObject;      
guidata(hObject, handles);     
end

function user_question(hObject, eventdata, handles)
global Prefix;
global Index;
global Iter;
global Folder_Application;
global FolderClustering;
global ApSeqFile;
global Aligment_Program;     
global FP;

prompt = ['The inclusion of one or more putative false negatives has resulted in ' ...
        'an increment of information. The novel HMMer profile detects additional positives.' ...
        'There migth be real positives or false positives. False positives will result ' ...
        'eventually in seed contamination, which you will be able to detect in subsequent iterations.' ...
        'Do you wish accept the novel positives or go to back to the previous group definition?'];
dlg_title = 'Warning';
answer = questdlg(prompt,dlg_title,'Accept Positives','Previous', 'Previous');

if (strcmp(answer,'Previous'))==1
    if Iter == 2
      Iter = Iter-1;
      bOriginal_Callback(hObject, eventdata, handles);  
    else
        bPrevious_Callback(hObject, eventdata, handles);
    end
else % Accept Positives
     Iter=Iter + 1;
     Button='FPositive';
     [FP, SeqAssig] = test_Application(FolderClustering, Folder_Application,ApSeqFile,Prefix,Aligment_Program,Index,Button);
     if isequal(SeqAssig, 'Yes')   
     errordlg('This action cannot be done because the sequences to be added are already assigned to other groups. The Previous button is running.','Warning');
     bPrevious_Callback(hObject, eventdata, handles);
     else
     [Score_all,Derivada_all,Index_group,Score_group]=fn_graphic_index(Folder_Application,Prefix,Index);
     actualiza_graficos(hObject, eventdata, handles,Score_all,Derivada_all,Index_group,Score_group);   
     end
end
end
