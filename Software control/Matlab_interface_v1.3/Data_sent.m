function [] = Data_sent(arduino,board_input,cur_data,channel)
    if ~strcmp(arduino.port,'NULL')
        data_sent = strcat(channel,int2str(cur_data),'\n');
        fprintf(arduino,'%s',data_sent);
        fprintf(arduino,'%s','x\n');
    else
        set(board_input,'String','Port?')
    end