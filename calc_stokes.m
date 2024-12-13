function [Dp_s,Cc_s] = calc_stokes(Dp_a,Cc_a,density)
%CALC_STOKES Calculates particle stokes diameter using iteration

%guess Dp_s = Dp_a
Dp_s = Dp_a;
%guess Cc_s = Cc_a
Cc_s = Cc_a;

convergence_limit = 0.000000000000000000001;
delta_Dp_s = 1;
i = 0;

debug = false;

while delta_Dp_s > convergence_limit
    %calculate Dp_s & Cc_s
    Dp_s_old = Dp_s;
    Dp_s = Dp_a/(sqrt(density*(Cc_s/Cc_a)));
    Cc_s = 1+(2/(76*Dp_s))*(6.32+2.01*exp(-0.1095*76*Dp_s));
    delta_Dp_s = abs(Dp_s - Dp_s_old);
    
    %debug
    if debug == true
        i = i + 1;
        displaytext = "iterations = " + i + ", delta = " + delta_Dp_s + ", Dp_s = " + Dp_s + ", Cc_s = " + Cc_s;
        disp(displaytext);
    end
end

end