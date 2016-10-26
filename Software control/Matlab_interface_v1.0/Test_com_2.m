Serial_port = 'COM3';
BaudRate = 9600;
arduino = serial(Serial_port,'BaudRate',BaudRate);  %specify the Serial port to be used
i = 1;
j = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Excel = 'Test.xlsx'; %specify excel file name
Volt_data = xlsread(Excel); %read in Dac voltage values
disp('Excel format imported!'); %display msg
[rows, columns] = size(Volt_data); %get the row and column num of excel file

Volt_send = [];
receive_data = zeros(rows,columns);

for i=1:rows
    for j=1:columns
        %Convert -5 - 5 to 0 - 65535, all values need to be integer
        Volt_send(i,j) = 32768 + round(Volt_data(i,j)/5.0*32768); 
    end
end    
display('Dac Voltage value conversion completed!');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fopen(arduino);
pause(2); %give some time for the arduino to setup

for i=1:rows
   for j=1:columns
       data = Volt_send(i,j);
       %fprintf(arduino,'%c',data); %has to send char type!!! arduino serial only read one byte (char)
       fwrite(arduino, data, 'uint16'); %uint8 for char
   end
end 

t = 1;

while(t <= 1280)%%numel(Volt_send)) 
    if(arduino.BytesAvailable)
        val = str2num(fscanf(arduino));
        New_receive(t) = val;
        t = t+1;
    end 
end

fclose(arduino);

