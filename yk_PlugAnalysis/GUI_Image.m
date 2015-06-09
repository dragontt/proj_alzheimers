function varargout = GUI_Image(varargin)
% GUI_IMAGE MATLAB code for GUI_Image.fig
%      GUI_IMAGE, by itself, creates a new GUI_IMAGE or raises the existing
%      singleton*.
%
%      H = GUI_IMAGE returns the handle to a new GUI_IMAGE or the handle to
%      the existing singleton*.
%
%      GUI_IMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_IMAGE.M with the given input arguments.
%
%      GUI_IMAGE('Property','Value',...) creates a new GUI_IMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Image_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Image_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Image

% Last Modified by GUIDE v2.5 15-Aug-2013 20:17:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Image_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Image_OutputFcn, ...
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


% --- Executes just before GUI_Image is made visible.
function GUI_Image_OpeningFcn(hObject, eventdata, handles, im)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Image (see VARARGIN)

% Choose default command line output for GUI_Image
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Image wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Image_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

global im V; 

set(handles.StackNum,'String',['Stack 1/',num2str(size(im,3))]);
axes(handles.axes_OriginalImage);
imshow(uint8(im(:,:,1))); 
axes(handles.axes_ProcessedImage);
imshow(V(:,:,1));


% --- Executes on slider movement.
function slider_zDir_Callback(hObject, eventdata, handles)
% hObject    handle to slider_zDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global im V; 

numSlice=get(handles.slider_zDir,'Value');
numSlice=round(numSlice*(size(V,3)-1))+1;
set(handles.StackNum,'String',['Stack ',num2str(numSlice),'/',num2str(size(im,3))]);
drawnow;
axes(handles.axes_OriginalImage);
imshow(uint8(im(:,:,numSlice))); 
axes(handles.axes_ProcessedImage);
imshow(V(:,:,numSlice));


% --- Executes during object creation, after setting all properties.
function slider_zDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider_zDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
