
function vec_manager_distancesFinal = causal_freq(cloud)

    %Calculamos la tranformada en tiempo corto de fourier
    
    
    
    vec_manager_distancesFinal = [];
    % P - NORMS
    for n = 1:length(norms)
        vec_manager_distances = [];
        if norms(n) == "pnorm1" || norms(n) == "pnorm2" || norms(n) == "pnorm5"
            disp("Calculando distancia pnorm")
            vec_manager_distances = [vec_manager_distances,MatrixDistances(cloud, norms(n))];
        end
        if norms(n) == "cosine"
            disp("Calculando distancia cosine")
            vec_manager_distances = [vec_manager_distances, MatrixDistancesCosine(cloud, norms(n))];
        end
        if norms(n) == "correlation"
            disp("Calculando distancia correlation")
            vec_manager_distances = [vec_manager_distances, MatrixDistancesCorrelaton(cloud, norms(n))];
        end
        if norms(n) == "cylindrical" || norms(n) == "geodesical"
            disp("Calculando distancia geodesical")
            vec_manager_distances = [vec_manager_distances, MatrixDistancesCylindrical(cloud, norms(n))];
        end
        vec_manager_distancesFinal = [vec_manager_distancesFinal, vec_manager_distances];
    end
end