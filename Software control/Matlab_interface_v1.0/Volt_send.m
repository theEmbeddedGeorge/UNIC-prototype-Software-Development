%%%%%%%%%%%%%%%%%Excel data send out%%%%%%%%%%%%%%%%%%%%%%%%

function Volt_send(Volt_data,arduino)

[rows, columns] = size(Volt_data);
%Data check before convertsion
for i=1:rows
    for j=1:columns
        if Volt_data(i,j)>5
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

for i=1:rows
    for j=1:columns
        %Convert -5 - 5 to 0 - 65535, all values need to be integer
        Volt_send(i,j) = 32768 + round(Volt_data(i,j)/5.0*32768); 
    end
end    

display('Dac Voltage value conversion completed!');

fopen(arduino)

for i=1:rows
  for j=1:columns
    fprintf(arduino,'%d',Volt_send(i,j)); %send out the voltage data
  end
end
display('Voltage data sent!'); 

fclose(arduino);

