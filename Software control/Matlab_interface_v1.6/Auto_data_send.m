function Auto_data_send = Auto_data_send(handles_input_callback,handles_input,data,evendtdata)
    set(handles_input,'String',char(data));
    handles_input_callback(handles_input);