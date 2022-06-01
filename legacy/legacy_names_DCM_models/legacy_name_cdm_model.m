function [params_series,params_dcm,status,log] = legacy_name_cdm_model(name, verbose)
    if name == "Tak"
        [params_series, params_dcm] = standar_params_generator_timeseries();
        status = true;
        log = "Return model params for Tak example";
    elseif name == "O"
        [params_series, params_dcm] = standar_params_generator_timeseries();
        status = true;
        log = "Return model params for o example";
    else
        [params_series, params_dcm] = standar_params_generator_timeseries();
        status = false;
        log = "No valid name";
    end
    %if verbose 
        %disp("[legacy_name_cdm_model] ",log)
    %end
end