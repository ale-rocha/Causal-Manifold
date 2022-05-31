function [q] = Hemo(Z, U, P_SD, A)

        nRegions  = size(A,1);
        simulationLength = size(U, 2);
        params = 6;
        f_priori = zeros(nRegions,params);
  
        %asignar prioridades 
        kj = [0.69;0.63];
        yj = [0.28;0.34];
        tj = [2.11;1.97];
        tv = [4.12;0.92];
        
        f=[];
        f = [f,f_priori];
        disp("size f");
        disp(size(f));
        q = [];
         for t = 1:simulationLength
             H = [0.64 0.32 2.00 0.32 0.32 2.00];

             % exponentiation of hemodynamic state variables
             %---------------------------------------------------
             %x(:,3:6) = exp(x(:,3:6));
             disp("Equis values");
             disp(x);

             % signal decay
             sd = 0.64*exp(kj);
             % autoregulatory feedback
             af = 0.32.*exp(yj);
             % transit time
             tt = 2.00.*exp(tj);
             % viscoelastic time constant 
             tv = 2.00.*exp(tv); 

             %Signal activity
             x(:,1) = Z(:,t);
             % outflow f(v) (steady state)
             fv_s = x(:,4).^(1/0.32);
             
             % implement differential state equation f = dx/dt (hemodynamic)
             %--------------------------------------------------------------------------
             f(:,2)   = x(:,1) - sd.*x(:,2) - af.*(x(:,3) - 1);
             mul1 = sd.*x(:,2);
             mul2 = af.*(x(:,3) - 1);

             f(:,3)   = x(:,2)-x(:,3);
             f(:,4)   = (x(:,3) - fv_s)./((tt+tv).*x(:,4));
             
             % outflow (dynamic state) 
             fv_d = fv_s + tv.*x(:,4).*f(:,4);
             % oxygen extraction fraction 
             ff = (1 - (1 - 0.32).^(1./x(:,3)))/0.32;
             f(:,5)   = (x(:,3).*ff - fv_d.*x(:,5)./x(:,4))./(tt.*x(:,5));
             disp("f(:,5)  -----")
             f(:,6)   = (x(:,3) - fv_d  .* x(:,6)./x(:,4))./(tt.*x(:,6));
             %f        = f(:);

             
             N = [0.65 0.071 2]; 
             N = [0.65 0.071 2]; 
             % baseline dxy-hb concentration 
             base_hbr = N(2) .* (1-N(1)); 

             % calculate changes in hemoglobin concentration
             dq = (x(:,5)-1).*base_hbr; % dxy-Hb
             dp = (x(:,6)-1).*N(2); % total Hb
             dh = dp - dq; % oxy-Hb
             q = [q,f(:,2)];

         end
         
         %plot(transpose(q));
         %shg;
         
         
end
