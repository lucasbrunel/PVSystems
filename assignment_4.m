%% Assignment 4, Determine oprating efficicency of a JAP72S09-345/SC PV module
clc
clear all


%% Initialisation

%PV module data at STC
Pmax = 345; %Maximum Power Point [W]
Voc = 46.68; %Open Circuit Voltage [V]
Vmp = 38.04; %Maximum Power Voltage [V]
Isc = 9.55; %Short Circuit Current [A]
Imp = 9.07; %Maximum Power Current [A]
Eff = 0.175; %Module Efficiency [%(decimal)]

%PV module data at NOCT
Pmax = 256; %Maximum Power Point [W]
Voc = 44.16; %Open Circuit Voltage [V]
Vmp = 36.03; %Maximum Power Voltage [V]
Isc = 7.62; %Short Circuit Current [A]
Imp = 7.11; %Maximum Power Current [A]

%Environmental data
Gm = ; %Incident irradiation on module [W/m^2]
Am = ; %Module surface area [m^2]

