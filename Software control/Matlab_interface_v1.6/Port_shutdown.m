function [] = Port_shutdown(x)
if ~strcmp(x.port,'NULL')
    fclose(x);
    delete(x);
end 