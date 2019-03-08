function [Xthrust, Ythrust, Zthrust] = engine(tstart, tend, maxthrust, t, u, v, w)
% ENGINE produces the thrust needed to change satellite orbits.
% Inputs are engine start and end times (tstart, tend), the maximum thrust
% produced (maxthrust), current time (t), and current velocity components
% (u,v,w).
% Call format: [Xthrust, Ythrust, Zthrust] = engine(tstart, tend, maxthrust, t, u, v, w)

period = tend - tstart;
tpeak = tstart + 0.5*period;
if t > tstart && t < tend
    Xthrust = maxthrust*exp(-((t-tpeak)/(0.25*period))^4) ...
                        *u/sqrt(u^2+v^2+w^2);
    Ythrust = maxthrust*exp(-((t-tpeak)/(0.25*period))^4) ...
                        *v/sqrt(u^2+v^2+w^2);
    Zthrust = maxthrust*exp(-((t-tpeak)/(0.25*period))^4) ...
                        *w/sqrt(u^2+v^2+w^2);    
else
    Xthrust = 0;
    Ythrust = 0;
    Zthrust = 0;
end

end % function engine