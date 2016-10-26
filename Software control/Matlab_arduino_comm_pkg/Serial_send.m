%% File information %%
%Author: George LI 
%Crete date: 10/25/2015
%Version number: 01 
%File description: To read 32*40 voltage data ranged between -5V - 5V from 
%Excel file and convert them to 16-bit unsigned number and send to arduino
%Note: work with 'Serial_read' arduino script 

%% %%%%%%%%%%%%%%Function Parameters%%%%%%%%%%%%%%%%%% %%

Num_dac = 32; %specify Dac num
Data_sequence = 40; %specify data sequence num (rows of excel)
Size = Num_dac*Data_sequence; %total element number in the excel file  
Serial_port = 'COM3'; %specify serial port
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

arduino = serial(Serial_port);  %setup serial port communication
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

%% %%%%%%%%%%%%%%%%%%%Monitor the data arduino had received%%%%%%%%%% %%
% This section can be deleted in the future 
received = zeros(1,Size); %array used to read data send back from arduino
t = 1; %iterator for looping

while (t <= Size) %loop 32*40 times. Each time receive one data   
    if arduino.BytesAvailable
        if t == 1
            display('Data received from arduino!!');
            load gong.mat; %play the signal music 
            sound(y);
        end
        temp = str2double(fscanf(arduino));
        received(t) = temp;
       %temp = fscanf(arduino);
        t = t + 1;
    end 
end

%% 
display('Process finish! Data ready to be checked!');

fclose(arduino);
delete(arduino);


