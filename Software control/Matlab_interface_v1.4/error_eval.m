function [] = error_eval(x,y,temp1,temp1_double,error_tolerance,fid)
     set(x,'String',temp1(2:end));
     val_str = get(y,'String');
     val = str2double(val_str);
     diff = abs(val - temp1_double);
   if val > 7 || val < -7
      beep; 
      set(y,'String','Invalid');
   else
     if ~isnan(str2double(val_str))  
        if abs(temp1_double) < 1.0 
            set(x,'BackgroundColor','yellow');
        elseif diff < abs(error_tolerance/100.0*val)
            set(x,'BackgroundColor','green');
        else
            time = clock;
            fprintf(fid,'%d-%d-%d %d:%d:%d',time(1),time(2)...
                ,time(3),time(4),time(5),time(6));
            fprintf(fid,' %s input: %f output: %f Error: %f percent\n',...
                get(x,'tag'),val,temp1_double,diff/val*100);
            set(x,'BackgroundColor','red');
        end
     else 
         set(x,'BackgroundColor','white');
     end
   end