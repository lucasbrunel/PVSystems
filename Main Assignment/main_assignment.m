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

% Angle corrections
sun_azim = sun_azim_fix+180;  % Correction on Meteonorm's azimuth convention
sun_Zen = 90-sun_alt; 	      % Correct calculation of Sun Zenith

portrait_modules = load('portrait_modules.mat');
landscape_modules = load('landscape_modules.mat');
skyline_landscape = load('landscape_skylines.mat');
skyline_portrait = load('portrait_skylines.mat');
load('building2020.mat','building_faces','building_vertices');
cb_limits = [0.2 1.5];

figure(1) %Portrait
title('Portrait')
plot3DBuildings(building_vertices,building_faces);
roof_irradiance_p = zeros(1,8); % Calculating total Irradiance on each roof section
for i = 1:8
    skyline = skyline_portrait;
    if i == 1 || i == 2 || i == 5 || i == 6
        s_ix = i;
        m_ix = [1:36];
        m_tilt = 14.14111023;
        
        if i == 1 || i == 5
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
            roof_irradiance_p(i) = roof_irradiance_p(i) + irrs(j);
            
        end
        
        plotModulesOnRoof('portrait_modules',s_ix,m_ix,'irradiation',irrs,cb_limits); 
        if i==1
            irr_1_p=zeros(1,length(irrs));
            irr_1_p=sum(irrs)/length(irrs);
        elseif i==2
            irr_2_p=zeros(1,length(irrs));
            irr_2_p=sum(irrs)/length(irrs);
        elseif i==5
            irr_5_p=zeros(1,length(irrs));
            irr_5_p=sum(irrs)/length(irrs);
        else
            irr_6_p=zeros(1,length(irrs));
            irr_6_p=sum(irrs)/length(irrs);
        end
    else
        s_ix = i;
        m_ix = [1:80];
        m_tilt = 59.28602106;
        
        if i == 3 || i == 7
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
            roof_irradiance_p(i) = roof_irradiance_p(i) + irrs(j);
            
        end
        
        hold on
        plotModulesOnRoof('portrait_modules',s_ix,m_ix,'irradiation',irrs,cb_limits);
         if i==3
            irr_3_p=zeros(1,length(irrs));
            irr_3_p=sum(irrs)/length(irrs);
        elseif i==4
            irr_4_p=zeros(1,length(irrs));
            irr_4_p=sum(irrs)/length(irrs);
        elseif i==7
            irr_7_p=zeros(1,length(irrs));
            irr_7_p=sum(irrs)/length(irrs);
        else
            irr_8_p=zeros(1,length(irrs));
            irr_8_p=sum(irrs)/length(irrs);
        end
        
    end
end

figure(2) %Landscape
title('Landscape')
plot3DBuildings(building_vertices,building_faces);
roof_irradiance_l = zeros(1,8); % Calculating total Irradiance on each roof section
for i = 1:8
    skyline = skyline_landscape;
    if i == 1 || i == 2 || i == 5 || i == 6
        s_ix = i;
        m_ix = [1:40];
        m_tilt = 14.14111023;
        
        if i == 1 || i == 5
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
            roof_irradiance_l(i) = roof_irradiance_l(i) + irrs(j);
            
        end
        
        plotModulesOnRoof('landscape_modules',s_ix,m_ix,'irradiation',irrs,cb_limits); 
        if i==1
            irr_1_l=zeros(1,length(irrs));
            irr_1_l=sum(irrs)/length(irrs);
        elseif i==2
            irr_2_l=zeros(1,length(irrs));
            irr_2_l=sum(irrs)/length(irrs);
        elseif i==5
            irr_5_l=zeros(1,length(irrs));
            irr_5_l=sum(irrs)/length(irrs);
        else
            irr_6_l=zeros(1,length(irrs));
            irr_6_l=sum(irrs)/length(irrs);
        end
    else
        s_ix = i;
        m_ix = [1:81];
        m_tilt = 59.28602106;
        
        if i == 3 || i == 7
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
            roof_irradiance_l(i) = roof_irradiance_l(i) + irrs(j);
            
        end
        
        hold on
        plotModulesOnRoof('landscape_modules',s_ix,m_ix,'irradiation',irrs,cb_limits);
         if i==3
            irr_3_l=zeros(1,length(irrs));
            irr_3_l=sum(irrs)/length(irrs);
        elseif i==4
            irr_4_l=zeros(1,length(irrs));
            irr_4_l=sum(irrs)/length(irrs);
        elseif i==7
            irr_7_l=zeros(1,length(irrs));
            irr_7_l=sum(irrs)/length(irrs);
        else
            irr_8_l=zeros(1,length(irrs));
            irr_8_l=sum(irrs)/length(irrs);
        end
        
    end
end


%% Task 3 - PV Module Selection
%Solar Tech TS60-6M3-280S 
Pnom = 280;     %W
Vmp_stc = 31.9;     %Vmp [V]
Imp_stc = 8.8;      %Imp [A]
Voc_stc = 39.56;    %V
Isc_stc = 9.46;     %A
eff_mod = 0.172;     %module efficiency under STC
eff_mod_est = 0.16;         %module estimate with svf, etc
price_mod = 0.41;      %euro/Wp
A_mod = 1.64*0.992;        %m2


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

%% Task 5
%System sizing - How many panels are in series and parallel based on
%inverter specifications.
n_mod = ceil(gen_req/(1000*ESH*365*eff_system*A_mod));
%series = ;
%parallel = ;

%% Task 6
%DC yield calculation
%constants
k_b = 1.38e-23; %boltzmann
n = 1.2;    %ideality factor (CHECK THIS)
k_b = 1.38e-23; %boltzmann
q = 1.6e-19;     %charge e-
Ta = 25+273;    %ambient temp
FF = (Imp_stc*Vmp_stc)/(Isc_stc*Voc_stc);
Tm = 20+273;      %PLACEHOLDER - use sandia model to calculate?
k = -0.0035;        %(degrees C)^-1 (for c-Si)

%calculations
G_aoi = irr_1_p*1e6;       %PLACEHOLDER - should be exact irradiation on selected modules
                           %calculate average irradiation on all modules selected?
G_stc = 1000*8760;      %Wh/m2
Isc_25C = Isc_stc*(G_aoi/G_stc);    %A
Voc_25C = Voc_stc + ((n*k_b*Ta)/q)*log(G_aoi/G_stc)*n_mod;       %V
Pmpp_25C = FF*Voc_25C*Isc_25C;      %W
eff_25C = Pmpp_25C/(A_mod*G_aoi);   %efficiency at 25 C
eff_Tm = eff_25C*(1 + k*(Tm - Ta)); %efficiency at module temp
P_DC = eff_Tm*A_mod*G_aoi;          %annual DC output before BoS [W]
P_STC = 1000*A_mod;                %W
DCY = P_DC/P_STC;


