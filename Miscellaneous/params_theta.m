function [A,B,C] = params_theta(option)

   if (option == "Tak" )
            A = [0.01 0.90
                 0.01 0.01];
            

            BB{1} = [0 0
                    0 0];
    
            B =[-0.02 -0.77
                    0.33 -1.31];
             %B =[-0.00 0.1
             %       0.0 -0.0];
  
            %C = [0.08 0
            %     0.06 0];
            
            C = [1.0 1
                 1.0 1];
   end             
end
