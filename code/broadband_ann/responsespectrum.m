function [A, V, D, PSV, PSA, T] = responsespectrum(accel, ee, T, dt)
% ee - damping in % - 5 is recommended
% y - gamma in newmark's method - 0.5 is recommended
% b - beta in newmark's method - 0.25 is recommended
% td - time till which you want graph to be plotted
y = 0.5;
b = 0.25;
uo = 0;
vo = 0;
m = 1;
z = ee/100;
na = length(accel);
nl = 2*na;
accel = [accel;zeros(nl-na,1)];
p = -m*accel;
A = zeros(length(T),1);% acclelration response spectrum - total accelaration
V = zeros(length(T),1);% velocity response spectrum - relative velocity
D = zeros(length(T),1);% displacement response spectrum - relative displacement
for j = 1:length(T)
    
    fn = 1/T(j);
    wn = 2*pi*fn;
    k = m*wn^2;
    c = 2*m*wn*z;
    
    u = zeros(nl,1);
    v = zeros(nl,1);
    ac = zeros(nl,1);
    
    u(1) = uo;
    v(1) = vo;
    ac(1) = (p(1)-c*vo-k*uo)/m;
    
    kf = k + y*c/(b*dt) + m/(b*dt^2);
    a = m/(b*dt) + y*c/b;
    b2 = m/(2*b) + dt*(y/(2*b) - 1)*c;
    
    for i = 1:nl-1
        p1=p(i);
        p2=p(i+1);
        dpf = (p2 - p1) + a*v(i) + b2*ac(i);
        du = dpf/kf;
        dv = y/(b*dt)*du - (y/b)*v(i) + dt*(1 - y/(2*b))*ac(i);
        da = du/(b*dt^2) - v(i)/(b*dt) - ac(i)/(2*b);
        u(i+1) = u(i) + du;
        v(i+1) = v(i) + dv;
        ac(i+1) = ac(i) + da;
    end
    
    asd = ac + accel;
    A(j) = max(abs(asd));
    V(j) = max(abs(v));
    D(j) = max(abs(u));
end
A = [max(abs(accel(:)));A];
V = [0;V];
D = [0;D];

PSV = (2*pi./T).*D(2:end); % pseudo spectral velocity
PSV = [PSV(1); PSV];
PSA = ((2*pi./T).^2).*D(2:end); % pseudo spectral accleration
PSA = [PSA(1); PSA];

T = [0;T];
end
