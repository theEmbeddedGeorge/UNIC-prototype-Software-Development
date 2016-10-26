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
%      GUI('Property','Value',...) creates a new GUI or raises the existing
%      singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property
%      application stop.  All inputs are passed to Gui_OpeningFcn via
%      varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Gui

% Last Modified by GUIDE v2.5 29-Jul-2016 16:56:23

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

%Set up buttons in the control panel
set(handles.Display_text,'String','Parameter Initialization and arduino connection required');
set(handles.Arduino_Connection,'Enable','off');
set(handles.Volt_send,'Enable','off');
set(handles.Disconnect,'Enable','off');
set(handles.Current_Monitor,'Enable','off');

%Set up buttons in each board panel
set(handles.Board1_clear,'enable','off');
set(handles.Board1_sweep,'enable','off'); 
set(handles.Board2_clear,'enable','off');
set(handles.Board2_sweep,'enable','off'); 
set(handles.Board3_clear,'enable','off');
set(handles.Board3_sweep,'enable','off'); 
set(handles.Board4_clear,'enable','off');
set(handles.Board4_sweep,'enable','off'); 
set(handles.Board5_clear,'enable','off');
set(handles.Board5_sweep,'enable','off'); 

%General Global Variables 
global TempMax;
global Num_dac; 
global Num_slice;
global signal;
global refresh_rate; %how fast the bar graph get freshed
global resistance; 
global error_tolerance;
global log_file;
global fid;

%Serial global variables 
global receive_ports_num;
global sent_ports_num;
global serial_ports_receive;
global serial_ports_sent;

global arduino1_receive;
global arduino2_receive;
global arduino3_receive;
global arduino4_receive;
global arduino5_receive;
global arduino1_sent;
global arduino2_sent;
global arduino3_sent;
global arduino4_sent;
global arduino5_sent;

%Serial globals initialization  
receive_ports_num = 5;
sent_ports_num = 5;

serial_ports_receive = cell(receive_ports_num,1);
serial_ports_sent = cell(sent_ports_num,1);

for i = 1:receive_ports_num
    serial_ports_receive(i) = cellstr('NULL') ;
end

for i = 1:sent_ports_num
    serial_ports_sent(i) = cellstr('NULL') ;
end

arduino1_receive = serial('NULL');
arduino2_receive = serial('NULL');
arduino3_receive = serial('NULL');
arduino4_receive = serial('NULL');
arduino5_receive = serial('NULL');
arduino1_sent = serial('NULL');
arduino2_sent = serial('NULL');
arduino3_sent = serial('NULL');
arduino4_sent = serial('NULL');
arduino5_sent = serial('NULL');

%General globals initialization
TempMax = 0;
Num_dac = 0;
Num_slice = 0;
signal = 1;
refresh_rate = 0.01; %the refreshing rate must be faster than the sensing rate
resistance = 0.25;
error_tolerance = 10;
log_file = 'Warning_log.txt';

pause on;

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

% --- Executes on button press in Arduino_Connection.
function Arduino_Connection_Callback(hObject, eventdata, handles)
% hObject    handle to Arduino_Connection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global serial_ports_receive;
global serial_ports_sent;

global arduino1_receive;
global arduino2_receive;
global arduino3_receive;
global arduino4_receive;
global arduino5_receive;
global arduino1_sent;
global arduino2_sent;
global arduino3_sent;
global arduino4_sent;
global arduino5_sent;

global fid;
global log_file;

%Open the log file
fid = fopen(log_file,'wt');

if Port_status(char(serial_ports_receive(1)),char(serial_ports_receive(2)),...
    char(serial_ports_receive(3)),char(serial_ports_receive(4)),...
    char(serial_ports_receive(5)),char(serial_ports_sent(1)),char(serial_ports_sent(2)),...
    char(serial_ports_sent(3)),char(serial_ports_sent(4)),...
    char(serial_ports_sent(5)))

    set(handles.Current_Monitor,'String','Monitor Current');
    set(handles.Current_Monitor,'Enable','on');
    set(handles.Volt_send,'String','Upload Voltage File');
    set(handles.Volt_send,'Enable','on');
    set(handles.Disconnect,'String','Arduino Disconnect and reset');
    set(handles.Disconnect,'Enable','on');
    set(handles.Arduino_Connection,'Enable','off');
    set(handles.Display_text,'String','Arduino Connection built Enter Current value please');

    %Turn on useful button for each brd 
    set(handles.Board1_clear,'enable','on');
    set(handles.Board1_sweep,'enable','on'); 
    set(handles.Board2_clear,'enable','on');
    set(handles.Board2_sweep,'enable','on');
    set(handles.Board3_clear,'enable','on');
    set(handles.Board3_sweep,'enable','on'); 
    set(handles.Board4_clear,'enable','on');
    set(handles.Board4_sweep,'enable','on');
    set(handles.Board5_clear,'enable','on');
    set(handles.Board5_sweep,'enable','on'); 

    arduino1_receive = Port_open(char(serial_ports_receive(1)),9600);
    arduino2_receive = Port_open(char(serial_ports_receive(2)),9600);
    arduino3_receive = Port_open(char(serial_ports_receive(3)),9600);
    arduino4_receive = Port_open(char(serial_ports_receive(4)),9600);
    arduino5_receive = Port_open(char(serial_ports_receive(5)),9600);
    arduino1_sent = Port_open(char(serial_ports_sent(1)),57600);
    arduino2_sent = Port_open(char(serial_ports_sent(2)),57600);
    arduino3_sent = Port_open(char(serial_ports_sent(3)),57600);
    arduino4_sent = Port_open(char(serial_ports_sent(4)),57600);
    arduino5_sent = Port_open(char(serial_ports_sent(5)),57600);
    pause(2); %very Important, wait for the connection to be built
else 
    set(handles.Display_text,'String','Port Unspecified! Arduino fails to connect!');
end

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

%Num_dac = str2double(get(handles.Display_text,'string')); %specify Dac num
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
    set(handles.Arduino_Connection,'String','Please set Temperature limit');
    set(handles.Arduino_Connection,'Enable','off');
else 
    set(handles.Arduino_Connection,'String','Temperature acqusition');
    set(handles.Arduino_Connection,'Enable','on');
end

% --- Executes on button press in Disconnect.
function Disconnect_Callback(hObject, eventdata, handles)
% hObject    handle to Disconnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global signal;
global receive_ports_num;
global sent_ports_num;
global serial_ports_receive;
global serial_ports_sent;
global TempMax;
global Num_dac;
global Num_slice;
global error_tolerance;
global fid;

global arduino1_receive;
global arduino2_receive;
global arduino3_receive;
global arduino4_receive;
global arduino5_receive;
global arduino1_sent;
global arduino2_sent;
global arduino3_sent;
global arduino4_sent;
global arduino5_sent;

if get(handles.Current_Monitor,'Value') == get(handles.Current_Monitor,'Max')
    beep;
    set(handles.Display_text,'String','Please stop current monitoring first');
else
    %Reset globals initialization
    TempMax = 0;
    Num_dac = 0;
    Num_slice = 0;
    signal = 1;
    error_tolerance = 20;

    %Reinitialize serial ports array
    for i = 1:receive_ports_num
        serial_ports_receive(i) = cellstr('NULL');
    end

    for i = 1:sent_ports_num
        serial_ports_sent(i) = cellstr('NULL');
    end
    
    %Reset channel current
    Board1_clear_Callback(handles.Board1_clear, eventdata,handles);
    Board2_clear_Callback(handles.Board2_clear, eventdata,handles);
    Board3_clear_Callback(handles.Board3_clear, eventdata,handles);
    Board4_clear_Callback(handles.Board4_clear, eventdata,handles);
    Board5_clear_Callback(handles.Board5_clear, eventdata,handles);
    
    %Reset control panel buttons
    set(handles.Arduino_Connection,'Enable','off');
    set(handles.Current_Monitor,'Value',0);
    set(handles.Current_Monitor,'Enable','off');
    set(handles.Volt_send,'Enable','off');
    set(handles.Disconnect,'Enable','off');
    set(handles.Error_tolerance_text,'String','Error_tolerance (%) Def: 10%');
    set(handles.Slice_text,'String','Slice Number');
    set(handles.Display_text,'String','System Reset');

    %Reset port_text for each board
    set(handles.Board1_sent_port,'String','Upload port');
    set(handles.Board1_receive_port,'String','Monitor port');
    set(handles.Board1_clear,'enable','off');
    set(handles.Board1_sweep,'enable','off'); 
    set(handles.Board2_sent_port,'String','Upload port');
    set(handles.Board2_receive_port,'String','Monitor port');
    set(handles.Board2_clear,'enable','off');
    set(handles.Board2_sweep,'enable','off'); 
    set(handles.Board3_sent_port,'String','Upload port');
    set(handles.Board3_receive_port,'String','Monitor port');
    set(handles.Board3_clear,'enable','off');
    set(handles.Board3_sweep,'enable','off'); 
    set(handles.Board4_sent_port,'String','Upload port');
    set(handles.Board4_receive_port,'String','Monitor port');
    set(handles.Board4_clear,'enable','off');
    set(handles.Board4_sweep,'enable','off'); 
    set(handles.Board5_sent_port,'String','Upload port');
    set(handles.Board5_receive_port,'String','Monitor port');
    set(handles.Board5_clear,'enable','off');
    set(handles.Board5_sweep,'enable','off'); 

    %Shutdown all serial connections 
    Port_shutdown(arduino1_receive);
    Port_shutdown(arduino2_receive);
    Port_shutdown(arduino3_receive);
    Port_shutdown(arduino4_receive);
    Port_shutdown(arduino5_receive);
    Port_shutdown(arduino1_sent);
    Port_shutdown(arduino2_sent);
    Port_shutdown(arduino3_sent);
    Port_shutdown(arduino4_sent);
    Port_shutdown(arduino5_sent);
    fclose(fid);
end

function Error_tolerance_text_Callback(hObject, eventdata, handles)
% hObject    handle to Error_tolerance_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Error_tolerance_text as text
%        str2double(get(hObject,'String')) returns contents of Error_tolerance_text as a double
global error_tolerance;

val = get(hObject,'String');
doub_val = str2double(val);
if isnan(doub_val)
    set(handles.Display_text,'String','Error tolerance must be a number');
    uicontrol(hObject);
else
   if (doub_val < 0 || doub_val > 100) 
       set(handles.Display_text,'String','Error tolerance Exceed allowable range');
       uicontrol(hObject);
   else
       error_tolerance = doub_val;
       temp_char = num2str(doub_val);
       set(handles.Error_tolerance_text,'String',...
           strcat('Error tolerance:',temp_char,' %'));
   end
end

% --- Executes during object creation, after setting all properties.
function Error_tolerance_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Error_tolerance_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Channel_text_Callback(hObject, eventdata, handles)
% hObject    handle to Display_text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function Display_text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Display_text (see GCBO)
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

global arduino1_receive;
global arduino2_receive;
global arduino3_receive;
global arduino4_receive;
global arduino5_receive;
global refresh_rate;
global error_tolerance;
global fid;

ad_val1 = 0;
ad_val2 = 0;
ad_val3 = 0;
ad_val4 = 0;
ad_val5 = 0;

button_state = get(hObject,'Value'); 

if ~strcmp(arduino1_receive.port,'NULL')
    ad_val1 = 1; %Arduino connection indicator
end 
if ~strcmp(arduino2_receive.port,'NULL')
    ad_val2 = 1; %Arduino connection indicator
end 
if ~strcmp(arduino3_receive.port,'NULL')
    ad_val3 = 1; %Arduino connection indicator
end 
if ~strcmp(arduino4_receive.port,'NULL')
    ad_val4 = 1; %Arduino connection indicator
end 
if ~strcmp(arduino5_receive.port,'NULL')
    ad_val5 = 1; %Arduino connection indicator
end 

if button_state == get(hObject,'Max') && (ad_val1 == 1 || ad_val2 == 1 ||... 
    ad_val3 == 1 || ad_val4 == 1 || ad_val5 == 1)
    Cur_array_1 = cell(1,5); %Array to receive the data for bd1
    Cur_array_2 = cell(1,5); %Array to receive the data for bd2
    Cur_array_3 = cell(1,5); %Array to receive the data for bd3
    Cur_array_4 = cell(1,5); %Array to receive the data for bd4
    Cur_array_5 = cell(1,5); %Array to receive the data for bd5
    iter = 1; %iterator 
    
    set(handles.Display_text,'String','Current Monitoring Running');
else
    set(handles.Display_text,...
    'String','Current Monitoring Stop Arduino can be disconnected now');
end

while (button_state == get(hObject,'Max') && (ad_val1 == 1 || ad_val2...
    ==1 || ad_val3 == 1 || ad_val4 == 1 || ad_val5 ==1)) 

 %if toggle button is pushed and detect arduino conection 
    if ~get(hObject, 'Value')
       button_state = 0;
    end
    
    if arduino1_receive.BytesAvailable 
        val1 = cellstr(fscanf(arduino1_receive)); 
    else 
        val1 = cellstr('inf');
    end
    if arduino2_receive.BytesAvailable 
        val2 = cellstr(fscanf(arduino2_receive)); 
    else 
        val2 = cellstr('inf');
    end
    if arduino3_receive.BytesAvailable 
        val3 = cellstr(fscanf(arduino3_receive)); 
    else 
        val3 = cellstr('inf');
    end
    if arduino4_receive.BytesAvailable 
        val4 = cellstr(fscanf(arduino4_receive)); 
    else 
        val4 = cellstr('inf');
    end
    if arduino5_receive.BytesAvailable 
        val5 = cellstr(fscanf(arduino5_receive)); 
    else 
        val5 = cellstr('inf');
    end
        
    if (iter == 6)
        iter = 1;
    end 

    if ad_val1 == 1 Cur_array_1(iter) = val1; end
    if ad_val2 == 1 Cur_array_2(iter) = val2; end 
    if ad_val3 == 1 Cur_array_3(iter) = val3; end 
    if ad_val4 == 1 Cur_array_4(iter) = val4; end 
    if ad_val5 == 1 Cur_array_5(iter) = val5; end
            
       if ad_val1 == 1
             temp1 = char(Cur_array_1(iter));
             temp1_double = str2double(temp1(2:end));
             switch temp1(1)
                 case 'A'
                       error_eval(handles.Board1_A,handles.Board1_A_input,temp1,temp1_double,error_tolerance,fid);
                 case 'B'
                       error_eval(handles.Board1_B,handles.Board1_B_input,temp1,temp1_double,error_tolerance,fid);
                 case 'C'
                       error_eval(handles.Board1_C,handles.Board1_C_input,temp1,temp1_double,error_tolerance,fid);
                 case 'D'
                       error_eval(handles.Board1_D,handles.Board1_D_input,temp1,temp1_double,error_tolerance,fid);
                 case 'E'
                       error_eval(handles.Board1_E,handles.Board1_E_input,temp1,temp1_double,error_tolerance,fid);
                 case 'F'
                       error_eval(handles.Board1_F,handles.Board1_F_input,temp1,temp1_double,error_tolerance,fid);
                 case 'G'
                       error_eval(handles.Board1_G,handles.Board1_G_input,temp1,temp1_double,error_tolerance,fid);
                 case 'H'
                       error_eval(handles.Board1_H,handles.Board1_H_input,temp1,temp1_double,error_tolerance,fid);
                 case 'I'
                       error_eval(handles.Board1_I,handles.Board1_I_input,temp1,temp1_double,error_tolerance,fid);
                 case 'J'
                       error_eval(handles.Board1_J,handles.Board1_J_input,temp1,temp1_double,error_tolerance,fid);
             end 
        end
    %% Read board 2 current vals
       if ad_val2 == 1
           temp2 = char(Cur_array_2(iter));
           temp2_double = str2double(temp2(2:end));
           switch temp2(1)
               case 'A'
                     error_eval(handles.Board2_A,handles.Board2_A_input,temp2,temp2_double,error_tolerance,fid);
               case 'B'
                     error_eval(handles.Board2_B,handles.Board2_B_input,temp2,temp2_double,error_tolerance,fid);
               case 'C'
                     error_eval(handles.Board2_C,handles.Board2_C_input,temp2,temp2_double,error_tolerance,fid);
               case 'D'
                     error_eval(handles.Board2_D,handles.Board2_D_input,temp2,temp2_double,error_tolerance,fid);
               case 'E'
                     error_eval(handles.Board2_E,handles.Board2_E_input,temp2,temp2_double,error_tolerance,fid);
               case 'F'
                     error_eval(handles.Board2_F,handles.Board2_F_input,temp2,temp2_double,error_tolerance,fid);
               case 'G'
                     error_eval(handles.Board2_G,handles.Board2_G_input,temp2,temp2_double,error_tolerance,fid);
               case 'H'
                     error_eval(handles.Board2_H,handles.Board2_H_input,temp2,temp2_double,error_tolerance,fid);
               case 'I'
                     error_eval(handles.Board2_I,handles.Board2_I_input,temp2,temp2_double,error_tolerance,fid);
               case 'J'
                     error_eval(handles.Board2_J,handles.Board2_J_input,temp2,temp2_double,error_tolerance,fid);
           end 
       end
    %% Read board 3 current vals
       if ad_val3 == 1
           temp3 = char(Cur_array_3(iter));
           temp3_double = str2double(temp3(2:end));
           switch temp3(1)
               case 'A'
                     error_eval(handles.Board3_A,handles.Board3_A_input,temp3,temp3_double,error_tolerance,fid);
               case 'B'
                     error_eval(handles.Board3_B,handles.Board3_B_input,temp3,temp3_double,error_tolerance,fid);
               case 'C'
                     error_eval(handles.Board3_C,handles.Board3_C_input,temp3,temp3_double,error_tolerance,fid);
               case 'D'
                     error_eval(handles.Board3_D,handles.Board3_D_input,temp3,temp3_double,error_tolerance,fid);
               case 'E'
                     error_eval(handles.Board3_E,handles.Board3_E_input,temp3,temp3_double,error_tolerance,fid);
               case 'F'
                     error_eval(handles.Board3_F,handles.Board3_F_input,temp3,temp3_double,error_tolerance,fid);
               case 'G'
                     error_eval(handles.Board3_G,handles.Board3_G_input,temp3,temp3_double,error_tolerance,fid);
               case 'H'
                     error_eval(handles.Board3_H,handles.Board3_H_input,temp3,temp3_double,error_tolerance,fid);
               case 'I'
                     error_eval(handles.Board3_I,handles.Board3_I_input,temp3,temp3_double,error_tolerance,fid);
               case 'J'
                     error_eval(handles.Board3_J,handles.Board3_J_input,temp3,temp3_double,error_tolerance,fid);
           end 
       end
    %% Read board 4 current vals
       if ad_val4 == 1
           temp4 = char(Cur_array_4(iter));
           temp4_double = str2double(temp4(2:end));
           switch temp4(1)
               case 'A'
                     error_eval(handles.Board4_A,handles.Board4_A_input,temp4,temp4_double,error_tolerance,fid);
               case 'B'
                     error_eval(handles.Board4_B,handles.Board4_B_input,temp4,temp4_double,error_tolerance,fid);
               case 'C'
                     error_eval(handles.Board4_C,handles.Board4_C_input,temp4,temp4_double,error_tolerance,fid);
               case 'D'
                     error_eval(handles.Board4_D,handles.Board4_D_input,temp4,temp4_double,error_tolerance,fid);
               case 'E'
                     error_eval(handles.Board4_E,handles.Board4_E_input,temp4,temp4_double,error_tolerance,fid);
               case 'F'
                     error_eval(handles.Board4_F,handles.Board4_F_input,temp4,temp4_double,error_tolerance,fid);
               case 'G'
                     error_eval(handles.Board4_G,handles.Board4_G_input,temp4,temp4_double,error_tolerance,fid);
               case 'H'
                     error_eval(handles.Board4_H,handles.Board4_H_input,temp4,temp4_double,error_tolerance,fid);
               case 'I'
                     error_eval(handles.Board4_I,handles.Board4_I_input,temp4,temp4_double,error_tolerance,fid);
               case 'J'
                     error_eval(handles.Board4_J,handles.Board4_J_input,temp4,temp4_double,error_tolerance,fid);
           end 
       end
    %% Read board 5 current vals
       if ad_val5 == 1
           temp5 = char(Cur_array_5(iter));
           temp5_double = str2double(temp5(2:end));
           switch temp5(1)
               case 'A'
                     error_eval(handles.Board5_A,handles.Board5_A_input,temp5,temp5_double,error_tolerance,fid);
               case 'B'
                     error_eval(handles.Board5_B,handles.Board5_B_input,temp5,temp5_double,error_tolerance,fid);
               case 'C'
                     error_eval(handles.Board5_C,handles.Board5_C_input,temp5,temp5_double,error_tolerance,fid);
               case 'D'
                     error_eval(handles.Board5_D,handles.Board5_D_input,temp5,temp5_double,error_tolerance,fid);
               case 'E'
                     error_eval(handles.Board5_E,handles.Board5_E_input,temp5,temp5_double,error_tolerance,fid);
               case 'F'
                     error_eval(handles.Board5_F,handles.Board5_F_input,temp5,temp5_double,error_tolerance,fid);
               case 'G'
                     error_eval(handles.Board5_G,handles.Board5_G_input,temp5,temp5_double,error_tolerance,fid);
               case 'H'
                     error_eval(handles.Board5_H,handles.Board5_H_input,temp5,temp5_double,error_tolerance,fid);
               case 'I'
                     error_eval(handles.Board5_I,handles.Board5_I_input,temp5,temp5_double,error_tolerance,fid);
               case 'J'
                     error_eval(handles.Board5_J,handles.Board5_J_input,temp5,temp5_double,error_tolerance,fid);
           end 
       end
    
    iter = iter + 1;
    pause(refresh_rate); 
end

function Board1_A_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_A_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_A_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino1_sent,handles.Board1_A_input,cur_data,'A');

% --- Executes during object creation, after setting all properties.
function Board1_A_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board1_B_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_B_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_B_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_B_input,cur_data,'B');

% --- Executes during object creation, after setting all properties.
function Board1_B_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_C_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_C_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_C_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_C_input,cur_data,'C');

% --- Executes during object creation, after setting all properties.
function Board1_C_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_D_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_D_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_D_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_D_input,cur_data,'D');

% --- Executes during object creation, after setting all properties.
function Board1_D_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_E_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_E_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_E_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_E_input,cur_data,'E');

% --- Executes during object creation, after setting all properties.
function Board1_E_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Board1_sweep.
function Board1_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino1_sent;

Board1_clear_Callback(handles.Board1_clear, eventdata,handles);

if ~strcmp(arduino1_sent.port,'NULL')
    fprintf(arduino1_sent,'%s','q\n');
    set(handles.Display_text,'String','Board 1 Current Sweeping');
else
    set(handles.Display_text,'String','Board 1 Arduino Not connected. Sweeping fails.');
end

% --- Executes on button press in Board1_clear.
function Board1_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino1_sent;

if ~strcmp(arduino1_sent.port,'NULL')
    fprintf(arduino1_sent,'%s','z\n');
    fprintf(arduino1_sent,'%s','x\n');
    set(handles.Board1_A,'String','A');
    set(handles.Board1_B,'String','B');
    set(handles.Board1_C,'String','C');
    set(handles.Board1_D,'String','D');
    set(handles.Board1_E,'String','E');
    set(handles.Board1_F,'String','F');
    set(handles.Board1_G,'String','G');
    set(handles.Board1_H,'String','H');
    set(handles.Board1_I,'String','I');
    set(handles.Board1_J,'String','J');
    set(handles.Board1_A,'BackgroundColor','white');
    set(handles.Board1_B,'BackgroundColor','white');
    set(handles.Board1_C,'BackgroundColor','white');
    set(handles.Board1_D,'BackgroundColor','white');
    set(handles.Board1_E,'BackgroundColor','white');
    set(handles.Board1_F,'BackgroundColor','white');
    set(handles.Board1_G,'BackgroundColor','white');
    set(handles.Board1_H,'BackgroundColor','white');
    set(handles.Board1_I,'BackgroundColor','white');
    set(handles.Board1_J,'BackgroundColor','white');
    set(handles.Board1_A_input,'String','0');
    set(handles.Board1_B_input,'String','0');
    set(handles.Board1_C_input,'String','0');
    set(handles.Board1_D_input,'String','0');
    set(handles.Board1_E_input,'String','0');
    set(handles.Board1_F_input,'String','0');
    set(handles.Board1_G_input,'String','0');
    set(handles.Board1_H_input,'String','0');
    set(handles.Board1_I_input,'String','0');
    set(handles.Board1_J_input,'String','0');
    set(handles.Display_text,'String','Reset all Board 1 channel current to zero');
else
    set(handles.Display_text,'String','Board 1 Arduino Not connected. Reset fails.');
end


function Board1_receive_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_receive_port as text
%        str2double(get(hObject,'String')) returns contents of Board1_receive_port as a double

global serial_ports_receive;
serial_ports_receive(1) = cellstr(Board_receive_port(handles.Display_text,handles.Arduino_Connection,hObject));

% --- Executes during object creation, after setting all properties.
function Board1_receive_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board1_sent_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_sent_port as text
%        str2double(get(hObject,'String')) returns contents of Board1_sent_port as a double

global serial_ports_sent;
serial_ports_sent(1) = cellstr(Board_sent_port(handles.Display_text,handles.Arduino_Connection,hObject));


% --- Executes during object creation, after setting all properties.
function Board1_sent_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_sent_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_sent_port as text
%        str2double(get(hObject,'String')) returns contents of Board2_sent_port as a double
global serial_ports_sent;
serial_ports_sent(2) = cellstr(Board_sent_port(handles.Display_text,handles.Arduino_Connection,hObject));


% --- Executes during object creation, after setting all properties.
function Board2_sent_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board2_receive_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_receive_port as text
%        str2double(get(hObject,'String')) returns contents of Board2_receive_port as a double
global serial_ports_receive;
serial_ports_receive(2) = cellstr(Board_receive_port(handles.Display_text,handles.Arduino_Connection,hObject));

% --- Executes during object creation, after setting all properties.
function Board2_receive_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Board2_clear.
function Board2_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino2_sent;

if ~strcmp(arduino2_sent.port,'NULL')
    fprintf(arduino2_sent,'%s','z\n');
    fprintf(arduino2_sent,'%s','x\n');
    set(handles.Board2_A,'String','A');
    set(handles.Board2_B,'String','B');
    set(handles.Board2_C,'String','C');
    set(handles.Board2_D,'String','D');
    set(handles.Board2_E,'String','E');
    set(handles.Board2_F,'String','F');
    set(handles.Board2_G,'String','G');
    set(handles.Board2_H,'String','H');
    set(handles.Board2_I,'String','I');
    set(handles.Board2_J,'String','J');
    set(handles.Board2_A,'BackgroundColor','white');
    set(handles.Board2_B,'BackgroundColor','white');
    set(handles.Board2_C,'BackgroundColor','white');
    set(handles.Board2_D,'BackgroundColor','white');
    set(handles.Board2_E,'BackgroundColor','white');
    set(handles.Board2_F,'BackgroundColor','white');
    set(handles.Board2_G,'BackgroundColor','white');
    set(handles.Board2_H,'BackgroundColor','white');
    set(handles.Board2_I,'BackgroundColor','white');
    set(handles.Board2_J,'BackgroundColor','white');
    set(handles.Board2_A_input,'String','0');
    set(handles.Board2_B_input,'String','0');
    set(handles.Board2_C_input,'String','0');
    set(handles.Board2_D_input,'String','0');
    set(handles.Board2_E_input,'String','0');
    set(handles.Board2_F_input,'String','0');
    set(handles.Board2_G_input,'String','0');
    set(handles.Board2_H_input,'String','0');
    set(handles.Board2_I_input,'String','0');
    set(handles.Board2_J_input,'String','0');
    set(handles.Display_text,'String','Reset all Board 2 channel current to zero');
else
    set(handles.Display_text,'String','Board 2 Arduino Not connected. Reset fails.');
end

% --- Executes on button press in Board2_sweep.
function Board2_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino2_sent;

Board2_clear_Callback(handles.Board2_clear, eventdata,handles);

if ~strcmp(arduino2_sent.port,'NULL')
    fprintf(arduino2_sent,'%s','q\n');
    set(handles.Display_text,'String','Board 2 Current Sweeping');
else
    set(handles.Display_text,'String','Board 2 Arduino Not connected. Sweeping fails.');
end


function Board2_E_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_E_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_E_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_E_input,cur_data,'E');

% --- Executes during object creation, after setting all properties.
function Board2_E_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_D_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_D_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_D_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_D_input,cur_data,'D');

% --- Executes during object creation, after setting all properties.
function Board2_D_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_C_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_C_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_C_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_C_input,cur_data,'C');

% --- Executes during object creation, after setting all properties.
function Board2_C_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_B_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_B_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_B_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_B_input,cur_data,'B');

% --- Executes during object creation, after setting all properties.
function Board2_B_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board2_A_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_A_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_A_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_A_input,cur_data,'A');


% --- Executes during object creation, after setting all properties.
function Board2_A_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board3_A_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_A_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_A_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_A_input,cur_data,'A');

% --- Executes during object creation, after setting all properties.
function Board3_A_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board3_B_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_B_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_B_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_B_input,cur_data,'B');

% --- Executes during object creation, after setting all properties.
function Board3_B_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_C_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_C_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_C_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_C_input,cur_data,'C');

% --- Executes during object creation, after setting all properties.
function Board3_C_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_D_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_D_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_D_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_D_input,cur_data,'D');

% --- Executes during object creation, after setting all properties.
function Board3_D_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_E_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_E_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_E_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_E_input,cur_data,'E');

% --- Executes during object creation, after setting all properties.
function Board3_E_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Board3_sweep.
function Board3_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino3_sent;

Board3_clear_Callback(handles.Board3_clear, eventdata,handles);

if ~strcmp(arduino3_sent.port,'NULL')
    fprintf(arduino3_sent,'%s','q\n');
    set(handles.Display_text,'String','Board 3 Current Sweeping');
else
    set(handles.Display_text,'String','Board 3 Arduino Not connected. Sweeping fails.');
end

% --- Executes on button press in Board3_clear.
function Board3_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino3_sent;

if ~strcmp(arduino3_sent.port,'NULL')
    fprintf(arduino3_sent,'%s','z\n');
    fprintf(arduino3_sent,'%s','x\n');
    set(handles.Board3_A,'String','A');
    set(handles.Board3_B,'String','B');
    set(handles.Board3_C,'String','C');
    set(handles.Board3_D,'String','D');
    set(handles.Board3_E,'String','E');
    set(handles.Board3_F,'String','F');
    set(handles.Board3_G,'String','G');
    set(handles.Board3_H,'String','H');
    set(handles.Board3_I,'String','I');
    set(handles.Board3_J,'String','J');
    set(handles.Board3_A,'BackgroundColor','white');
    set(handles.Board3_B,'BackgroundColor','white');
    set(handles.Board3_C,'BackgroundColor','white');
    set(handles.Board3_D,'BackgroundColor','white');
    set(handles.Board3_E,'BackgroundColor','white');
    set(handles.Board3_F,'BackgroundColor','white');
    set(handles.Board3_G,'BackgroundColor','white');
    set(handles.Board3_H,'BackgroundColor','white');
    set(handles.Board3_I,'BackgroundColor','white');
    set(handles.Board3_J,'BackgroundColor','white');
    set(handles.Board3_A_input,'String','0');
    set(handles.Board3_B_input,'String','0');
    set(handles.Board3_C_input,'String','0');
    set(handles.Board3_D_input,'String','0');
    set(handles.Board3_E_input,'String','0');
    set(handles.Board3_F_input,'String','0');
    set(handles.Board3_G_input,'String','0');
    set(handles.Board3_H_input,'String','0');
    set(handles.Board3_I_input,'String','0');
    set(handles.Board3_J_input,'String','0');
    set(handles.Display_text,'String','Reset all Board 3 channel current to zero');
else
    set(handles.Display_text,'String','Board 3 Arduino Not connected. Reset fails.');
end


function Board3_receive_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_receive_port as text
%        str2double(get(hObject,'String')) returns contents of Board3_receive_port as a double
global serial_ports_receive;
serial_ports_receive(3) = cellstr(Board_receive_port(handles.Display_text,handles.Arduino_Connection,hObject));

% --- Executes during object creation, after setting all properties.
function Board3_receive_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_sent_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_sent_port as text
%        str2double(get(hObject,'String')) returns contents of Board3_sent_port as a double
global serial_ports_sent;
serial_ports_sent(3) = cellstr(Board_sent_port(handles.Display_text,handles.Arduino_Connection,hObject));

% --- Executes during object creation, after setting all properties.
function Board3_sent_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board5_sent_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_sent_port as text
%        str2double(get(hObject,'String')) returns contents of Board5_sent_port as a double
global serial_ports_sent;
serial_ports_sent(5) = cellstr(Board_sent_port(handles.Display_text,handles.Arduino_Connection,hObject));


% --- Executes during object creation, after setting all properties.
function Board5_sent_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board5_receive_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_receive_port as text
%        str2double(get(hObject,'String')) returns contents of Board5_receive_port as a double
global serial_ports_receive;
serial_ports_receive(5) = cellstr(Board_receive_port(handles.Display_text,handles.Arduino_Connection,hObject));

% --- Executes during object creation, after setting all properties.
function Board5_receive_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Board5_clear.
function Board5_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino5_sent;

if ~strcmp(arduino5_sent.port,'NULL')
    fprintf(arduino5_sent,'%s','z\n');
    fprintf(arduino5_sent,'%s','x\n');
    set(handles.Board5_A,'String','A');
    set(handles.Board5_B,'String','B');
    set(handles.Board5_C,'String','C');
    set(handles.Board5_D,'String','D');
    set(handles.Board5_E,'String','E');
    set(handles.Board5_F,'String','F');
    set(handles.Board5_G,'String','G');
    set(handles.Board5_H,'String','H');
    set(handles.Board5_I,'String','I');
    set(handles.Board5_J,'String','J');
    set(handles.Board5_A,'BackgroundColor','white');
    set(handles.Board5_B,'BackgroundColor','white');
    set(handles.Board5_C,'BackgroundColor','white');
    set(handles.Board5_D,'BackgroundColor','white');
    set(handles.Board5_E,'BackgroundColor','white');
    set(handles.Board5_F,'BackgroundColor','white');
    set(handles.Board5_G,'BackgroundColor','white');
    set(handles.Board5_H,'BackgroundColor','white');
    set(handles.Board5_I,'BackgroundColor','white');
    set(handles.Board5_J,'BackgroundColor','white');
    set(handles.Board5_A_input,'String','0');
    set(handles.Board5_B_input,'String','0');
    set(handles.Board5_C_input,'String','0');
    set(handles.Board5_D_input,'String','0');
    set(handles.Board5_E_input,'String','0');
    set(handles.Board5_F_input,'String','0');
    set(handles.Board5_G_input,'String','0');
    set(handles.Board5_H_input,'String','0');
    set(handles.Board5_I_input,'String','0');
    set(handles.Board5_J_input,'String','0');
    set(handles.Display_text,'String','Reset all Board 5 channel current to zero');
else
    set(handles.Display_text,'String','Board 5 Arduino Not connected. Reset fails.');
end

% --- Executes on button press in Board5_sweep.
function Board5_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino5_sent;

Board5_clear_Callback(handles.Board5_clear, eventdata,handles);

if ~strcmp(arduino5_sent.port,'NULL')
    fprintf(arduino5_sent,'%s','q\n');
    set(handles.Display_text,'String','Board 5 Current Sweeping');
else
    set(handles.Display_text,'String','Board 5 Arduino Not connected. Sweeping fails.');
end

function Board5_E_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_E_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_E_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_E_input,cur_data,'E');

% --- Executes during object creation, after setting all properties.
function Board5_E_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board5_D_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_D_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_D_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_D_input,cur_data,'D');

% --- Executes during object creation, after setting all properties.
function Board5_D_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board5_C_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_C_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_C_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_C_input,cur_data,'C');

% --- Executes during object creation, after setting all properties.
function Board5_C_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board5_B_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_B_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_B_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_B_input,cur_data,'B');

% --- Executes during object creation, after setting all properties.
function Board5_B_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board5_A_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_A_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_A_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_A_input,cur_data,'A');

% --- Executes during object creation, after setting all properties.
function Board5_A_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_A_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_A_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_A_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_A_input,cur_data,'A');

% --- Executes during object creation, after setting all properties.
function Board4_A_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_A_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_B_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_B_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_B_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_B_input,cur_data,'B');

% --- Executes during object creation, after setting all properties.
function Board4_B_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_B_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_C_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_C_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_C_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_C_input,cur_data,'C');

% --- Executes during object creation, after setting all properties.
function Board4_C_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_C_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_D_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_D_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_D_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_D_input,cur_data,'D');

% --- Executes during object creation, after setting all properties.
function Board4_D_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_D_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_E_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_E_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_E_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_E_input,cur_data,'E');

% --- Executes during object creation, after setting all properties.
function Board4_E_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_E_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Board4_sweep.
function Board4_sweep_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_sweep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino4_sent;

Board4_clear_Callback(handles.Board4_clear, eventdata,handles);

if ~strcmp(arduino4_sent.port,'NULL')
    fprintf(arduino4_sent,'%s','q\n');
    set(handles.Display_text,'String','Board 4 Current Sweeping');
else
    set(handles.Display_text,'String','Board 4 Arduino Not connected. Sweeping fails.');
end

% --- Executes on button press in Board4_clear.
function Board4_clear_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global arduino4_sent;

if ~strcmp(arduino4_sent.port,'NULL')
    fprintf(arduino4_sent,'%s','z\n');
    fprintf(arduino4_sent,'%s','x\n');
    set(handles.Board4_A,'String','A');
    set(handles.Board4_B,'String','B');
    set(handles.Board4_C,'String','C');
    set(handles.Board4_D,'String','D');
    set(handles.Board4_E,'String','E');
    set(handles.Board4_F,'String','F');
    set(handles.Board4_G,'String','G');
    set(handles.Board4_H,'String','H');
    set(handles.Board4_I,'String','I');
    set(handles.Board4_J,'String','J');
    set(handles.Board4_A,'BackgroundColor','white');
    set(handles.Board4_B,'BackgroundColor','white');
    set(handles.Board4_C,'BackgroundColor','white');
    set(handles.Board4_D,'BackgroundColor','white');
    set(handles.Board4_E,'BackgroundColor','white');
    set(handles.Board4_F,'BackgroundColor','white');
    set(handles.Board4_G,'BackgroundColor','white');
    set(handles.Board4_H,'BackgroundColor','white');
    set(handles.Board4_I,'BackgroundColor','white');
    set(handles.Board4_J,'BackgroundColor','white');
    set(handles.Board4_A_input,'String','0');
    set(handles.Board4_B_input,'String','0');
    set(handles.Board4_C_input,'String','0');
    set(handles.Board4_D_input,'String','0');
    set(handles.Board4_E_input,'String','0');
    set(handles.Board4_F_input,'String','0');
    set(handles.Board4_G_input,'String','0');
    set(handles.Board4_H_input,'String','0');
    set(handles.Board4_I_input,'String','0');
    set(handles.Board4_J_input,'String','0');
    set(handles.Display_text,'String','Reset all Board 4 channel current to zero');
else
    set(handles.Display_text,'String','Board 4 Arduino Not connected. Reset fails.');
end


function Board4_receive_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_receive_port as text
%        str2double(get(hObject,'String')) returns contents of Board4_receive_port as a double
global serial_ports_receive;
serial_ports_receive(4) = cellstr(Board_receive_port(handles.Display_text,handles.Arduino_Connection,hObject));

% --- Executes during object creation, after setting all properties.
function Board4_receive_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board4_sent_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_sent_port as text
%        str2double(get(hObject,'String')) returns contents of Board4_sent_port as a double
global serial_ports_sent;
serial_ports_sent(4) = cellstr(Board_sent_port(handles.Display_text,handles.Arduino_Connection,hObject));


% --- Executes during object creation, after setting all properties.
function Board4_sent_port_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_sent_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_F_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_F_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_F_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_F_input,cur_data,'F');

% --- Executes during object creation, after setting all properties.
function Board1_F_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_G_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_G_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_G_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_G_input,cur_data,'G');

% --- Executes during object creation, after setting all properties.
function Board1_G_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_H_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_H_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_H_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_H_input,cur_data,'H');

% --- Executes during object creation, after setting all properties.
function Board1_H_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board1_I_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_I_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_I_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_I_input,cur_data,'I');

% --- Executes during object creation, after setting all properties.
function Board1_I_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board1_J_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_J_input as text
%        str2double(get(hObject,'String')) returns contents of Board1_J_input as a double
global resistance;
global arduino1_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768);

Data_sent(arduino1_sent,handles.Board1_J_input,cur_data,'J');

% --- Executes during object creation, after setting all properties.
function Board1_J_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board1_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_J_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_J_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_J_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_J_input,cur_data,'J');

% --- Executes during object creation, after setting all properties.
function Board2_J_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_I_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_I_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_I_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_I_input,cur_data,'I');

% --- Executes during object creation, after setting all properties.
function Board2_I_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_H_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_H_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_H_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_H_input,cur_data,'H');

% --- Executes during object creation, after setting all properties.
function Board2_H_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_G_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_G_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_G_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_G_input,cur_data,'G');

% --- Executes during object creation, after setting all properties.
function Board2_G_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board2_F_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board2_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board2_F_input as text
%        str2double(get(hObject,'String')) returns contents of Board2_F_input as a double
global resistance;
global arduino2_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino2_sent,handles.Board2_F_input,cur_data,'F');

% --- Executes during object creation, after setting all properties.
function Board2_F_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board2_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_F_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_F_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_F_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_F_input,cur_data,'F');

% --- Executes during object creation, after setting all properties.
function Board3_F_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_G_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_G_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_G_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_G_input,cur_data,'G');

% --- Executes during object creation, after setting all properties.
function Board3_G_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_H_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_H_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_H_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_H_input,cur_data,'H');

% --- Executes during object creation, after setting all properties.
function Board3_H_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_I_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_I_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_I_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_I_input,cur_data,'I');

% --- Executes during object creation, after setting all properties.
function Board3_I_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board3_J_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board3_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board3_J_input as text
%        str2double(get(hObject,'String')) returns contents of Board3_J_input as a double
global resistance;
global arduino3_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino3_sent,handles.Board3_J_input,cur_data,'J');

% --- Executes during object creation, after setting all properties.
function Board3_J_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board3_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_F_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_F_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_F_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_F_input,cur_data,'F');

% --- Executes during object creation, after setting all properties.
function Board4_F_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board4_G_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_G_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_G_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_G_input,cur_data,'G');

% --- Executes during object creation, after setting all properties.
function Board4_G_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_H_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_H_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_H_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_H_input,cur_data,'H');

% --- Executes during object creation, after setting all properties.
function Board4_H_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board4_I_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_I_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_I_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_I_input,cur_data,'I');

% --- Executes during object creation, after setting all properties.
function Board4_I_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board4_J_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board4_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board4_J_input as text
%        str2double(get(hObject,'String')) returns contents of Board4_J_input as a double
global resistance;
global arduino4_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino4_sent,handles.Board4_J_input,cur_data,'J');

% --- Executes during object creation, after setting all properties.
function Board4_J_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board4_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board5_J_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_J_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_J_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_J_input,cur_data,'J');

% --- Executes during object creation, after setting all properties.
function Board5_J_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_J_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board5_I_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_I_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_I_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_I_input,cur_data,'I');

% --- Executes during object creation, after setting all properties.
function Board5_I_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_I_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board5_H_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_H_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_H_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_H_input,cur_data,'H');

% --- Executes during object creation, after setting all properties.
function Board5_H_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_H_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Board5_G_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_G_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_G_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_G_input,cur_data,'G');

% --- Executes during object creation, after setting all properties.
function Board5_G_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_G_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Board5_F_input_Callback(hObject, eventdata, handles)
% hObject    handle to Board5_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board5_F_input as text
%        str2double(get(hObject,'String')) returns contents of Board5_F_input as a double
global resistance;
global arduino5_sent;

input = str2double(get(hObject,'String'));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino5_sent,handles.Board5_F_input,cur_data,'F');

% --- Executes during object creation, after setting all properties.
function Board5_F_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Board5_F_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Emergency_Stop.
function Emergency_Stop_Callback(hObject, eventdata, handles)
% hObject    handle to Emergency_Stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 Board1_clear_Callback(handles.Board1_clear, eventdata,handles);
 Board2_clear_Callback(handles.Board2_clear, eventdata,handles);
 Board3_clear_Callback(handles.Board3_clear, eventdata,handles);
 Board4_clear_Callback(handles.Board4_clear, eventdata,handles);
 Board5_clear_Callback(handles.Board5_clear, eventdata,handles);
 set(handles.Display_text,'String','All channel clear! System Halt.');
