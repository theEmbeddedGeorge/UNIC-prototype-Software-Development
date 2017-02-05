function arduino = Port_open(serial_port,baudrate)
        arduino = serial(serial_port);
        set(arduino,'BaudRate',baudrate)
        if ~strcmp(serial_port,'NULL')
            fopen(arduino);
        end
