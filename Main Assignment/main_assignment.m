%Main Assignment 3
%Santiago, Chile, Load profile 3
%Lat: -33.447487
%Long: -70.673676

clear all

%% Task 1 - Load Profile
load_profile = getLoadProfileA3(3); %Plots the load
%load_profile = getLoadProfileA3(3,true);


%% Task 2 - Irradiance Calculation
% Variables
meteodata = load('Santiago.mat');
GHI = meteodata.G_Gh;   %Global horizontal Irradiance
DHI = meteodata.G_Dh;   %Diffuse horizontal Irradiance
DNI = meteodata.G_Bh;   %Global Direct Irradiance
sun_azim_fix = meteodata.Az;
sun_alt = meteodata.hs;
albedo = 0.15;

% Calculations
sun_azim = sun_azim_fix+180;  % Correction on Meteonorm's azimuth convention
sun_Zen = 90-sun_alt; 	      % Correct calculation of Sun Zenith

portrait_modules = load('portrait_modules.mat');
landscape_modules = load('landscape_modules.mat');
skyline_landscape = load('landscape_skylines.mat');
skyline_portrait = load('portrait_skylines.mat');
load('building2020.mat','building_faces','building_vertices');
cb_limits = [0.2 1.5];

%figure(1) %Portrait
plot3DBuildings(building_vertices,building_faces);
for i = 1:8
    skyline = skyline_portrait;
    if i == 1 || 2 || 5 || 6
        s_ix = i;
        m_ix = [1:36];
        m_tilt = 14.14111023;
        
        if i == 1 || 5
            m_azim = 90;
        else
            m_azim = 270;
        end
       
        irrs = zeros(1,length(m_ix));
        for j = 1:length(m_ix)
            
            %calculate yearly irradiation
            sf = calculateShadingFactor(skyline.skylines{i, 1}{1, j}, sun_azim, sun_alt);
            svf = svfCalculator(m_azim, m_tilt, skyline.skylines{i, 1}{1, j});
            G_dif = svf*DHI;
            G_ref = albedo*(1-svf)*GHI;
            cos_aoi = cosd(sun_Zen).*cosd(m_tilt)+sind(m_tilt).*sind(sun_Zen).*cosd(sun_azim-m_azim);
            cos_aoi(cos_aoi<0) = 0;
            G_dir = DNI.*cos_aoi.*sf';
            
            irrs(j) = sum(G_dir+G_dif+G_ref)/1e6;
            
        end
        
        plotModulesOnRoof('portrait_modules',s_ix,m_ix,'irradiation',irrs,cb_limits); 
        
    else
        s_ix = i;
        m_ix = [1:80];
        m_tilt = 59.28602106;
        
        if i == 3 || 7
            m_azim = 180;
        else
            m_azim = 0;
        end
        
        irrs = zeros(1,length(m_ix));
        for j = 1:length(m_ix)
            
            %calculate yearly irradiation
            sf = calculateShadingFactor(skyline.skylines{i, 1}{1, j}, sun_azim, sun_alt);
            svf = svfCalculator(m_azim, m_tilt, skyline.skylines{i, 1}{1, j});
            G_dif = svf*DHI;
            G_ref = albedo*(1-svf)*GHI;
            cos_aoi = cosd(sun_Zen).*cosd(m_tilt)+sind(m_tilt).*sind(sun_Zen).*cosd(sun_azim-m_azim);
            cos_aoi(cos_aoi<0) = 0;
            G_dir = DNI.*cos_aoi.*sf';
            
            irrs(j) = sum(G_dir+G_dif+G_ref)/1e6;
            
        end
        hold on
        plotModulesOnRoof('portrait_modules',s_ix,m_ix,'irradiation',irrs,cb_limits);
    end
end

%Irradiance Calculation
% m_azim = [0, 90, 180, 270       
%           0, 90, 180, 270];
% m_tilt = [14.14111023, 14.14111023, 14.14111023, 14.14111023 
%           59.28602106, 59.28602106, 59.28602106, 59.28602106];
m_irradiation_l = zeros(size(m_tilt));
m_irradiation_p = zeros(size(m_tilt));
% skyline_landscape = load('landscape_skylines.mat');
% skyline_portrait = load('portrait_skylines.mat');

% for i = 1:2
%     if i == 1
%         skyline = skyline_landscape;
%     elseif i == 2
%         skyline = skyline_portrait;
%     end
%     for k = 1:4
%         for j = 1:2
%             sf = calculateShadingFactor(skyline.skylines{1}{1}, sun_azim, sun_alt);
%             svf = svfCalculator(m_azim(1,k), m_tilt(j,1), skyline);
%             G_dif = svf*DHI;
%             G_ref = albedo*(1-svf)*GHI;
%             cos_aoi = cosd(sun_Zen).*cosd(m_tilt(k))+sind(m_tilt(k)).*sind(sun_Zen).*cosd(sun_azim-m_azim(k));
%             cos_aoi(cos_aoi<0) = 0;
%             G_dir = DNI.*cos_aoi.*sf';
%             if i == 1
%                 m_irradiation_l(j,k) = sum(G_dir+G_dif+G_ref)/1e3;  %in kWh/m2
%             elseif i == 2
%                 m_irradiation_p(j,k) = sum(G_dir+G_dif+G_ref)/1e3;
%             end
%         end
%     end
% end

% red_mount_l = m_irradiation_l(2,1);
% green_mount_l = m_irradiation_l(1,2);
% yellow_mount_l = m_irradiation_l(2,3);
% blue_mount_l = m_irradiation_l(1,4);
% 
% red_mount_p = m_irradiation_p(2,1);
% green_mount_p = m_irradiation_p(1,2);
% yellow_mount_p = m_irradiation_p(2,3);
% blue_mount_p = m_irradiation_p(1,4);

%% Task 3 - PV Module Selection
%Solar Tech TS60-6M3-280S 
Pnom = 280;     %W
eff_mod = 0.172;     %module efficiency under STC
eff_mod_est = 0.16;         %module estimate with svf, etc
price_mod = 0.41;      %euro/Wp
A_mod = 1.7;        %m2

%total_irradiation = (green_mount+blue_mount)*(40*4*1.7)+(red_mount+yellow_mount)*(81*4*1.7);


%% Task 4
%System Losses
eff_inv = 0.91;
eff_cable = 0.99;
eff_system = eff_mod_est*eff_inv*eff_cable;

ESH = (sum(GHI)/(1000*8760))*24;    %ESH in Santiago, Chile
X_gen = 0.75;    
annual_consumption = sum(load_profile);     %Total annual consumption in Wh
gen_req = (X_gen*annual_consumption);         %Wh
p_system_req = (gen_req/(365*ESH*eff_system))/1e3;      %kWp

%Task 5
%System sizing
n_module = gen_req/(1000*ESH*365*eff_system*1.7);

