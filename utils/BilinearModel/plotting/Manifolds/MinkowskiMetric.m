function [timelikeX,timelikeY,timelikeZ] = MinkowskiMetric(phase1,energy1,time1)


    %ingresa un punto que representa el vertice del cono del punto
    %el objetivo es evaluar todos los puntos y plotear solo aquellos que
    %son timelike, es decir D>0
    
    %Rangos
    % freq (0,10)
    % phase (0,2pi)
    % time (0,5)
    
    timelikeX=[]; timelikeY=[]; timelikeZ=[];
    for energy2 = 0:0.1:5
        for phase2 = 0:0.1:2*pi
            for time2 = time1:0.2:6
            %%Calcular la distancia del punto con el de referencia
            d2 = minkowski_cylindrical(time1,time2,phase1, phase2,energy1,energy2);
            disp("Distance");
            disp(d2);
            if d2 >= 0 %&& time2>time2 
                %Guardarlas en carteanas para que sea mas sencillo
                %imprimirlas en el plot
                [x,y,z]=point_cylindrical_to_cartesian(phase2,energy2,time2);
                timelikeX=[timelikeX,x];
                timelikeY=[timelikeY,y];
                timelikeZ=[timelikeZ,z];
            end
            end 
        end
    end
    return;
 
end
