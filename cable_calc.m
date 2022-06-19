%Cable Caluculation

Isc = 9.46;
Voc = 39.56;
Pdc = 1.87e7; %Wh

Th = 35.3; %Max Ambient Temperature; [C]
T0 = 33; %Correction factor (adder) for sun exposed cable [C]
Ttot = Th + T0;

Nm = 8; % Number of modules per string (series)
Nstr = 6; % Number of strings (parallel)
Linv = 17; % Length of cable from modules to inverter
Lmm = 1; % Distance between series connection of modules
Lstr = 1.7; % Distance between strongs connetcted in parallel
Lrt = 16; % Distance unaccounted for

LcableMM = Lmm*Nstr*(Nm-1);
LcableStrStr = 2*Lstr*(Nstr-1) + (2*Linv + Lrt);
Exposed_cable = 2*Lstr*(Nstr-1) + Lrt; % Amount of cable exposed to the sun

Ltot = LcableMM + LcableStrStr; % Total length of cabling required

Imax = Isc*Nstr*1.25*1.25; % Max current which can occur with safety factors.
Vmax = Voc*Nm; % Max voltage which can occur in the system

sigma_Cu = 59.6; %Conductivity of copper [S m / mm^2]
sigma_Al = 35.5; %Conductivity of aluminium [S m / mm^2]

A = [4,6,10,16]; % Cross sectional area of cable [mm^2]

R_Cu = 1/sigma_Cu * Ltot./A; % Resistance of Copper cable [Ohms]
R_Al = 1/sigma_Al * Ltot./A; % Resistance of Aluminium cable [Ohms]

Ploss_Cu = R_Cu * Imax^2;
Ploss_Al = R_Al * Imax^2;

eff_Cu = Pdc./(Pdc+Ploss_Al);
eff_Al = Pdc./(Pdc+Ploss_Al);
