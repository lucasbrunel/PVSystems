%Initialising PAC caluclation for looping in main code
Ns = 14; % Number of panels in series
Np = 4; %Number of parallel strings
Ntot = Ns*Np; %Total number of panels

Vdc = 31.9*Ns;
%Pdc = 280*Ntot;
Pdc = P_DC_tot;

%Inverter Parameters
Pac0 = 42000;
Pdc0 = 44035.6901;
Vdc0 = 309.9533333;
Ps0 = 289.9353235;
C0 = -7.77e-07;
C1 = 5.64e-05;
C2 = 2.23e-03;
C3 = 2.13e-04;

A = Pdc0*(1+C1*(Vdc-Vdc0));
B = Ps0*(1+C2*(Vdc-Vdc0));
C = C0*(1+C3*(Vdc-Vdc0));
Pac = zeros(1,8760);
for i = 1:8760
    Pac(i) = ((Pac0/(A-B))-C*(A-B))*(Pdc(i)-B)+C*((Pdc(i)-B)^2);
    if Pac(i) < 0
        Pac(i) = 0;
    end
end

Output_final = sum(Pac); % THIS IS THE FINAL OUTPUT OF THE ENTIRE SYSTEM!!!

effy = Output_final/P_DC_annual;

ACeff = zeros(1,8760);
for i =1:8760
    ACeff(i) = Pac(i)/Pdc(i) *100;
end

