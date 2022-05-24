
function [selected_phase] = get_phase(frequencies, spectre, target_freq,sec)
% Return the phase of specific frequency
% Params:
%       [frequencies]: Frequencies result of FT or STFT process
%       [spectre]: Energy of frequencies result of FT or STFT process
%       [target_freq]: 
%       [sec]
% Log: 6-Feb-2022@arocha : Creacion del archivo en carpeta fourier y
% documentación

%tol = 1e-6;
%z= spectre(:,sec);
%z(abs(z) < tol) = 0;
%Regresa la fase de una frecuencia determinada
phase = angle(spectre(:,sec));
phase = phase(length(phase)/2:(length(phase)));
freq =  frequencies(length(frequencies)/2:(length(frequencies)));
selected_phase=(phase(target_freq+1))+pi;
end