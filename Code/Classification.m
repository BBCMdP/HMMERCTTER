function varargout = Classification(varargin)
% CLASSIFICATION MATLAB code for Classification.fig
%      CLASSIFICATION, by itself, creates a new CLASSIFICATION or raises the existing
%      singleton*.
%
%      H = CLASSIFICATION returns the handle to a new CLASSIFICATION or the handle to
%      the existing singleton*.
%
%      CLASSIFICATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLASSIFICATION.M with the given input arguments.
%
%      CLASSIFICATION('Property','Value',...) creates a new CLASSIFICATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Classification_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Classification_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Classification

% Last Modified by GUIDE v2.5 08-Aug-2014 15:06:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Classification_OpeningFcn, ...
                   'gui_OutputFcn',  @Classification_OutputFcn, ...
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


% --- Executes just before Classification is made visible.
function Classification_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% varargin   command line arguments to Classification (see VARARGIN)
global Aligment_Program;

warning off;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Logo %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
handles.output = hObject;
axes(handles.axes1); 
handles.imagen=imread('LogoHMMerCTTer.png'); 
imagesc(handles.imagen); 
axis off 

Aligment_Program= 'Mafft';

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = Classification_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


% --- Executes on button press in Open_FileClassification.
function Open_FileClassification_Callback(hObject, eventdata, handles)
global Ap_Seq_File;

[File, pathname] = uigetfile('*.txt', 'Select Application Sequences file in fasta format');
if ~isequal(File,0)
Ap_Seq_File=[pathname File];
set(handles.FileClassification,'String', Ap_Seq_File);
end

% --- Executes on button press in Accept.
function Accept_Callback(hObject, eventdata, handles)
global FolderClustering;
global FolderClassification;
global Ap_Seq_File;
global ApSeqFile;
global Aligment_Program;
global Prefix;
Prefix='Group_';

if ~exist(FolderClassification)
    mkdir(FolderClassification);
end

diary([FolderClassification '/Matlab_output_Classification']);
disp('Input parameters:')
disp(FolderClustering);
disp(Ap_Seq_File);

ApSeqFile = [FolderClassification '/ApSeqFile'];

%%%%%%%%%%%%%%%%%%%%%% Join Training file and Application File %%%%%%%%
Tr_Seq_File = [FolderClustering '/TrSeqFile'];   
Command=['cat ' Tr_Seq_File ' ' Ap_Seq_File '> ' ApSeqFile];
[Status,Result]=system(Command);

if Status==0
	disp(['Application File ' ApSeqFile ' generated!!']);
else
        disp(['Error Application File ' ApSeqFile ' - ' Result]);
end    

ApSeqFile_Index = [FolderClassification '/ApSeqFile.index'];

if exist(ApSeqFile_Index,'file')
    delete(ApSeqFile_Index);
end
close all; 

HMMerCTTer_Application(FolderClustering, FolderClassification,ApSeqFile,Aligment_Program,Prefix);


function FolderClustering_Callback(hObject, eventdata, handles)
global FolderClustering;

FolderClustering=get(hObject,'String'); 
set(handles.FolderClustering,'String',FolderClustering); 

FolderClustering=strcat('../',FolderClustering);

% --- Executes during object creation, after setting all properties.
function FolderClustering_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FileClassification_Callback(hObject, eventdata, handles)
global ApSeqFile;

ApSeqFile=get(hObject,'String'); 
Folder = cd('./'); 
ApSeqFile=strcat(Folder,'/',ApSeqFile);
set(handles.FileClassification,'String',ApSeqFile); 
guidata(hObject,handles); 

% --- Executes during object creation, after setting all properties.
function FileClassification_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Open_FolderClustering.
function Open_FolderClustering_Callback(hObject, eventdata, handles)
global FolderClustering;

FolderClustering=strcat('../',FolderClustering);
FolderClustering = uigetdir(FolderClustering,'Select Output Folder generated in Clustering phase');
if ~isequal(FolderClustering,0)
set(handles.FolderClustering,'String',FolderClustering); 
end


function FolderClassification_Callback(hObject, eventdata, handles)
global FolderClassification;

FolderClassification=get(hObject,'String'); 
set(handles.FolderClassification,'String',FolderClassification); 

FolderClassification=strcat('../',Folder_Classification);


% --- Executes during object creation, after setting all properties.
function FolderClassification_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Create_FolderClassification.
function Create_FolderClassification_Callback(hObject, eventdata, handles)
global FolderClassification;

FolderClassification=strcat('../',FolderClassification);
FolderClassification = uigetdir(FolderClassification,'Select Output folder - Classification Phase');

if ~isequal(FolderClassification,0)
	set(handles.FolderClassification,'String',FolderClassification); 
end
