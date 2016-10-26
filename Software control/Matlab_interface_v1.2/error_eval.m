function [] = error_eval(x,y,temp1,temp1_double,error_tolerance)
     set(x,'String',temp1(2:end));
     val_str = get(y,'String');
     val = str2double(val_str);
     diff = abs(val - temp1_double);
    if  ~isnan(str2double(val_str)) && ...
         abs(temp1_double) > 1.0 && diff > ...
             abs(error_tolerance/100.0*val)
         set(x,'BackgroundColor','red');
    else
         set(x,'BackgroundColor','green');
    end