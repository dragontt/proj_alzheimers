function varargout = GUI_Panel(varargin)
% GUI_PANEL MATLAB code for GUI_Panel.fig
%      GUI_PANEL, by itself, creates a new GUI_PANEL or raises the existing
%      singleton*.
%
%      H = GUI_PANEL returns the handle to a new GUI_PANEL or the handle to
%      the existing singleton*.
%
%      GUI_PANEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_PANEL.M with the given input arguments.
%
%      GUI_PANEL('Property','Value',...) creates a new GUI_PANEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Panel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Panel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Panel

% Last Modified by GUIDE v2.5 04-Dec-2013 10:52:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_Panel_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_Panel_OutputFcn, ...
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


% --- Executes just before GUI_Panel is made visible.
function GUI_Panel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Panel (see VARARGIN)

% Choose default command line output for GUI_Panel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Panel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Panel_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

msg=warndlg('Initializing Program...','WARNING');

addpath(genpath('./functions/'));

% Enbale parallel computing
if matlabpool('size')==0
    matlabpool open;
end

% Compile c file msfm3d.c
cd('functions');
clear msfm3d
mex('msfm3d.c');
cd ..;

set(handles.edit_Status,'String','Parallel Computing Enabled; File msfm3d.c Compiled');

delete(msg);

%%%%%%%%%%%%%%%%%%%%%%% Image Preparation Starts %%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in pushbutton_LoadTIF.
function pushbutton_LoadTIF_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_LoadTIF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im imOriginal fName;
handles.output=hObject;

% Import TIF image file
[fn pn]=uigetfile('*.tif','Browse');
if isequal(fn,0);
    msgbox(sprintf('Import TIF Image Canceled!'),'Error','Error');
    set(handles.edit_Status,'String','TIF Image Import Failed');
    return;
end
FileName=strcat(pn,fn);
s=dir(FileName);
if s.bytes>1024^3
    msgbox(sprintf('Cannot Import Image File Larger Than 1 GB!'),'Error','Error');
    set(handles.edit_Status,'String','TIF Image Import Failed');
    return;
end
im=importtif(FileName);
imOriginal=im;
if length(size(im))>3
    msgbox(sprintf('Only Import 8bit TIF Image!\nPlease Reimport!'),'Error','Error');
    set(handles.edit_Status,'String','TIF Image Import Failed');
    return;
end
fName=fn;
set(handles.edit_Status,'String',...
    sprintf('TIF Image Imported. Image size: %d x %d x %d',...
    size(im,1),size(im,2),size(im,3)));


function edit_TopStackNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TopStackNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TopStackNum as text
%        str2double(get(hObject,'String')) returns contents of edit_TopStackNum as a double

global num_TopStack;
val=get(handles.edit_TopStackNum,'String');
num_TopStack=str2double(val);


% --- Executes during object creation, after setting all properties.
function edit_TopStackNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TopStackNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BottomStackNum_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BottomStackNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BottomStackNum as text
%        str2double(get(hObject,'String')) returns contents of edit_BottomStackNum as a double

global num_BottomStack;
val=get(handles.edit_BottomStackNum,'String');
num_BottomStack=str2double(val);


% --- Executes during object creation, after setting all properties.
function edit_BottomStackNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BottomStackNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_PickStack.
function pushbutton_PickStack_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_PickStack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Trim image in range

global im num_TopStack num_BottomStack;
im=im(:,:,num_TopStack:num_BottomStack);
set(handles.edit_Status,'String','Range of Stack Picked');



function edit_Status_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Status as text
%        str2double(get(hObject,'String')) returns contents of edit_Status as a double


% --- Executes during object creation, after setting all properties.
function edit_Status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%% Image Preparation Ends %%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%% Image Segmentation Starts %%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in checkbox_BkgdSubtr1.
function checkbox_BkgdSubtr1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BkgdSubtr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BkgdSubtr1

global flag_BkgdSubtr1;
if (get(hObject,'Value') == get(hObject,'Max'))
    flag_BkgdSubtr1=1;
else flag_BkgdSubtr1=0;
end


function edit_BkgdSubtr1X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BkgdSubtr1X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BkgdSubtr1X as text
%        str2double(get(hObject,'String')) returns contents of edit_BkgdSubtr1X as a double

global val_BkgdSubtr1;
val=get(handles.edit_BkgdSubtr1X, 'String');
val_BkgdSubtr1=str2double(val);


% --- Executes during object creation, after setting all properties.
function edit_BkgdSubtr1X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BkgdSubtr1X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_BkgdSubtr2.
function checkbox_BkgdSubtr2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_BkgdSubtr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_BkgdSubtr2

global flag_BkgdSubtr2;
if (get(hObject,'Value') == get(hObject,'Max'))
    flag_BkgdSubtr2=1;
else flag_BkgdSubtr2=0;
end

function edit_BkgdSubtr2X_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BkgdSubtr2X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BkgdSubtr2X as text
%        str2double(get(hObject,'String')) returns contents of edit_BkgdSubtr2X as a double

global val_BkgdSubtr2;
val=get(handles.edit_BkgdSubtr2X, 'String');
val_BkgdSubtr2=str2double(val);


% --- Executes during object creation, after setting all properties.
function edit_BkgdSubtr2X_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BkgdSubtr2X (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_GauBlur.
function checkbox_GauBlur_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_GauBlur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_GauBlur

global flag_GauBlur;
if (get(hObject,'Value') == get(hObject,'Max'))
    flag_GauBlur=1;
else flag_GauBlur=0;
end


function edit_GauBlurSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_GauBlurSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_GauBlurSize as text
%        str2double(get(hObject,'String')) returns contents of edit_GauBlurSize as a double

global val_GauBlur;
val=get(handles.edit_GauBlurSize, 'String');
val_GauBlur=str2double(val);


% --- Executes during object creation, after setting all properties.
function edit_GauBlurSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_GauBlurSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_thdAdapt.
function checkbox_thdAdapt_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_thdAdapt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_thdAdapt

global flag_thdAdapt;
if (get(hObject,'Value')==get(hObject,'Max'))
    flag_thdAdapt=1;
else flag_thdAdapt=0;
end


function edit_thdAdapt_ws_Callback(hObject, eventdata, handles)
% hObject    handle to edit_thdAdapt_ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_thdAdapt_ws as text
%        str2double(get(hObject,'String')) returns contents of edit_thdAdapt_ws as a double

global val_thdAdapt_ws;
val=get(handles.edit_thdAdapt_ws, 'String');
val_thdAdapt_ws=str2double(val);

% --- Executes during object creation, after setting all properties.
function edit_thdAdapt_ws_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_thdAdapt_ws (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_thdAdapt_os_Callback(hObject, eventdata, handles)
% hObject    handle to edit_thdAdapt_os (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_thdAdapt_os as text
%        str2double(get(hObject,'String')) returns contents of edit_thdAdapt_os as a double

global val_thdAdapt_os;
val=get(handles.edit_thdAdapt_os, 'String');
val_thdAdapt_os=str2double(val);

% --- Executes during object creation, after setting all properties.
function edit_thdAdapt_os_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_thdAdapt_os (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in checkbox_imFill.
function checkbox_imFill_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_imFill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_imFill

global flag_imFill;
if (get(hObject,'Value') == get(hObject,'Max'))
    flag_imFill=1;
else flag_imFill=0;
end

function edit_HoleFill_Callback(hObject, eventdata, handles)
% hObject    handle to edit_HoleFill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_HoleFill as text
%        str2double(get(hObject,'String')) returns contents of edit_HoleFill as a double

global val_HoleFill;
val=get(handles.edit_HoleFill,'String');
val_HoleFill=str2double(val);

% --- Executes during object creation, after setting all properties.
function edit_HoleFill_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_HoleFill (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox_ElimSmallObj.
function checkbox_ElimSmallObj_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_ElimSmallObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_ElimSmallObj

global flag_ElimSmallObj;
if (get(hObject,'Value') == get(hObject,'Max'))
    flag_ElimSmallObj=1;
else flag_ElimSmallObj=0;
end


function edit_ElimSmallObj_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ElimSmallObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ElimSmallObj as text
%        str2double(get(hObject,'String')) returns contents of edit_ElimSmallObj as a double

global val_ElimSmallObj;
val=get(handles.edit_ElimSmallObj, 'String');
val_ElimSmallObj=str2double(val);

% --- Executes during object creation, after setting all properties.
function edit_ElimSmallObj_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ElimSmallObj (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ImSeg.
function pushbutton_ImSeg_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ImSeg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im V;
global flag_BkgdSubtr1 val_BkgdSubtr1 flag_BkgdSubtr2 val_BkgdSubtr2;
global flag_GauBlur val_GauBlur;
global flag_thdAdapt val_thdAdapt_ws val_thdAdapt_os;
global flag_imFill val_HoleFill;
global flag_ElimSmallObj val_ElimSmallObj;

V=im;
wb=waitbar(0,'Image Segmentation Processing');

% Background subtraction using scale space method
if flag_BkgdSubtr1
    if isempty(val_BkgdSubtr1)
        val_BkgdSubtr1=3;
    end
    V=backgndsubtraction(V,'ScaleSpace',val_BkgdSubtr1);
end
if flag_BkgdSubtr2
    if isempty(val_BkgdSubtr2)
        val_BkgdSubtr2=40;
    end
    V=backgndsubtraction(V,'ScaleSpace',val_BkgdSubtr2);
end
waitbar(1/5);

% Image filtering using 3d gaussian blurring
if flag_GauBlur
    if isempty(val_GauBlur)
        h_gau=fspecial3('gaussian',[5,5,5]);
    else h_gau=fspecial3('gaussian',[val_GauBlur,val_GauBlur,val_GauBlur]);
    end
    V=imfilter(V,h_gau);
end
waitbar(2/5);

% Binarize image using adaptive thresholding
if flag_thdAdapt
    thdMethod='adaptive';
    if isempty(val_thdAdapt_ws)
        windowSize=85;
    else windowSize=val_thdAdapt_ws;
    end
    if isempty(val_thdAdapt_os)
        offset=-9;
    else offset=val_thdAdapt_os-9;
    end
    V=imthreshold3(V,windowSize,offset);
end
waitbar(3/5);

% Hole filling using Matlab imfill
if flag_imFill
    if isempty(val_HoleFill)
        val_HoleFill=100;
    end
    V=imholefill(V,val_HoleFill);
end
waitbar(4/5);

% Eliminate small connected objects
if flag_ElimSmallObj
    if isempty(val_ElimSmallObj)
        V=elimsobj(V,26,1000);
    else V=elimsobj(V,26,val_ElimSmallObj);
    end
end
waitbar(5/5);
delete(wb);

% % Structure parameters
% Param=struct;
% global flag_BkgdSubtr1 val_BkgdSubtr1 flag_BkgdSubtr2 val_BkgdSubtr2;
% global flag_GauBlur val_GauBlur;
% global flag_thdVarWt flag_thdAbs val_thdVarWt val_thdAbs;
% global flag_thdAdapt val_thdAdapt_ws val_thdAdapt_os;
% global flag_imFill;
% global flag_ElimSmallObj val_ElimSmallObj;
% Param.flag_BackgroundSubtraction_ScaleSpace=flag_BkgdSubtrl

% Trigger another GUI to show original vs. processed image
GUI_Image;

%%%%%%%%%%%%%%%%%%%%% Image Segmentation Ends %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%% Automated Tracing Starts %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes on button press in checkbox_VisualSkel.
function checkbox_VisualSkel_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_VisualSkel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_VisualSkel

global flag_VisualSkel;
if (get(hObject,'Value')==get(hObject,'Max'))
    flag_VisualSkel=1;
else flag_VisualSkel=0;
end

% --- Executes on button press in checkbox_gotracer.
function checkbox_gotracer_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_gotracer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_gotracer

global flag_GoTracer;
if (get(hObject,'Value')==get(hObject,'Max'))
    flag_GoTracer=1;
else flag_GoTracer=0;
end

% --- Executes on button press in pushbutton_SaveData.
function pushbutton_SaveData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SaveData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global fileName dirName;
[fileName,dirName]=uiputfile('*.*');


% --- Executes on button press in pushbutton_StartAutoTracing.
function pushbutton_StartAutoTracing_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StartAutoTracing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global im imOriginal V S SS fName fileName dirName;
global flag_GoTracer flag_VisualSkel num_TopStack num_BottomStack;

if isempty(dirName)
    msgbox(sprintf('Please Choose Save Directory!'),'Error','Error');
    set(handles.edit_Status,'String','Choose Save Directory Failed');
    return;
end

tStart=tic;
set(handles.edit_Status,'String','Auto Tracing in Progress');
msg=warndlg('Auto  Tracing  in  Progress...','WARNING');

% Split master volume into 16 subvolumes
dim=size(im);
[CCgp,xyDivCoord]=getSubVolume(V,dim);
Sgp=cell(1,size(CCgp,2));

parfor iPar=1:size(CCgp,2)
    % Split into subvolumes
    tmpV=getCCgpVolume(CCgp,iPar);
    
    % Distance to vessel boundary
    BoundaryDistance=double(bwdist(imcomplement(tmpV)));
    
    % Get maximum distance value, which is used as starting point of the
    % first skeleton branch
    [SourcePoint,maxD]=maxDistancePoint(BoundaryDistance,tmpV);
    
    % Make a fastmarching speed image from the distance image
    SpeedImage=(BoundaryDistance/maxD).^4;
    SpeedImage(SpeedImage==0)=1e-10;
    
    SkeletonSegments=cell(1,1000);
    tmpS=[]; tmpSS=[];
    
    % Number of skeleton iterations
    itt=0;
    while true
        
        % Do fast marching using the maximum distance value in the image
        % and the points describing all found branches are sourcepoints.
        [T,Y]=msfm(SpeedImage, SourcePoint, false, false);
        
        % Trace a branch back to the used sourcepoints with Dijktra's shortest
        % path method
        StartPoint=maxDistancePoint(Y,tmpV);
        ShortestLine=shortestpath(T,StartPoint,SourcePoint,'simple');
        
        % Get the length of the new skeleton segment
        linelength=GetLineLength(ShortestLine);
        
        % Store the found branch skeleton
        itt=itt+1;
        SkeletonSegments{itt}=ShortestLine;
        
        % Add found branche to the list of fastmarching SourcePoints
        SourcePoint=[SourcePoint ShortestLine'];
        
        % Stop finding branches, if the lenght of the new branch is smaller
        % then the diameter of the largest vessel
        if linelength<maxD*1 % smaller tracing region requires larger weights; vice versa
            break;
        end
    end
    
    % Organize skeleton by deleting short segment, rearranging linepath
    % points, merging connected segment, shifting linepath points according
    % to the master volume coordinates
    SkeletonSegments=deleteShortSkel(SkeletonSegments);
    SkeletonSegments=SkeletonSegments(~cellfun('isempty',SkeletonSegments));
    if ~isempty(SkeletonSegments)
        tmpS=OrganizeSkeleton(SkeletonSegments);
        [tmpSS,~]=BuildTmpSkel(tmpS,0);
        [tmpS,~]=MergeSkel(tmpS,tmpSS);
        tmpS=shiftSkel(CCgp,tmpS,xyDivCoord,num_TopStack,iPar);
        Sgp{iPar}=tmpS;
    end
end

% Stitch subvolume skeletons and build structure
[S,maskS]=combineSubSkel(Sgp,CCgp);
S=stitchCCSkel(S,maskS,5);
[tmpSS,maskDel]=BuildTmpSkel(S,1,15);
[S,~]=MergeSkel(S,tmpSS,maskDel);
SS=BuildStructure(S);

% Merge neighbor nodes and rebuild structure
SS=MergeStructNodes(SS,10);
S=BuildSkelFromStruct(SS);
[tmpSS,~]=BuildTmpSkel(S,0);
[S,~]=MergeSkel(S,tmpSS);
% SS=BuildStructure(S);

% Map cropped volumes (8bit and binary vols) into original ones
im=imOriginal;
tmpV=false(size(im)); 
tmpV(:,:,num_TopStack:num_BottomStack)=V;
V=tmpV;

% Final clean up
S=FixSkelShift(S,bwdist(imcomplement(V)),5);
SS=BuildStructure(S);
SS=MergeStructNodes(SS,10);
S=BuildSkelFromStruct(SS);
[tmpSS,~]=BuildTmpSkel(S,0);
[S,~]=MergeSkel(S,tmpSS);
SS=BuildStructure(S);

% Display elapsed time
tElapsed=toc(tStart)/60;
set(handles.edit_Status,'String',...
    ['Program Elapsed Time : ',num2str(tElapsed),' mins']);
delete(msg);
msg=warndlg('Auto Tracing Done!');

% Save autotracing data in matlab structure format
dirName=char([dirName,'/']);
exportNameMatlab=strcat([dirName,fileName,'.mat']);
save(exportNameMatlab,'im','V','S','SS');

% Save data in gotracer format
if flag_GoTracer
    dimX=size(im,1); dimY=size(im,2); micronPerPixel=1;
    SVectorized=goTrace_toVectorized(fixPlistStructure(SS));
    GOTracerReadableFile=ExportToGOTracer(SVectorized,dimX,dimY,micronPerPixel,dirName);
    output=structToXMLPlist(GOTracerReadableFile);
    hSaveGoTracer=fopen(strcat([dirName,fileName,'.gotrace']),'w');
    fwrite(hSaveGoTracer,output);
    fclose(hSaveGoTracer);
end

% Visualize the vessels and skeletons
if flag_VisualSkel
    figure; visual3d(V,S,'random');
end
% waitbar(1,wb,'AutoTracing Done');

%%%%%%%%%%%%%%%%%%%%% Automated Tracing Ends %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
