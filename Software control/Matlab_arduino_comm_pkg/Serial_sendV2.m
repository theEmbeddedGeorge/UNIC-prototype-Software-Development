%% File information %%
%Author: George LI 
%Crete date: 10/25/2015
%Version number: 01 
%File description: To read 32*40 voltage data ranged between -5V - 5V from 
%Excel file and convert them to 16-bit unsigned number and send to arduino
%Note: work with 'Serial_read' arduino script 

%% %%%%%%%%%%%%%%Function Parameters%%%%%%%%%%%%%%%%%% %%

Num_dac = 10; %specify Dac num
Data_sequence = 40; %specify data sequence num (rows of excel)
Size = Num_dac*Data_sequence; %total element number in the excel file  
Serial_port = 'COM9'; %specify serial port
BaudRate = 57600; %specify BaudRate
Vmax = 5; %specify the max voltage value allowed
Vmin = -5; %specify the min voltage value allowed
beep on; %enable the warning/error sound to be on

arduino = serial(Serial_port);  %setup serial port communication
set(arduino,'BaudRate',BaudRate);  %setup serial port baudRate
resistance = 0.25;

Volt_data = []; %Dac voltage values from excel
Volt_sent = []; %Dac voltage data to be sent

Excel = 'Test.xlsx'; %specify excel file name
Volt_data = xlsread(Excel); %read in Dac voltage values
disp('Excel format imported!'); %display msg
[rows, columns] = size(Volt_data); %get the row and column num of excel file
    
%% %%%%%%%%%%Excel voltage data conversion/format checking%%%%%%%%%% %%

%check whether the excel format matches with the hard ware setting
display('Excel column #:');
display(columns);
display('Excel row #:');
display(rows);

% if (columns == Num_dac && rows == Data_sequence)
%     display('Excel format matches!');
% else 
%     error('Excel format does not match the system seting!');
% end 

%%check and send data
fopen(arduino); %'open up' the serial port object 
pause(2); %wait for some time for arduino to get ready (very important!)

for i=1:rows
    for j=1:columns
        if Volt_data(i,j) > Vmax
            Volt_data(i,j) = 5;
            msg = 'Find values exceed 5V!';
            warning(msg);
        elseif Volt_data(i,j)< Vmin
            Volt_data(i,j) = -5;
            msg = 'Find values smaller than -5V!';
            warning(msg);
        end
        Volt_sent(i,j) = 32768 + round(Volt_data(i,j)*resistance/5.0*32768);
        fprintf(arduino,'%s',strcat(int2str(Volt_sent(i,j)),'\n'));
    end
end          

fprintf(arduino,'%s','end\n');
display('Voltage data sent!');

%% %%%%%%%%%%%%%%%%%%%Monitor the data arduino had received%%%%%%%%%% %%
% This section can be deleted in the future 
t = 1; %iterator for looping
data_count = 0;

while (t <= 1000) %loop 32*40 times. Each time receive one data   
    if arduino.BytesAvailable
        data_count = data_count + 1;
        temp = fscanf(arduino,'%s');
        display(temp);
    end 
    t = t + 1;
end

%% 
display('Process finish! Data ready to be checked!');

fclose(arduino);
delete(arduino);


