function varargout = Gui(varargin)
% GUI MATLAB code for Gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gui

% Last Modified by GUIDE v2.5 03-Jul-2016 17:46:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Gui_OutputFcn, ...
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


% --- Executes just before Gui is made visible.
function Gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gui (see VARARGIN)
set(handles.Temp_monitor,'String','Intialization required');
set(handles.Temp_monitor,'Enable','off');
set(handles.Volt_send,'String','Intialization required');
set(handles.Volt_send,'Enable','off');
set(handles.Disconnect,'String','Arduino connection required');
set(handles.Disconnect,'Enable','off');
set(handles.Current_Monitor,'String','Please Specify Serial Port');
set(handles.Current_Monitor,'Enable','off');
global TempMax;
global Num_dac; 
global Num_slice;
global serial_port;
global signal;
global refresh_rate; %how fast the bar graph get freshed

TempMax = 0;
Num_dac = 0;
Num_slice = 0;
serial_port = 'COM5';
signal = 1;
refresh_rate = 0.05; %the refreshing rate must be smaller than the sensing rate

% Choose default command line output for Gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in Temp_monitor.
function Temp_monitor_Callback(hObject, eventdata, handles)
% hObject    handle to Temp_monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TempMax;
global Num_dac; 
global serial_port;

button_state = get(hObject,'Value');
arduino = serial(serial_port); 

if (button_state == get(hObject,'Max'))
    display('Temperature acqusition starts!');
    fopen(arduino); %'open up' the serial port object 
    pause(1); %wait for some time for arduino to get ready (very important!)

    set(handles.Disconnect,'String','Disconnected and reset');
    set(handles.Disconnect,'Enable','on');

    counter = 1; 
    temp = 0;
    temp_array = zeros(1,Num_dac);
    overload = 0;
    %OL_index = [];
    %OL_counter = 1;

    fwrite(arduino,'T','char');
    display('Temperature acqusition request sent!');
end

while (button_state == get(hObject,'Max')) %if toggle button is pushed 
     if ~get(hObject, 'Value')
        button_state = 0;
     end
    pause(0.1); %very important

    if arduino.BytesAvailable
        display(arduino.BytesAvailable);
        display(arduino.ValuesReceived);
        %display('data received');
        temp = str2double(fscanf(arduino));
        temp_array (counter) = temp; 
        
        if temp > TempMax
            beep on;
            overload = 1; 
            %OL_index(OL_counter) = counter;
            %OL_counter = OL_counter + 1;
        end
        %display(temp);
        
        counter = counter + 1;
        if counter == Num_dac + 1
             if overload == 0
                NOL_bar = bar(handles.axes1,temp_array); 
             else 
                OL_bar = bar(handles.axes1,temp_array);
                %for i = 1:OL_counter
                 %  OL_bar(OL_index(i)).FaceColor = 'red'; 
                %end
                warning('Temrature overload detected!');
                hline = refline(0,TempMax);
                hline.Color = 'r';
                beep;
            end
            pause(2);%wait before refresh 
            counter = 1;
            %OL_counter = 1;
            overload = 0;
        end
    else
        bar(handles.axes1,zeros(1:Num_dac));
        display('data not received');
    end 
end

fclose(arduino);
delete(arduino);

% --- Executes on button press in Volt_send.
function Volt_send_Callback(hObject, eventdata, handles)
% hObject    handle to Volt_send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TempMax;
global Num_dac; 
global Num_slice;
global serial_port;
global signal;

%Num_dac = str2double(get(handles.Channel_text,'string')); %specify Dac num
Data_sequence = Num_slice; %specify data sequence num (rows of excel)
Size = Num_dac*Data_sequence; %total element number in the excel file  
BaudRate = 9600; %specify BaudRate
Vmax = 5; %specify the max voltage value allowed
Vmin = -5; %specify the min voltage value allowed
beep on; %enable the warning/error sound to be on

Volt_data = []; %Dac voltage values from excel
Volt_send = []; %Dac voltage data to be sent
Dac_volt = zeros(1,Num_dac); %Dac voltage matrix initialization

Excel = 'Test.xlsx'; %specify excel file name
Volt_data = xlsread(Excel); %read in Dac voltage values
disp('Excel format imported!'); %display msg
[rows, columns] = size(Volt_data); %get the row and column num of excel file

arduino = serial(serial_port);  %setup serial port communication
set(arduino,'BaudRate',BaudRate);  %setup serial port baudRate

    
%% %%%%%%%%%%Excel voltage data conversion/format checking%%%%%%%%%% %%

%check whether the excel format matches with the hard ware setting
display('Excel column #:');
display(columns);
display('Excel row #:');
display(rows);

if (columns == Num_dac && rows == Data_sequence)
    display('Excel format matches!');
else 
    error('Excel format does not match the system seting!');
end 

%%check whether does the excel file contains unallowable values (>5 or <-5)
for i=1:rows
    for j=1:columns
        if Volt_data(i,j) > Vmax
            Volt_data(i,j) = 65536;
            msg = 'Find values exceed 5V!';
            warning(msg);
        elseif Volt_data(i,j)<-5
            Volt_data(i,j) = 0;
            msg = 'Find values smaller than -5V!';
            warning(msg);
        end
    end
end          

%%voltage data conversion from decimal to 16 bit unsigned binary 
for i=1:rows
    for j=1:columns
        %Convert -5 - 5 to 0 - 65535, all values need to be integer
        Volt_send(i,j) = 32768 + round(Volt_data(i,j)/5.0*32768); 
    end
end    
display('Dac Voltage value conversion completed!');


%% %%%%%%%%%%%%%%%%Send the voltage data to Arduino%%%%%%%%%%%%%%%%% %%

fopen(arduino); %'open up' the serial port object 
pause(2); %wait for some time for arduino to get ready (very important!)

for i=1:rows
  for j=1:columns
    %send the data out in the form of 16-bit unsigned int 
    fwrite(arduino, Volt_send(i,j), 'uint16')
  end
end

display('Voltage data sent!');
display('Process finish! Data ready to be checked!');

fclose(arduino);
delete(arduino);

signal = 2;
set(handles.Disconnect,'String','Reset setting');
set(handles.Disconnect,'Enable','on'); 

if TempMax == 0
    set(handles.Temp_monitor,'String','Please set Temperature limit');
    set(handles.Temp_monitor,'Enable','off');
else 
    set(handles.Temp_monitor,'String','Temperature acqusition');
    set(handles.Temp_monitor,'Enable','on');
end

% --- Executes on button press in Disconnect.
function Disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to Disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TempMax;
global Num_dac; 
global Num_slice;
global serial_port;
global signal;

arduino = serial(serial_port);
fclose(arduino);
delete(arduino);

set(handles.Temp_monitor,'String','Intialization required');
set(handles.Temp_monitor, 'Value', 0);
set(handles.Temp_monitor,'Enable','off');
set(handles.Current_Monitor,'String','Arduino connection required');
set(handles.Current_Monitor, 'Value', 0);
set(handles.Current_Monitor,'Enable','off');
set(handles.Volt_send,'String','Intialization required');
set(handles.Volt_send,'Enable','off');
set(handles.Disconnect,'String','Arduino connection required');
set(handles.Disconnect,'Enable','off');

set(handles.Serial_text,'String','Serial Port');
set(handles.Current_text,'String','Max Temperature');
set(handles.Channel_text,'String','Number of Channel');
set(handles.Slice_text,'String','Slice Number');
bar(handles.axes1, zeros(1,Num_dac));

TempMax = 0;
Num_dac = 0; 
Num_slice = 0;
serial_port = 'COM5';
signal = 1;

function Serial_text_Callback(hObject, eventdata, handles)
% hObject    handle to Serial_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Serial_text as text
%        str2double(get(hObject,'String')) returns contents of Serial_text as a double

global Num_dac; 
global Num_slice;
global serial_port;

Port = get(hObject,'String');
if strcmp(Port(1:3),'COM') ~= 1
   beep;
   set(handles.Volt_send,'String','Invalid Port');
   set(handles.Volt_send,'Enable','off');
   set(handles.Current_Monitor,'String','Invalid Port');
   set(handles.Current_Monitor,'Enable','off');
   uicontrol(hObject);
else 
   serial_port = Port;
   set(handles.Current_Monitor,'String','Current Monitor');
   set(handles.Current_Monitor,'Enable','on');
   if Num_dac ~= 0 && Num_slice ~= 0
        set(handles.Volt_send,'String','Upload data');
        set(handles.Volt_send,'Enable','on');
   else
        set(handles.Volt_send,'String','Dac_num and slice_num need to be set first');
   end  
end


% --- Executes during object creation, after setting all properties.
function Serial_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Serial_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Current_text_Callback(hObject, eventdata, handles)
% hObject    handle to Current_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Current_text as text
%        str2double(get(hObject,'String')) returns contents of Current_text as a double
global TempMax;
global signal;

DummyTemp = str2double(get(hObject,'String'));
if isnan(DummyTemp) || ~isreal(DummyTemp)  
    beep;
    set(handles.Temp_monitor,'String','Invalid Temperature');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
% Enable the Plot button with its original name
    TempMax = DummyTemp;
    if signal == 2
        set(handles.Temp_monitor,'String','Temperature acquisition');
        set(handles.Temp_monitor,'Enable','on');
    else 
        set(handles.Temp_monitor,'String','Please upload data first');
        set(handles.Temp_monitor,'Enable','off');
    end
end


% --- Executes during object creation, after setting all properties.
function Current_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Current_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Channel_text_Callback(hObject, eventdata, handles)
% hObject    handle to Channel_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Num_dac;
global Num_slice;
global serial_port;

Dummy_Num_dac = str2double(get(hObject,'String'));
if isnan(Dummy_Num_dac) || ~isreal(Dummy_Num_dac)  
    % isdouble returns NaN for non-numbers and Num_dac cannot be complex
    % Disable the Plot button and change its string to say why
    beep;
    set(handles.Temp_monitor,'String','Invalid Dac_num');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    Num_dac = Dummy_Num_dac;
    if strcmp(serial_port,'COM5') == 1 && Num_dac ~= 0 && Num_slice ~= 0
        set(handles.Volt_send,'String','Upload data')
        set(handles.Volt_send,'Enable','on')
        set(handles.Current_Monitor,'String','Current Monitor')
        set(handles.Current_Monitor,'Enable','on')
    else
        set(handles.Volt_send,'String','Invalid Channel Number');
        set(handles.Volt_send,'String','Invalid Channel Number');
    end
end


% --- Executes during object creation, after setting all properties.
function Channel_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Channel_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Slice_text_Callback(hObject, eventdata, handles)
% hObject    handle to Slice_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Num_dac; 
global Num_slice;
global serial_port;

Dummy_slice = str2double(get(hObject,'string'));
if isnan(Dummy_slice) || ~isreal(Dummy_slice)  
    % isdouble returns NaN for non-numbers and Num_dac cannot be complex
    % Disable the Plot button and change its string to say why
    beep;
    set(handles.Volt_send,'String','Invalid Slice number!');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
else 
    % Enable the Plot button with its original name
    Num_slice = Dummy_slice;
    if Num_slice ~= 0 && strcmp(serial_port,'COM4') == 1 && Num_dac ~= 0  
        set(handles.Volt_send,'String','Upload data')
        set(handles.Volt_send,'Enable','on')
    else
        set(handles.Volt_send,'String','Parameters need to be set first');
    end
end

% --- Executes during object creation, after setting all properties.
function Slice_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Slice_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Current_Monitor.
function Current_Monitor_Callback(hObject, eventdata, handles)
% hObject    handle to Current_Monitor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Current_Monitor
global serial_port;
global refresh_rate;

button_state = get(hObject,'Value');
arduino = serial(serial_port); 

if (button_state == get(hObject,'Max'))
    display('Current Monitor starts!');
    Cur_array = cell(1,5); %Array to receive the data 
    doub_curr = zeros(1,5); %Data array in double type
    x_name = {'A';'B';'C';'D';'E'}; %bar diagram x-axis labels
    iter = 1; %iterator 
    
    fopen(arduino); %'open up' the serial port object 
    pause(1); %wait for some time for arduino to get ready (very important!)

    set(handles.Disconnect,'String','Disconnected and reset');
    set(handles.Disconnect,'Enable','on');
end

while (button_state == get(hObject,'Max')) %if toggle button is pushed 
    if ~get(hObject, 'Value')
       button_state = 0;
    end
     
    if(arduino.BytesAvailable)
        val = cellstr(fscanf(arduino));
        if (iter == 6)
            iter = 1;
        end 
        Cur_array(iter) = val;
        if (iter == 5)
            for i=1:5
                temp = char(Cur_array(i));
                doub_curr(i) = str2double(char(cellstr(temp(2:end))));
            end
            bar(handles.axes1,doub_curr);
            %set(gca,'xticklabel',x_name);
        end
        iter = iter + 1;
        pause(refresh_rate); 
    end 
end

fclose(arduino);
delete(arduino);
