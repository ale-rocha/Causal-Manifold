function ds2 = minkowski_cylindrical(time1,time2,phase1, phase2,energy1, energy2)
    ds2 = (2*time1*time2*(1-cos(phase2-phase1)))-power((energy2-energy1),2);
    %ds2 = power(time2-time1,2) - power((time2*phase2 - time1*phase1),2) - power(energy2-energy1,2);
%https://sagemanifolds.obspm.fr/exampl^^es.html