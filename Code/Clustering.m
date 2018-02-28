function varargout = Clustering(varargin)
% CLUSTERING MATLAB code for Clustering.fig
%      CLUSTERING, by itself, creates a new CLUSTERING or raises the existing
%      singleton*.
%
%      H = CLUSTERING returns the handle to a new CLUSTERING or the handle to
%      the existing singleton*.
%
%      CLUSTERING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLUSTERING.M with the given input arguments.
%
%      CLUSTERING('Property','Value',...) creates a new CLUSTERING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Clustering_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Clustering_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Clustering

% Last Modified by GUIDE v2.5 08-Aug-2014 14:15:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Clustering_OpeningFcn, ...
                   'gui_OutputFcn',  @Clustering_OutputFcn, ...
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


% --- Executes just before Clustering is made visible.
function Clustering_OpeningFcn(hObject, eventdata, handles, varargin)
warning off;

%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% Logo %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
handles.output = hObject;
axes(handles.axes1); 
handles.imagen=imread('LogoHMMerCTTer.png'); 
imagesc(handles.imagen); 
axis off 

global Num_min_elem;
global Alfa;
global Aligment_Program;

set(handles.Num_min_elem,'String',8);

Alfa= 0; 
Num_min_elem=get(handles.Num_min_elem,'String');
Num_min_elem=str2double(Num_min_elem);
Aligment_Program= 'Mafft';

guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = Clustering_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Open_TreeFile.
function Open_TreeFile_Callback(hObject, eventdata, handles)
global Tree_File;

[File, pathname] = uigetfile('*.tree', 'Select file in newick format');

if ~isequal(File,0)
	Tree_File=[pathname File];
	set(handles.Tree_File,'String', Tree_File);
end



% --- Executes on button press in Open_Tr_Seq_File.
function Open_Tr_Seq_File_Callback(hObject, eventdata, handles)
global Tr_Seq_File;

[File, pathname] = uigetfile('*.fsa', 'Select Training Sequences File in fasta format');

if ~isequal(File,0)
	Tr_Seq_File=[pathname File];
	set(handles.Tr_Seq_File,'String',Tr_Seq_File);
end


function Tr_Seq_File_Callback(hObject, eventdata, handles)
global Tr_Seq_File;

Tr_Seq_File=get(hObject,'String'); 
Folder = cd('./'); 
Tr_Seq_File=strcat(Folder,'/',Tr_Seq_File);
set(handles.Tr_Seq_File,'String',Tr_Seq_File); 

guidata(hObject,handles); 


% --- Executes during object creation, after setting all properties.
function Tr_Seq_File_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Tree_File_Callback(hObject, eventdata, handles)
global Tree_File;

Tree_File=get(hObject,'String'); 
Folder = cd('./'); 
Tree_File=strcat(Folder,'/',Tree_File);
set(handles.Tree_File,'String',Tree_File); 

guidata(hObject,handles); 

% --- Executes during object creation, after setting all properties.
function Tree_File_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Create_FolderClustering.
function Create_FolderClustering_Callback(hObject, eventdata, handles)
global Folder_Clustering;

Folder_Clustering=strcat('../',Folder_Clustering);
Folder_Clustering = uigetdir(Folder_Clustering,'Select Output folder');
if ~isequal(Folder_Clustering,0)
	set(handles.Folder_Clustering,'String',Folder_Clustering); 
end

% --- Executes on button press in Accept.
function Accept_Callback(hObject, eventdata, handles)
global Tree_File;
global Tr_Seq_File;
global TreeFile;
global TrSeqFile;
global Folder_Clustering;
global Num_min_elem;
global Alfa;
global Aligment_Program;

close all;

if (isempty(Tree_File)==1 || isempty(Tr_Seq_File)==1 ||...
    isempty(Folder_Clustering)==1 || isempty(Num_min_elem)==1 || isempty(Alfa)==1 ||...
    isempty(Aligment_Program)==1 )
    
    clear all; clc; 
    errordlg('Missing parameters','Error');
else
    if ~exist(Folder_Clustering,'dir')
        mkdir(Folder_Clustering);
    end
    
    diary([Folder_Clustering '/Matlab_output_Clustering']);
    
    disp('Input parameters:')
    disp(Tree_File);
    disp(Tr_Seq_File);

    TrSeqFile = [Folder_Clustering,'/TrSeqFile'];
    
    [TreeFile] = fn_dendroscope_midpoint(Folder_Clustering,Tree_File);

    copyfile(Tr_Seq_File, TrSeqFile);
    
    display(Num_min_elem);
    display(Alfa);
    display(Aligment_Program);
    display(TreeFile);
    display(TrSeqFile);
    close all; 
    
    HMMerCTTer_Training(Folder_Clustering,TreeFile,TrSeqFile,Num_min_elem,Alfa,Aligment_Program);
end


function Folder_Clustering_Callback(hObject, eventdata, handles)
global Output_Folder;

Output_Folder=get(hObject,'String'); 
set(handles.Output_Folder,'String',Output_Folder); 

Output_Folder=strcat('../',Output_Folder);
guidata(hObject,handles); 

% --- Executes during object creation, after setting all properties.
function Folder_Clustering_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Num_min_elem_Callback(hObject, eventdata, handles)
global Num_min_elem;

Num_min_elem =get(hObject,'String'); 
Num_min_elem=str2double(Num_min_elem);

% --- Executes during object creation, after setting all properties.
function Num_min_elem_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

