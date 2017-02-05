clc

%%%%%%%%%%%%%%Constant and array declaration%%%%%%%%%%%%%%%%%

Num_dac = 32; %suppose there are 32 Dacs
Data_sequence = 40; %suppose there will be 40 sequence of voltage input
Serial_port = 'COM3';
BaudRate = 9600;
Temp_limit = 50;
beep on; %enable the warning/error sound to be on

Dac_temp = zeros(1,Num_dac); %Dac temperature data to be saved 
Volt_data = []; %Dac voltage values from excel
Volt_send = []; %Dac voltage data to be sent
Dac_volt = zeros(1,Num_dac); %Voltage each dac outputs

%%%%%%%%%%%%%%Arduino connection setup%%%%%%%%%%%%%%%%%%%

% arduino = serial(Serial_port);  %specify the Serial port to be used
% set(arduino,'BaudRate',9600);  %setup the serial rate used to talk to arduino
% set(arduino,'Terminator','CR'); %Change the Terminator property to make it faster
% display('Arduino connected!');
% display(Serial_port);
% display(BaudRate);


%%%%%%%%%%%%%%%%%%Temperature data read/Draw out%%%%%%%%%%%%%%%%%

fopen(arduino);  
A = fscanf(arduino,'%s');
%read in temperature data from arduino, the string data series start with T
%When it detects T, it starts to fill in the temp array
if A(1) == 'T' 
    for i = 2:length(Dac_temp)+1
        Dac_temp(i) = str2double(A(i));
    end 
end
        
fclose(Test);


% b_graph = bar(Dac_temp,'b');
% hold on;
% plot(xlim,[50 50], 'r');
% xlabel('Dac number');
% ylabel('Temperature (celsius)');
% grid on;
% 
% for i=1:length(Dac_temp) %if unusual temperature is detected 
%     if Dac_temp(i)>Temp_limit
%         %set(b_graph(i),'FaceColor', 'red');
%         beep;
%         warning('Unusual Dac Temperature!!!');
%     end
% end
% 
% linkdata on; %refresh the bar diagram whenever the input is refreshed


