Serial_port = 'COM3';
BaudRate = 9600;
arduino = serial(Serial_port,'BaudRate',BaudRate);  %specify the Serial port to be used
send = [3374,2212,2121,1240,2334,23456,35675,11245,13232,33456];
%set(arduino, 'FlowControl', 'none');
size = 10;
receive = zeros(1,size);
i = 1;
j = 1;

fopen(arduino);
pause(2); %give some time for the arduino to setup

while (j <= size)
   data = send(j);
   %fprintf(arduino,'%c',data); %has to send char type!!! arduino serial only read one byte (char)
   fwrite(arduino, data, 'uint16'); %uint8 for char
   j = j + 1;
end 

% pause (1); %give some time for arduino to respond 
t = 1;

while(t <= size) 
    if(arduino.BytesAvailable)
        val = str2num(fscanf(arduino));
        %val = fread(arduino, 'uint16');
        receive(i) = val;
        i = i+1;
        t = t+1;
    end 
end

fclose(arduino);
