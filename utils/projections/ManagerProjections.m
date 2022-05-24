
function projection = ManagerProjections(cloud,norm)
   projection = [];
   obj_distances = get(cloud,"Matrix_Distances");
   
   
   for i = 1:length(obj_distances)
       
       distances = get(obj_distances(i),"Matrix");
       names_distances =  get(obj_distances(i),"NameRelations");
       
       disp("*******************************");
       disp(size(distances));
       p = compute_projection(distances);

       
       obj_proyection = Projection;
       obj_proyection.Name = norm(i);
       obj_proyection.X = p(:,1);
       obj_proyection.Y = p(:,2);
       obj_proyection.NameRelations = names_distances(i);
       projection = [projection, obj_proyection];
   end
   return
end

function p = compute_projection(matrix)
    disp(matrix);
    p = cmdscale(matrix);
    %p = cmdscale(cell2mat(matrix));
    return
end