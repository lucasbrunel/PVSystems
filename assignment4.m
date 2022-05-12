%% Assignment 4, Determine oprating efficicency of a JAP72S09-345/SC PV module
clc
clear all

%% Initialisation

%PV module data at STC
Pmax_stc = 345; %Maximum Power Point [W]
Voc_stc = 46.68; %Open Circuit Voltage [V]
Vmp_stc = 38.04; %Maximum Power Voltage [V]
Isc_stc = 9.55; %Short Circuit Current [A]
Imp_stc = 9.07; %Maximum Power Current [A]
Eff_stc = 0.175; %Module Efficiency [%(decimal)]

%PV module data at NOCT
Pmax_noct = 256; %Maximum Power Point [W]
Voc_noct = 44.16; %Open Circuit Voltage [V]
Vmp_noct = 36.03; %Maximum Power Voltage [V]
Isc_noct = 7.62; %Short Circuit Current [A]
Imp_noct = 7.11; %Maximum Power Current [A]

%Geographical data - Phoenix, Arizona
Latitude = 33.433; %Degrees from North
Longitude = 112.017; % Degrees from West
Panel_tilt = 25; %Degrees, facing south.

%Black Object data
az_min = 140; %Black object azimuth limits [Degrees]
az_max = 190;
alt_min = 0; %Black object altitude limits [Degrees]
alt_max = 65;

%Environmental data
meteodata = readmatrix('Phoenix_AZ-hour.csv'); 
Gm = meteodata(:,7);    %Incident irradiation on module [W/m^2]
G_stc = 1000;      %Irradiation under STC
%Gm_ref = ;
Am = 1.971084; %Module surface area [m^2]

%Other parameters
n = 1.2;    %ideality factor
k_b = 1.38e-23; %boltzmann
q = 1.6e-19;     %charge e-
Ta = 25+273;    %ambient temp
a = -3.58;  %sandia model constants
b = -0.113;
w = meteodata(:,12);    %wind speed
FF = (Imp_stc*Vmp_stc)/(Isc_stc*Voc_stc);

%Calculations

Tm = zeros(1,8760);
Voc = zeros(1,8760);
Isc = zeros(1,8760);
Pmp = zeros(1,8760);

for i = 1:8760
    
    Tm(i) = Gm(i)*exp(a + b*w(i)) + Ta;
    Voc(i) = Voc_stc + ((n*k_b*Tm(i))/q)*log(Gm(i)/G_stc);
    Isc(i) = Isc_stc*(Gm(i)/G_stc);
    Pmp(i) = FF*Voc(i)*Isc(i);
    
end



