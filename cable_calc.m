%% DC Cable Caluculation
%Panel Parameters
Isc = 9.46;
Voc = 39.56;
Vmp = 31.9;
Pdc = 1.87e7; % Wh

%% Ampacity req
Th = 35.3; %Max Ambient Temperature; [C]
T0 = 22; %Correction factor (adder) for sun exposed cable [C]
Ttot = Th + T0;
F1 = 0.71;
F2 = 1;

%max_ISC = (F1*F2*98)/1.56; %Tells us the max Isc (number of panels in
%series)

%% Array setup
Nm = 14; % Number of modules per string (series)
Nstr = 4; % Number of strings (parallel)
Ntot = Nm*Nstr; %Total number of panels

Linv = 17; % Length of cable from modules to inverter
Lmm = 1; % Distance between series connection of modules
Lstr = 1.7; % Distance between strongs connetcted in parallel
Lrt = 16; % Distance unaccounted for

LcableMM = Lmm*Nstr*(Nm-1);
LcableStrStr = 2*Lstr*(Nstr-1) + (2*Linv + Lrt);
Exposed_cable = 2*Lstr*(Nstr-1) + Lrt; % Amount of cable exposed to the sun

Ltot = LcableMM + LcableStrStr; % Total length of cabling required

Imax = (Isc*Nstr*1.25*1.25)/(F1*F2); % Max current which can occur with safety factors.
Vmax = Voc*Nm; % Max voltage which can occur in the system

sigma_Cu = 59.6; % Conductivity of copper [S m / mm^2]
sigma_Al = 35.5; % Conductivity of aluminium [S m / mm^2]

%A = [4,6,10,16]; % Cross sectional area of cable [mm^2]
A = 10;

R_Cu = 1/sigma_Cu * Ltot./A; % Resistance of Copper cable [Ohms]
%R_Al = 1/sigma_Al * Ltot./A; % Resistance of Aluminium cable [Ohms]

Ploss_Cu = R_Cu * Imax^2;
%Ploss_Al = R_Al * Imax^2;

eff_Cu = Pdc./(Pdc+Ploss_Cu);
%eff_Al = Pdc./(Pdc+Ploss_Al);

%% AC cables

V_grid = 220; %Voltage of the grid in Chile
PAC = 1.52e4;
IAC = sqrt(3)*PAC/V_grid*3;
L_ac = 100; %[m] of cable from inverter to AC grid connection

A_ac = 6;

Rac_Cu = 1/sigma_Cu * L_ac./A_ac; % Resistance of Copper cable [Ohms]

Pacloss_Cu = 2* Rac_Cu * Imax^2;

%eff_Cu_ac = PAC/(PAC+Pacloss_Cu);
eff_Cu_ac = 0.98;

%If PDC is greater than 5kW then we need three phase (3 phase + neutral)

%% Inverter Efficiency
%Initialising PAC caluclation for looping in main code

Vdc_mpp = 31.9*Nm;
Pdc = P_DC_tot; % Parameter from irradiance_calculations file

%Inverter Parameters
Pac0 = 42000;
Pdc0 = 44035.6901;
Vdc0 = 309.9533333;
Ps0 = 289.9353235;
C0 = -7.77e-07;
C1 = 5.64e-05;
C2 = 2.23e-03;
C3 = 2.13e-04;

A = Pdc0*(1+C1*(Vdc_mpp-Vdc0));
B = Ps0*(1+C2*(Vdc_mpp-Vdc0));
C = C0*(1+C3*(Vdc_mpp-Vdc0));
Pac = zeros(1,8760);
for i = 1:8760
    Pac(i) = ((Pac0/(A-B))-C*(A-B))*(Pdc(i)-B)+C*((Pdc(i)-B)^2);
    if Pac(i) < 0
        Pac(i) = 0;
    end
end

Pac_inv = sum(Pac); % THIS IS THE FINAL OUTPUT OF THE ENTIRE SYSTEM!!!

effy = Pac_inv/P_DC_annual;

ACeff = zeros(1,8760);
for i =1:8760
    ACeff(i) = Pac(i)/Pdc(i) *100;
end

%% Final power output

%This is the final power output including all losses: mismatch, thermal,
%cabling and Inverter losses
Pac_final = Pac_inv * eff_Cu * eff_Cu_ac;

