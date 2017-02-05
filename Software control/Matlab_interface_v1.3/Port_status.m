function port_bool = Port_status(serial_port_1_receive,serial_port_2_receive,...
    serial_port_3_receive,serial_port_4_receive,...
    serial_port_5_receive,serial_port_1_sent,serial_port_2_sent,serial_port_3_sent,...
    serial_port_4_sent,serial_port_5_sent)
    if ~strcmp(serial_port_1_receive,'NULL') ||...
        ~strcmp(serial_port_2_receive,'NULL') || ~strcmp(serial_port_3_receive,'NULL')...
     || ~strcmp(serial_port_4_receive,'NULL') || ~strcmp(serial_port_5_receive,'NULL')...
      || (~strcmp(serial_port_1_sent,'NULL') || ~strcmp(serial_port_2_sent,'NULL')...
       || ~strcmp(serial_port_3_sent,'NULL') || ~strcmp(serial_port_4_sent,'NULL')...
         || ~strcmp(serial_port_5_sent,'NULL'))
        port_bool = 1;
    else 
        port_bool = 0;
    end