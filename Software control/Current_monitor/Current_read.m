Serial_port = 'COM3';
BaudRate = 9600;
arduino = serial(Serial_port,'BaudRate',BaudRate);  %specify the Serial port to be used
Cur_array = cell(1,5); %Array to receive the data 
doub_curr = zeros(1,5); %Data array in double type
x_name = {'A';'B';'C';'D';'E'}; %bar diagram x-axis labels

fopen(arduino);
pause(2); %give some time for the arduino to setup

t = 1;

while(t <= 50) %receive for 5s 
    if(arduino.BytesAvailable)
        val = cellstr(fscanf(arduino));
        if (mod(t,5) == 0)
            iter = 5;
        else 
            iter = mod(t,5);
        end 
        Cur_array(iter) = val;
        if (iter == 5)
            for i=1:5
                temp = char(Cur_array(i));
                doub_curr(i) = str2double(char(cellstr(temp(2:end))));
            end
            bar((1:5),doub_curr);
            set(gca,'xticklabel',x_name);   
        end
        t = t+1;
        pause(0.1);
    end 
end

fclose(arduino);
