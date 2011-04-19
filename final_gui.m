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

%initialize for chamber plots
         Iatrialres_L=(Yout(:,21)-Yout(:,14))/Ratrialres_L;
         Iatrialres_R=(Yout(:,22)-Yout(:,14))/Ratrialres_R;
         Iin_LA=(Iatrialres_L+Iatrialres_R); 
         Iout_LA=max(((Yout(:,14)-Yout(:,15))/Rmv), 0);
         I_LA=Iin_LA-Iout_LA;

         %Left Ventricle
         Iin_LV=Iout_LA;
         Iout_LV=max((Yout(:,15)-Yout(:,6))/Rav, 0);
         I_LV=Iin_LV-Iout_LV;

         %Right Atrium
         Iin_RA=Yout(:,3);
         Iout_RA=max((Yout(:,16)-Yout(:,17))/Rtriv,0);
         I_RA=Iin_RA-Iout_RA;

         %Right Ventricle
         Iin_RV=Iout_RA;
         Iout_RV=Yout(:,23); 
         I_RV=Iin_RV-Iout_RV;

         %After 20 beats, choose 1 heartbeat (defined based on heart rate)
         T=60/70;
         A=find(Tout>(20*T)&Tout<(21*T));
         Tsmall=(Tout(A)-Tout(A(1)));

         Icut_LA=I_LA(A);
         Icut_LV=I_LV(A);
         Icut_RA=I_RA(A);
         Icut_RV=I_RV(A);

         for i=2:length(Tsmall)
             Volume_LA(1)=0;
             Volume_LV(1)=0;
             Volume_RA(1)=0;
             Volume_RV(1)=0;

             Volume_LA(i)=trapz(Tsmall(1:i), Icut_LA(1:i));
             Volume_LV(i)=trapz(Tsmall(1:i), Icut_LV(1:i));
             Volume_RA(i)=trapz(Tsmall(1:i), Icut_RA(1:i));
             Volume_RV(i)=trapz(Tsmall(1:i), Icut_RV(1:i));
         end

         %Add initial volumes
         Volume_LA=Volume_LA+40;
         Volume_LV=Volume_LV+120;
         Volume_RA=Volume_RA;
         Volume_RV=Volume_RV;

         Pressure_LA=Yout(A,14);
         Pressure_LV=Yout(A,15);
         Pressure_RA=Yout(A,16);
         Pressure_RV=Yout(A,17);

axes(handles.axes3);
 plot(Volume_LA,Pressure_LA, 'b.-')
 title('Left Atrium');
 
axes(handles.axes4);
 plot(Volume_LV,Pressure_LV, 'b.-')
 title('Left Ventricle');

axes(handles.axes5);
 plot(Volume_RA,Pressure_RA, 'b.-')
 title('Right Atrium');
 
axes(handles.axes6);
 plot(Volume_RV,Pressure_RV, 'b.-')
 title('Right Ventricle');
         
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
