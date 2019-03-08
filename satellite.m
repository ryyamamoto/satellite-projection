function [T, X, Y, Z, U, V, W] = satellite(Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust)
% SATELLITE Calculates the time, x, y, and z coordinates, and x, y, and z
% velocities of a satellite in orbit around earth given initial x, y, and z
% coordinates, initial x, y, and z velocities, the start and stop times in
% which the engine is on, and the max thrust of the satellite
% Call format:[T, X, Y, Z, U, V, W] = satellite(Xo, Yo, Zo, Uo, Vo, Wo, tstart, tend, maxthrust)

global G M m;

n = 1;
dt = 1;
T(n) = 0;
X(n) = Xo;
Y(n) = Yo;
Z(n) = Zo;
U(n) = Uo;
V(n) = Vo;
W(n) = Wo;
dist = 0;

while dist < 4.2*10^8
    [Xthrust, Ythrust, Zthrust] = engine(tstart, tend, maxthrust, T(n), U(n), V(n), W(n));
    U(n+1) = U(n) + ((Xthrust/m)-(G*M*X(n))/((X(n)^2+Y(n)^2+Z(n)^2)^(3/2)))*dt;
    V(n+1) = V(n) + ((Ythrust/m)-(G*M*Y(n))/((X(n)^2+Y(n)^2+Z(n)^2)^(3/2)))*dt;
    W(n+1) = W(n) + ((Zthrust/m)-(G*M*Z(n))/((X(n)^2+Y(n)^2+Z(n)^2)^(3/2)))*dt;
    X(n+1) = X(n) + U(n+1)*dt;
    Y(n+1) = Y(n) + V(n+1)*dt;
    Z(n+1) = Z(n) + W(n+1)*dt;
    T(n+1) = T(n) + dt;
    dist = dist + sqrt((X(n+1)-X(n))^2+(Y(n+1)-Y(n))^2+(Z(n+1)-Z(n))^2);
    n = n+1;
end

end