function varargout = clin_model_gui(varargin)
% CLIN_MODEL_GUI M-file for clin_model_gui.fig
%      CLIN_MODEL_GUI, by itself, creates a new CLIN_MODEL_GUI or raises the existing
%      singleton*.
%
%      H = CLIN_MODEL_GUI returns the handle to a new CLIN_MODEL_GUI or the handle to
%      the existing singleton*.
%
%      CLIN_MODEL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CLIN_MODEL_GUI.M with the given input arguments.
%
%      CLIN_MODEL_GUI('Property','Value',...) creates a new CLIN_MODEL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before clin_model_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to clin_model_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help clin_model_gui

% Last Modified by GUIDE v2.5 18-Apr-2011 15:43:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @clin_model_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @clin_model_gui_OutputFcn, ...
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


% --- Executes just before clin_model_gui is made visible.
function clin_model_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to clin_model_gui (see VARARGIN)

% Choose default command line output for clin_model_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes clin_model_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = clin_model_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function valve_R_Callback(hObject, eventdata, handles)
% hObject    handle to valve_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of valve_R as text
%        str2double(get(hObject,'String')) returns contents of valve_R as a double
global Rpv_R;
Rpv_R = str2double(get(hObject,'String')) 
% return contents of Rmv as a double
if (isempty(Rpv_R))
    set(hObject, 'String', '0.08')
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function valve_R_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valve_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pulart_L_Callback(hObject, eventdata, handles)
% hObject    handle to pulart_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pulart_L as text
%        str2double(get(hObject,'String')) returns contents of pulart_L as
%        a double
global Rpulart_L;
Rpulart_L = str2double(get(hObject,'String')) ;
% return contents of Rmv as a double
if (isempty(Rpulart_L))
    set(hObject, 'String', '1000')
end
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function pulart_L_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pulart_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in solve_button.
function solve_button_Callback(hObject, eventdata, handles)
% hObject    handle to solve_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Rpv_R Rpulart_L
Rpv_R=get(handles.valve_R, 'String');
Rpulart_L=get(handles.pulart_L, 'String');
exec_clin_model;
%axes(handles.pv_plots);
%plot(Tout(1000:end), Yout(1000:end,6), Tout(1000:end), Yout(1000:end,14), Tout(1000:end), Yout(1000:end,15));legend('Paor','Pla','Plv');
axes(handles.syst_pres_plots) % selects syst_pres_plots as current axes
plot(Tout, Yout(:,6), Tout, Yout(:,15)); legend('Paor','Plv');
axes(handles.pulm_pres_plots)
plot(Tout, Yout(:,24), Tout, Yout(:,13), Tout, Yout(:,18), Tout, Yout(:,14)); legend('Ppulart','PpulartL','PpulartR','Pla');
% set(hObject,'toolbar','figure'); % enables toolbar
guidata(hObject, handles);