
function [params_series,params_dcm] = standar_params_generator_timeseries()
        % Load timeseries parameters
        params_series = [];
        frequency = 10.4;  % FPS 
        timesteps = 300;   % Total of timesteps to compute
        params_series = [params_series,frequency];
        params_series = [params_series,timesteps];
        
        % Load dcm parameters
        params_dcm = [];
        A = [0.01 0.90
             0.01 0.01];
        B =[-0.02 -0.77
             0.33 -1.31];
            
        C = [1.0 1
             1.0 1];
        params_dcm = [params_dcm,A];
        params_dcm = [params_dcm,B];
        params_dcm = [params_dcm,C];

        
end

