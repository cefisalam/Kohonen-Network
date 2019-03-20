function varargout = GUI_Kohonen(varargin)
% GUI_KOHONEN MATLAB code for GUI_Kohonen.fig
%      GUI_KOHONEN, by itself, creates a new GUI_KOHONEN or raises the existing
%      singleton*.
%
%      H = GUI_KOHONEN returns the handle to a new GUI_KOHONEN or the handle to
%      the existing singleton*.
%
%      GUI_KOHONEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_KOHONEN.M with the given input arguments.
%
%      GUI_KOHONEN('Property','Value',...) creates a new GUI_KOHONEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_Kohonen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_Kohonen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_Kohonen

% Last Modified by GUIDE v2.5 19-Mar-2019 19:38:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_Kohonen_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_Kohonen_OutputFcn, ...
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


% --- Executes just before GUI_Kohonen is made visible.
function GUI_Kohonen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_Kohonen (see VARARGIN)

% Choose default command line output for GUI_Kohonen
handles.output = hObject;

% Set Handles
set(handles.Class1DataDoneText,'visible','off');
set(handles.Class2DataDoneText,'visible','off');
set(handles.TestDataDoneText,'visible','off');
set(handles.NetworkTrainedText,'visible','off');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_Kohonen wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_Kohonen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Class1DataButton.
function Class1DataButton_Callback(hObject, eventdata, handles)
% hObject    handle to Class1DataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select Class-I Data
[filename, pathname] = uigetfile({'*.txt','All Files'}, 'Select Class-I Data');
fileName = fullfile(pathname, filename);
[~,Name1] = fileparts(fileName);

% Load the Data
Data1 = load(fileName);

% Set Handles
handles.Class1 = Name1;
handles.Data1 = Data1;
set(handles.Class1DataDoneText,'visible','on');
guidata(hObject, handles)


% --- Executes on button press in Class2DataButton.
function Class2DataButton_Callback(hObject, eventdata, handles)
% hObject    handle to Class2DataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select Class-II Data
[filename, pathname] = uigetfile({'*.txt','All Files'}, 'Select Class-II Data');
fileName = fullfile(pathname, filename);
[~,Name2] = fileparts(fileName);

% Load the Data
Data2 = load(fileName);

% Set Handles
handles.Class2 = Name2;
handles.Data2 = Data2;
set(handles.Class2DataDoneText,'visible','on');
guidata(hObject, handles)


% --- Executes on button press in TrainButton.
function TrainButton_Callback(hObject, eventdata, handles)
% hObject    handle to TrainButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load the Training Data to the Network
Train_data = [handles.Data1; handles.Data2];

% Get the Learning Rate from the User
Alpha = str2double(get(handles.LearningRateEdit,'String'));

% Function to Train the Network
[Weights, Cluster_type] = trainKohonenNetwork(Train_data, Alpha, handles);

% Set Handles
handles.Weights = Weights;
handles.Cluster_type = Cluster_type;
set(handles.NetworkTrainedText,'visible','on');
guidata(hObject, handles)


% --- Executes on button press in TestButton.
function TestButton_Callback(hObject, eventdata, handles)
% hObject    handle to TestButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Function to Test the Network
Result = testKohonenNetwork(handles.Test_data, handles.Weights, handles.Cluster_type);

% Display the Test Result in GUI
if Result(1) == 1
    set(handles.Test1Edit,'String',handles.Class1);
elseif Result(1) == 2
    set(handles.Test1Edit,'String',handles.Class2);
end

if Result(2) == 1
    set(handles.Test2Edit,'String',handles.Class1);
elseif Result(2) == 2
    set(handles.Test2Edit,'String',handles.Class2);
end

if Result(3) == 1
    set(handles.Test3Edit,'String',handles.Class1);
elseif Result(3) == 2
    set(handles.Test3Edit,'String',handles.Class2);
end

if Result(4) == 1
    set(handles.Test4Edit,'String',handles.Class1);
elseif Result(4) == 2
    set(handles.Test4Edit,'String',handles.Class2);
end

% Set Handles
handles.Result = Result;
guidata(hObject, handles)


% --- Executes on button press in TestDataButton.
function TestDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to TestDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Select Test Data
[filename, pathname] = uigetfile({'*.txt','All Files'}, 'Select Test Data');
fileName = fullfile(pathname, filename);

% Load the Data
Test_data = load(fileName);

% Set Handles
handles.Test_data = Test_data;
set(handles.TestDataDoneText,'visible','on');
guidata(hObject, handles)


function Test1Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Test1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Test1Edit as text
%        str2double(get(hObject,'String')) returns contents of Test1Edit as a double


% --- Executes during object creation, after setting all properties.
function Test1Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test1Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Test2Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Test2Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Test2Edit as text
%        str2double(get(hObject,'String')) returns contents of Test2Edit as a double


% --- Executes during object creation, after setting all properties.
function Test2Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test2Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Test3Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Test3Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Test3Edit as text
%        str2double(get(hObject,'String')) returns contents of Test3Edit as a double


% --- Executes during object creation, after setting all properties.
function Test3Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test3Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Test4Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Test4Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of Test4Edit as text
%        str2double(get(hObject,'String')) returns contents of Test4Edit as a double


% --- Executes during object creation, after setting all properties.
function Test4Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Test4Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ConvergenceEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ConvergenceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of ConvergenceEdit as text
%        str2double(get(hObject,'String')) returns contents of ConvergenceEdit as a double


% --- Executes during object creation, after setting all properties.
function ConvergenceEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ConvergenceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function LearningRateEdit_Callback(hObject, eventdata, handles)
% hObject    handle to LearningRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of LearningRateEdit as text
%        str2double(get(hObject,'String')) returns contents of LearningRateEdit as a double


% --- Executes during object creation, after setting all properties.
function LearningRateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LearningRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ResetButton.
function ResetButton_Callback(hObject, eventdata, handles)
% hObject    handle to ResetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.ConvergenceAxes,'reset');
axes(handles.ConvergenceAxes);
set(handles.Class1DataDoneText,'visible','off');
set(handles.Class2DataDoneText,'visible','off');
set(handles.TestDataDoneText,'visible','off');
set(handles.NetworkTrainedText,'visible','off');
set(handles.Test1Edit,'String','');
set(handles.Test2Edit,'String','');
set(handles.Test3Edit,'String','');
set(handles.Test4Edit,'String','');
set(handles.ConvergenceEdit,'String','');

