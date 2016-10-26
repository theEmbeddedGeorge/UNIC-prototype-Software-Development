function cur_data = Data_conversion(hObject,resistance,x1,x2,b)
    input = str2double(get(hObject,'String'));
    if isnan(input)
        input = 0; 
    end 
    input = input*resistance;
    cur_data = x1*(input*input) + x2*input + b; %customized for each channel
    