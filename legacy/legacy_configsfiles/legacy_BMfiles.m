function [params] = legacy_BMfiles(pathfile)
     try
        fid = fopen(pathfile); 
        raw = fread(fid,inf); 
        str = char(raw'); 
        fclose(fid); 
        params = jsondecode(str);
        disp("Loading");
    catch
       disp( "There are an erro wirh the config file");
       params = 0;
       log = "NAda";
    end
end