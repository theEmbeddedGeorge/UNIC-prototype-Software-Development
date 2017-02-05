%%%%%%%%%%%%%%%%%Excel data read in function%%%%%%%%%%%%%%%%

function excel_read(Volt_data,Data_sequence,Num_dac)

Excel = 'Test.xlsx';
Volt_data = xlsread(Excel);
disp('Excel format imported!');
 
[rows, columns] = size(Volt_data);
%excel sheet format check (must be 40 by 32, or display error msg)
if rows ~= Data_sequence || columns ~= Num_dac
    msg = 'Excel format not match!';
    beep;
    error(msg);
else 
    disp('Excel format correct!');
end