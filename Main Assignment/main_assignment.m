%Main Assignment 3 - Team 42 - Supervisor Alba
%Santiago, Chile, Load profile 3
clc
clear all

%% Variables
% Geographical variables
Lat = -33.447487;
Long = -70.673676;


%% Task 1 - Load Profile
load_profile = getLoadProfileA3(3);

%Need to make bar plot of monthly demand

%% Task 2 - Irradiance Calculation
meteodata = load('Santiago.mat');
GHI = meteodata.G_Gh;
DHI = meteodata.G_Dh;
DNI = meteodata.G_Bh;
sun_azim_fix = meteodata.Az;
sun_alt = meteodata.hs;
albedo = 0.15;

%
sun_azim = sun_azim_fix+180;  % Correction on Meteonorm's azimuth convention
sun_Zen = 90-sun_alt; 	      % Correct calculation of Sun Zenith

%Calculating the Irradiance on each roof orientation and tilt.
m_azim = [0, 90, 180, 270       
          0, 90, 180, 270];
m_tilt = [14.14111023, 14.14111023, 14.14111023, 14.14111023 
          59.28602106, 59.28602106, 59.28602106, 59.28602106];
m_irradiation_l = zeros(size(m_tilt));
m_irradiation_p = zeros(size(m_tilt));
skyline_landscape = load('landscape_skylines.mat');
skyline_portrait = load('portrait_skylines.mat');

%Need to incorporate shading factor
%Should irradiation be the same for landscape and portait

for i = 1:2
    if i == 1
        skyline = skyline_landscape;
    elseif i == 2
        skyline = skyline_portrait;
    end
    for k = 1:4
        for j = 1:2
            svf = svfCalculator(m_azim(1,k), m_tilt(j,1), skyline);
            G_dif = svf*DHI;
            G_ref = albedo*(1-svf)*GHI;
            cos_aoi = cosd(sun_Zen).*cosd(m_tilt(k))+sind(m_tilt(k)).*sind(sun_Zen).*cosd(sun_azim-m_azim(k));
            cos_aoi(cos_aoi<0) = 0;
            G_dir = DNI.*cos_aoi;
            if i == 1
                m_irradiation_l(j,k) = sum(G_dir+G_dif+G_ref)/1e3;  %in kWh/m2
            elseif i == 2
                m_irradiation_p(j,k) = sum(G_dir+G_dif+G_ref)/1e3;
            end
        end
    end
end

red_mount = m_irradiation_l(2,1);
green_mount = m_irradiation_l(1,2);
yellow_mount = m_irradiation_l(2,3);
blue_mount = m_irradiation_l(1,4);

%% Task 3 - PV Module Selection
X_gen = 0.75;
annual_consumption = sum(load_profile);     %Total annual consumption in Wh
gen_req = (X_gen*annual_consumption)/1000;         %kWh
p_system = gen_req/8760;            %kW
total_irradiation = (green_mount+blue_mount)*(40*4*1.7)+(red_mount+yellow_mount)*(81*4*1.7);

%% Task 4&5 - PV System Sizing


