function [Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust] = read_input(inputfile, sat_id)
%READ_INPUT Reads a file containing the initial x, y, and z coordinates,
%the initial x, y, and z velocities, the start and end times the engine is
%on, and the max thrust produced by the engine and reassigns those values
%into variables
%Call format:[Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust] = read_input(inputfile, sat_id)

S = importdata(inputfile);
[m,~] = size(S.data);

if (sat_id > m) || (sat_id < 1)
    Xo = NaN;
    Yo = NaN;
    Zo = NaN;
    Uo = NaN;
    Vo = NaN;
    Wo = NaN;
    tstart = NaN;
    tend = NaN;
    maxthrust = NaN;
    
    warning('Error. Input is an invalid Satellite ID.');
else
    [r,~] = find(S.data(:,1) == sat_id);
    Xo = S.data(r,2);
    Yo = S.data(r,3);
    Zo = S.data(r,4);
    Uo = S.data(r,5);
    Vo = S.data(r,6);
    Wo = S.data(r,7);
    tstart = S.data(r,8);
    tend = S.data(r,9);
    maxthrust = S.data(r,10);
end

end