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

% Last Modified by GUIDE v2.5 07-Jul-2016 15:56:15

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
set(handles.Arduino_Connection,'Enable','off');
set(handles.Volt_send,'Enable','off');
set(handles.Disconnect,'Enable','off');
set(handles.Current_Monitor,'Enable','off');

%Turn off useful buttons of each board before connection is set up
set(handles.Board1_clear,'enable','off');
set(handles.Board1_sweep,'enable','off'); 

set(handles.Display_text,'String','Parameter Initialization and arduino connection required');
global TempMax;
global Num_dac; 
global Num_slice;
global signal;
global refresh_rate; %how fast the bar graph get freshed
global serial_port;
global serial_port_1_receive;
global serial_port_2_receive;
global serial_port_3_receive;
global serial_port_4_receive;
global serial_port_5_receive;
global serial_port_1_sent;
global serial_port_2_sent;
global serial_port_3_sent;
global serial_port_4_sent;
global serial_port_5_sent;
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
global resistance; 
global error_tolerance;

TempMax = 0;
Num_dac = 0;
Num_slice = 0;
signal = 1;
refresh_rate = 0.025; %the refreshing rate must be smaller than the sensing rate
resistance = 0.25;
error_tolerance = 20;
serial_port = 'NULL';
serial_port_1_receive = 'NULL';
serial_port_2_receive = 'NULL';
serial_port_3_receive = 'NULL';
serial_port_4_receive = 'NULL';
serial_port_5_receive = 'NULL';
serial_port_1_sent = 'NULL';
serial_port_2_sent = 'NULL';
serial_port_3_sent = 'NULL';
serial_port_4_sent = 'NULL';
serial_port_5_sent = 'NULL';

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
global serial_port_1_receive;
global serial_port_2_receive;
global serial_port_3_receive;
global serial_port_4_receive;
global serial_port_5_receive;
global serial_port_1_sent;
global serial_port_2_sent;
global serial_port_3_sent;
global serial_port_4_sent;
global serial_port_5_sent;
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

% if ~strcmp(serial_port_1_receive,'NULL') ||...
%         ~strcmp(serial_port_2_receive,'NULL') || ~strcmp(serial_port_3_receive,'NULL')...
%      || ~strcmp(serial_port_4_receive,'NULL') || ~strcmp(serial_port_5_receive,'NULL')...
%       || (~strcmp(serial_port_1_sent,'NULL') || ~strcmp(serial_port_2_sent,'NULL')...
%        || ~strcmp(serial_port_3_sent,'NULL') || ~strcmp(serial_port_4_sent,'NULL')...
%          || ~strcmp(serial_port_5_sent,'NULL'))
  if Port_status(serial_port_1_receive,serial_port_2_receive,...
        serial_port_3_receive,serial_port_4_receive,...
        serial_port_5_receive,serial_port_1_sent,serial_port_2_sent,serial_port_3_sent,...
        serial_port_4_sent,serial_port_5_sent)

        set(handles.Current_Monitor,'String','Monitor Current');
        set(handles.Current_Monitor,'Enable','on');
        set(handles.Volt_send,'String','Upload Voltage File');
        set(handles.Volt_send,'Enable','on');
        set(handles.Disconnect,'String','Arduino Disconnect and reset');
        set(handles.Disconnect,'Enable','on');
        set(handles.Arduino_Connection,'Enable','off');
        set(handles.Display_text,'String','Arduino Connection built');
        %Turn on useful button for each brd 
        set(handles.Board1_clear,'enable','on');
        set(handles.Board1_sweep,'enable','on'); 
        
        arduino1_receive = Port_open(serial_port_1_receive,9600);
        arduino2_receive = Port_open(serial_port_2_receive,9600);
        arduino3_receive = Port_open(serial_port_3_receive,9600);
        arduino4_receive = Port_open(serial_port_4_receive,9600);
        arduino5_receive = Port_open(serial_port_5_receive,9600);
        arduino1_sent = Port_open(serial_port_1_sent,57600);
        arduino2_sent = Port_open(serial_port_2_sent,57600);
        arduino3_sent = Port_open(serial_port_3_sent,57600);
        arduino4_sent = Port_open(serial_port_4_sent,57600);
        arduino5_sent = Port_open(serial_port_5_sent,57600);
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

global Num_slice;
global signal;
global serial_port_1_receive;
global serial_port_2_receive;
global serial_port_3_receive;
global serial_port_4_receive;
global serial_port_5_receive;
global serial_port_1_sent;
global serial_port_2_sent;
global serial_port_3_sent;
global serial_port_4_sent;
global serial_port_5_sent;
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

serial_port_1_receive = 'NULL';
serial_port_2_receive = 'NULL';
serial_port_3_receive = 'NULL';
serial_port_4_receive = 'NULL';
serial_port_5_receive = 'NULL';
serial_port_1_sent = 'NULL';
serial_port_2_sent = 'NULL';
serial_port_3_sent = 'NULL';
serial_port_4_sent = 'NULL';
serial_port_5_sent = 'NULL';

set(handles.Arduino_Connection,'Enable','off');
set(handles.Current_Monitor,'Value',0);
set(handles.Current_Monitor,'Enable','off');
set(handles.Volt_send,'Enable','off');
set(handles.Disconnect,'Enable','off');
set(handles.Board1_clear,'enable','off');
set(handles.Board1_sweep,'enable','off'); 

set(handles.Error_tolerance_text,'String','Error_tolerance (%)');
set(handles.Slice_text,'String','Slice Number');

set(handles.Display_text,'String','System parameters reset.');

%reset port_text of each board
set(handles.Board1_sent_port,'String','Upload port');
set(handles.Board1_receive_port,'String','Monitor port');

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

Num_slice = 0;
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
    set(handles.Error_tolerance_text,'String','Not a number');
    uicontrol(hObject);
else
   if (doub_val < 0 || doub_val > 100) 
       set(handles.Error_tolerance_text,'String','Exceed allowable range');
       uicontrol(hObject);
   else
       error_tolerance = doub_val;
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
  
else
    set(handles.Display_text,'String','Current Monitoring Stop.');
end

while (button_state == get(hObject,'Max') && (ad_val1 == 1 || ad_val2...
    ==1 || ad_val3 == 1 || ad_val4 == 1 || ad_val5 ==1)) 
 %if toggle button is pushed and detect arduino conection 
    set(handles.Display_text,'String','Current Monitoring starts.');
    if ~get(hObject, 'Value')
       button_state = 0;
    end
     
    if arduino1_receive.BytesAvailable val1 = cellstr(fscanf(arduino1_receive)); end
    if arduino2_receive.BytesAvailable val2 = cellstr(fscanf(arduino2_receive)); end
    if arduino3_receive.BytesAvailable val3 = cellstr(fscanf(arduino3_receive)); end
    if arduino4_receive.BytesAvailable val4 = cellstr(fscanf(arduino4_receive)); end
    if arduino5_receive.BytesAvailable val5 = cellstr(fscanf(arduino5_receive)); end
        
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
                       error_eval(handles.Board1_A,handles.Board1_A_input,temp1,temp1_double,error_tolerance);
                 case 'B'
                       error_eval(handles.Board1_B,handles.Board1_B_input,temp1,temp1_double,error_tolerance);
                 case 'C'
                       error_eval(handles.Board1_C,handles.Board1_C_input,temp1,temp1_double,error_tolerance);
                 case 'D'
                       error_eval(handles.Board1_D,handles.Board1_D_input,temp1,temp1_double,error_tolerance);
                 case 'E'
                       error_eval(handles.Board1_E,handles.Board1_E_input,temp1,temp1_double,error_tolerance);
             end 
        end
       %%Read board 2 current vals
       if ad_val2 == 1
           %for i = 1:5
             temp2 = char(Cur_array_2(iter));
             switch temp2
                 %Board 2 code goes here 
             end 
           %end
       end
       %%Read board 3 current vals
       if ad_val3 == 1
           %for i = 1:5
             temp3 = char(Cur_array_3(iter));
             switch temp3
               %Board 3 code goes here 
             end 
           %end
       end
       %%Read board 4 current vals
       if ad_val4 == 1
           %for i = 1:5
             temp4 = char(Cur_array_4(iter));
             switch temp4
                %Board 4 code goes here 
             end 
           %end
       end
       %%Read board 5 current vals
       if ad_val5 == 1
           %for i = 1:5
             temp5 = char(Cur_array_5(iter));
             switch temp5
                %Board 5 code goes here 
             end 
           %end
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
%set(hObject,'String',num2str(input));
cur_data = 32768 + round(input*resistance/5.0*32768); %customized for each channel

Data_sent(arduino1_sent,handles.Board1_A_input,cur_data,'A');
% if ~strcmp(arduino1_sent.port,'NULL')
%     data_sent = strcat('A',int2str(cur_data),'\n');
%     fprintf(arduino1_sent,'%s',data_sent);
%     fprintf(arduino1_sent,'%s','x\n');
% else
%     set(handles.Board1_A_input,'String','Port?')
% end

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
% if ~strcmp(arduino1_sent.port,'NULL')
%     data_sent = strcat('B',int2str(cur_data),'\n');
%     fprintf(arduino1_sent,'%s',data_sent);
%     fprintf(arduino1_sent,'%s','x\n');
% else
%     set(handles.Board1_B_input,'String','Port?')
% end

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
% if ~strcmp(arduino1_sent.port,'NULL')
%     data_sent = strcat('C',int2str(cur_data),'\n');
%     fprintf(arduino1_sent,'%s',data_sent);
%     fprintf(arduino1_sent,'%s','x\n');
% else
%     set(handles.Board1_C_input,'String','Port?')
% end

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
% if ~strcmp(arduino1_sent.port,'NULL')
%     data_sent = strcat('D',int2str(cur_data),'\n');
%     fprintf(arduino1_sent,'%s',data_sent);
%     fprintf(arduino1_sent,'%s','x\n');
% else
%     set(handles.Board1_D_input,'String','Port?')
% end

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
% if ~strcmp(arduino1_sent.port,'NULL')
%     data_sent = strcat('E',int2str(cur_data),'\n');
%     fprintf(arduino1_sent,'%s',data_sent);
%     fprintf(arduino1_sent,'%s','x\n');
% else
%     set(handles.Board1_E_input,'String','Port?')
% end

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

if ~strcmp(arduino1_sent.port,'NULL')
    fprintf(arduino1_sent,'%s','q\n');
    set(handles.Display_text,'String','Current Sweeping');
else
    set(handles.Display_text,'String','Arduino Not connected. Sweeping fails.');
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
    set(handles.Board1_A_input,'String','0');
    set(handles.Board1_B_input,'String','0');
    set(handles.Board1_C_input,'String','0');
    set(handles.Board1_D_input,'String','0');
    set(handles.Board1_E_input,'String','0');
    set(handles.Display_text,'String','Reset all channel current to zero');
else
    set(handles.Display_text,'String','Arduino Not connected. Reset fails.');
end


function Board1_receive_port_Callback(hObject, eventdata, handles)
% hObject    handle to Board1_receive_port (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Board1_receive_port as text
%        str2double(get(hObject,'String')) returns contents of Board1_receive_port as a double
global serial_port_1_receive;

port = get(hObject,'String');
if strcmp(port(1:3),'COM')
    serial_port_1_receive = get(hObject,'String');
    %set(handles.Current_Monitor,'String','Current Monitor');
    set(handles.Display_text,'String','Arduino Connection Avaliable')
    set(handles.Arduino_Connection, 'enable','on');
else 
    beep;
    set(handles.Board1_receive_port,'String','Invalid Port');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
end
    

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
global serial_port_1_sent;

port = get(hObject,'String');
if strcmp(port(1:3),'COM')
    serial_port_1_sent = get(hObject,'String');
    %set(handles.Current_Monitor,'String','Current Monitor');
    set(handles.Display_text,'String','Arduino Connection Avaliable');
    set(handles.Arduino_Connection, 'enable','on');
else 
    beep;
    set(handles.Board1_sent_port,'String','Invalid Port');
    % Give the edit text box focus so user can correct the error
    uicontrol(hObject)
end

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
