%Main Assignment 3
%Santiago, Chile, Load profile 3
%Lat: -33.447487
%Long: -70.673676

clc
%Task 1 - Load Profile
load_profile = getLoadProfileA3(3);

%Need to make bar plot of monthly demand

%Task 2 - Irradiance Calculation
meteodata = load('Santiago.mat');
GHI = meteodata.G_Gh;
DHI = meteodata.G_Dh;
DNI = meteodata.G_Bh;
sun_azim_fix = meteodata.Az;
sun_alt = meteodata.hs;
albedo = 0.15;

%%
sun_azim = sun_azim_fix+180;  % Correction on Meteonorm's azimuth convention
sun_Zen = 90-sun_alt; 	      % Correct calculation of Sun Zenith

m_azim = [0, 90, 180, 270       
          0, 90, 180, 270];
m_tilt = [14.14111023, 14.14111023, 14.14111023, 14.14111023 
          59.28602106, 59.28602106, 59.28602106, 59.28602106];
m_irradiation = zeros(size(m_tilt));
skyline_landscape = load('landscape_skylines.mat');
skyline_portrait = load('portrait_skylines.mat');

for k=1:4
    for j = 1:2
        svf = svfCalculator(m_azim(1,k), m_tilt(j,1), skyline_landscape);
        G_dif = svf*DHI;
        G_ref = albedo*(1-svf)*GHI;
        cos_aoi = cosd(sun_Zen).*cosd(m_tilt(k))+sind(m_tilt(k)).*sind(sun_Zen).*cosd(sun_azim-m_azim(k));
        cos_aoi(cos_aoi<0) = 0;
        G_dir = DNI.*cos_aoi;
        m_irradiation(j,k) = sum(G_dir+G_dif+G_ref)/1e3;  %in kWh/m2
    end
end

red_mount = m_irradiation(2,1);
green_mount = m_irradiation(1,2);
yellow_mount = m_irradiation(2,3);
blue_mount = m_irradiation(1,4);