function x = Board_sent_port(handles_Display_text,handles_Arduino_Connection,hObject)
    port = get(hObject,'String');
    if ~isempty(port) && strcmp(port(1:3),'COM')
        x = get(hObject,'String');
        %set(handles.Current_Monitor,'String','Current Monitor');
        set(handles_Display_text,'String','Arduino Connection Avaliable')
        set(handles_Arduino_Connection, 'enable','on');
    else 
        beep;
        x = 'NULL';
        set(handles_Display_text,'String','Invalid Port');
        % Give the edit text box focus so user can correct the error
        uicontrol(hObject)
    end