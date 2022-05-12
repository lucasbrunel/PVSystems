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
G_stc = 1000;      %Irradiation under STC
meteodata = readmatrix('Phoenix_AZ-hour.csv'); 
GHI = meteodata(:,7);    %Incident irradiation on module [W/m^2]
DHI = meteodata(:,8);
DNI = meteodata(:,9);

Am = 1.971084; %Module surface area [m^2]

%Other parameters
n = 1.2;    %ideality factor
k_b = 1.38e-23; %boltzmann
q = 1.6e-19;     %charge e-
Ta = 25+273;    %ambient temp
a = -3.58;  %sandia model constants
b = -0.113;
w = meteodata(:,12);    %wind speed
albedo = 0.3;
FF = (Imp_stc*Vmp_stc)/(Isc_stc*Voc_stc);
m_azim = 0;     %module orientation
m_tilt = 25;
sun_azim_fix = meteodata(:,5);
sun_azim = sun_azim_fix+180;
sun_alt = meteodata(:,6);
sun_Zen = 90-sun_alt;

%Sky view factor
poa_tilt = m_tilt;
poa_azim = m_azim+180;
ROWS = 180;
COLS = 360;
center_azim = repmat(linspace(0+360/(2*COLS),360-360/(2*COLS),COLS),ROWS,1);
center_alt = repmat(linspace(90-180/(2*ROWS),-90+180/(2*ROWS),ROWS)',1,COLS);
skyline_prof = true(size(center_azim));
skyline_prof(center_azim>140 & center_azim<190 & center_alt>0 & center_alt<65) = false;
svf = svfCalculator(poa_azim,poa_tilt,'skyline',skyline_prof,'plotting',true);

%Calculations

Gm = zeros(1,8760);
G_dif = zeros(1,8760);
G_ref = zeros(1,8760);
G_dir = zeros(1,8760);
cos_aoi = zeros(1,8760);

for k=1:8760 
    G_dif(k) = svf*DHI(k);
    G_ref(k) = albedo*GHI(k)*((1-cosd(m_tilt))/2);
    cos_aoi(k) = cosd(sun_Zen(k))*cosd(m_tilt)+sind(m_tilt)*sind(sun_Zen(k))*cosd(sun_azim(k)-m_azim);
    if cos_aoi(k) < 0
        cos_aoi(k) = 0;
    end
    G_dir(k) = DNI(k)*cos_aoi(k);
    Gm(k) = G_dir(k)+G_dif(k)+G_ref(k);    
end

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


