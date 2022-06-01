%% [get_schema_bm] 
% This script return the outputs for a bilinear model schema

%% Autors:
% Instituto Nacional de Astrofísica Óptica y Electrónica
% Departamento de ciencias computacioanles.
% A.Rocha-Solache F.Orihuela-Espina, G.Rodríguez-Gómez
% rochasolache@inaoep.mx
%% Log activity:
% 31 - May - 2021 : Creation file
%   
%% Biblio
% [Tak S.] - Tak,S., Kempny,A., Friston,K.J., Leff,A.P., & Penny,W.D. 
%            (2015). Dynamic causal modelling for functional near-infrared
%            spectroscopy. Neuroimage, 111, 338-349.


function [p,q,status,log] = get_BM_by_name(name,verbose)

    [params_series,params_dcm,status_name,v] = legacy_name_cdm_model(name,verbose);
    if status_name 
        
        %% Model Tak params
        freq = params_series(1);
        A = params_dcm(1);
        B = params_dcm(2);
        C = params_dcm(3);
        disp(A);
        disp(B);
        disp(C);
        
        
        %% Generate Series
        [U, timestamps] = getinputs(freq, 5, 25, 2); 

        %% DCM start!
        %% Neurodynamics
        [Z] = Neurodynamics(A,B,C,U, 1/freq);

        %% Hemodynamic
        P_SD = [0.5 0.5 0.5 3];
        [P,Q] = Hemodynamic(Z, U, P_SD, A,1/freq);

        %% Optic
        Noise = 0;
        [OR] = OpticLib( P,Q,U,A,Noise); 

        %% Display results
        if (verbose_plot == true)
            BilinearPlotThetaA(A,B,C,U,Z,P,OR);
        end
         
    else
        log = "Incorrect name provided";
        status = false;
    end
end
