function varargout = final_gui(varargin)
% FINAL_GUI MATLAB code for final_gui.fig
%      FINAL_GUI, by itself, creates a new FINAL_GUI or raises the existing
%      singleton*.
%
%      H = FINAL_GUI returns the handle to a new FINAL_GUI or the handle to
%      the existing singleton*.
%
%      FINAL_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL_GUI.M with the given input arguments.
%
%      FINAL_GUI('Property','Value',...) creates a new FINAL_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final_gui

% Last Modified by GUIDE v2.5 19-Apr-2011 10:35:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @final_gui_OutputFcn, ...
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


% --- Executes just before final_gui is made visible.
function final_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final_gui (see VARARGIN)

% Choose default command line output for final_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
% hObject    handle to solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% model initialization
parameter_struct
[yinit]=get_clinical_initial;
opts=odeset('Stats', 'on');
% run model 
[Tout, Yout]=ode23s(@clin_model_2, [0 20], yinit, opts);

%Wiggers Plot of Cardiac Cycle in Left Heart (Paor, Pla, Plv)
axes(handles.wiggers_left);
plot(Tout(1000:end), Yout(1000:end,6), Tout(1000:end), Yout(1000:end,14), Tout(1000:end), Yout(1000:end,15));legend('Paor','Pla','Plv');

%Right Heart Cardiac Cycle (Ppma, Pra, Prv)
axes(handles.wiggers_right);
for i=1:length(Yout)
    if (Yout(i,23)>0)
        Ppma(i)=Yout(i,17)-Yout(i,23)*Rpv_F;
    else
        Ppma(i)=Yout(i,17)-Yout(i,23)*Rpv_R;
    
    end
end
plot(Tout(1000:end), Ppma(1000:end), Tout(1000:end), Yout(1000:end,16), Tout(1000:end), Yout(1000:end,17));legend('Ppma','Pra','Prv');

% fill in data table with values
global data_table;
data_table = handles.uitable1;
set(data_table, 'Data', magic(8));

% update GUI
guidata(hObject, handles);



function Rpv_R_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Rpv_R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rpv_R_edit as text
%        str2double(get(hObject,'String')) returns contents of Rpv_R_edit as a double
global Rpv_R;
% return user string input as a double
if (isempty(Rpv_R))
    set(hObject, 'String', '0.08')
end
Rpv_R = str2double(get(hObject,'String')) 
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Rpv_R_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rpv_R_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Rpulart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Rpulart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Rpulart_edit as text
%        str2double(get(hObject,'String')) returns contents of Rpulart_edit as a double
global Rpulart_L;
% return user string input as a double
if (isempty(Rpulart_L))
    set(hObject, 'String', '1000')
end
Rpulart_L = str2double(get(hObject,'String')) ;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Rpulart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rpulart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
